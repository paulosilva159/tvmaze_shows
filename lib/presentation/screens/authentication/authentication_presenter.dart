import 'package:jobsity_challenge/commons/subscription_holder.dart';
import 'package:jobsity_challenge/data/data_sources/local/user_data_source.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationPresenter with SubscriptionHolder {
  AuthenticationPresenter({
    required this.dataSource,
  }) {
    Stream.value(null)
        .debounceTime(const Duration(seconds: 1))
        .flatMap((_) => _tryNavigation())
        .listen(_actionSubject.sink.add)
        .addTo(subscriptions);

    Rx.merge([
      Stream.value(null).flatMap((_) => _checkAuthentication()),
      _validationSubject.stream.flatMap((pin) => _validatePin(pin))
    ]).listen(_stateSubject.sink.add).addTo(subscriptions);
  }

  final UserDataSource dataSource;

  final _actionSubject = BehaviorSubject<AuthenticationAction>();
  Stream<AuthenticationAction> get onNewAction => _actionSubject.stream;

  final _stateSubject = BehaviorSubject<AuthenticationState>();
  Stream<AuthenticationState> get onNewState => _stateSubject.stream;

  final _validationSubject = PublishSubject<int>();
  Sink<int> get onValidatePin => _validationSubject.sink;

  Stream<AuthenticationAction> _tryNavigation() async* {
    final isAuthEnabled = dataSource.isAuthenticationEnabled;

    if (!isAuthEnabled) {
      yield NavigateToHomeAction();
    }
  }

  Stream<AuthenticationState> _checkAuthentication() async* {
    final isAuthEnabled = dataSource.isAuthenticationEnabled;

    if (isAuthEnabled) {
      final hasFingerprintEnabled = await dataSource.hasFingerprintEnabled();

      if (hasFingerprintEnabled) {
        final isAuthenticated = await dataSource.authenticateByFingerprint();
        if (isAuthenticated) {
          _actionSubject.sink.add(NavigateToHomeAction());
        } else {
          yield const RequestAuthentication();
        }
      } else {
        yield const RequestAuthentication();
      }
    } else {
      yield Idle();
    }
  }

  Stream<AuthenticationState> _validatePin(int pin) async* {
    final isValid = dataSource.validatePin(pin);

    if (isValid) {
      _actionSubject.sink.add(NavigateToHomeAction());
    }

    yield RequestAuthentication(isAuthenticated: isValid);
  }

  void dispose() {
    _stateSubject.close();
    _actionSubject.close();
    _validationSubject.close();
    disposeAll();
  }
}

abstract class AuthenticationAction {}

class NavigateToHomeAction implements AuthenticationAction {}

abstract class AuthenticationState {}

class Idle implements AuthenticationState {}

class RequestAuthentication implements AuthenticationState {
  const RequestAuthentication({
    this.hasFingerprintEnabled = false,
    this.isAuthenticated,
  });

  final bool? isAuthenticated;
  final bool hasFingerprintEnabled;
}
