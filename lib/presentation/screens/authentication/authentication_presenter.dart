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

    Rx.merge([Stream.value(null), _validationSubject.stream])
        .flatMap((pin) => _checkAuthentication(pin: pin))
        .listen(_stateSubject.sink.add)
        .addTo(subscriptions);
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

  Stream<AuthenticationState> _checkAuthentication({int? pin}) async* {
    final isAuthEnabled = dataSource.isAuthenticationEnabled;

    if (isAuthEnabled) {
      if (pin != null) {
        final isValid = dataSource.validatePin(pin);

        if (isValid) {
          _actionSubject.sink.add(NavigateToHomeAction());
        }

        yield RequestAuthentication(isAuthenticated: isValid);
      } else {
        yield RequestAuthentication();
      }
    } else {
      yield Idle();
    }
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
  RequestAuthentication({this.isAuthenticated});

  final bool? isAuthenticated;
}
