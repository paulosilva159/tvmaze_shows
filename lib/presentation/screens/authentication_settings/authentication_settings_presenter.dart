import 'package:jobsity_challenge/commons/subscription_holder.dart';
import 'package:jobsity_challenge/data/data_sources/local/user_data_source.dart';
import 'package:rxdart/rxdart.dart';

class AuthenticationSettingsPresenter with SubscriptionHolder {
  AuthenticationSettingsPresenter({required this.dataSource}) {
    Rx.merge([
      Stream.value(null).flatMap((_) => _getAuthenticationStatus()),
      _upsertPinSubject.stream.flatMap((value) => _upsertPin(value)),
      _deletePinSubject.stream.flatMap((_) => _deletePin()),
    ]).listen(_stateSubject.sink.add).addTo(subscriptions);
  }

  final UserDataSource dataSource;

  final _stateSubject = BehaviorSubject<AuthenticationSettingsState>();
  Stream<AuthenticationSettingsState> get onNewState => _stateSubject.stream;

  final _upsertPinSubject = PublishSubject<int>();
  Sink<int> get onUpsertPin => _upsertPinSubject.sink;

  final _deletePinSubject = PublishSubject<void>();
  Sink<void> get onDeletePin => _deletePinSubject.sink;

  Stream<AuthenticationSettingsState> _getAuthenticationStatus() async* {
    if (dataSource.isAuthenticationEnabled) {
      yield AuthenticationEnabled();
    } else {
      yield AuthenticationDisabled();
    }
  }

  Stream<AuthenticationSettingsState> _upsertPin(int pin) async* {
    await dataSource.savePin(pin);

    yield AuthenticationEnabled();
  }

  Stream<AuthenticationSettingsState> _deletePin() async* {
    await dataSource.deletePin();

    yield AuthenticationDisabled();
  }

  void dispose() {
    _stateSubject.close();
    _deletePinSubject.close();
    _upsertPinSubject.close();
    disposeAll();
  }
}

abstract class AuthenticationSettingsState {}

class AuthenticationEnabled implements AuthenticationSettingsState {}

class AuthenticationDisabled implements AuthenticationSettingsState {}
