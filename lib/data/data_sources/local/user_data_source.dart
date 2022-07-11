import 'package:shared_preferences/shared_preferences.dart';

abstract class UserDataSource {
  Future<void> savePin(int pin);
  Future<void> deletePin();
  bool validatePin(int pin);
  bool get isAuthenticationEnabled;
}

class UserDataSourceImpl implements UserDataSource {
  const UserDataSourceImpl({required this.storage});

  final SharedPreferences storage;

  static const _pinKey = 'pin';
  static const _authenticationStatusKey = 'authenticationStatus';

  @override
  Future<void> savePin(int pin) async {
    await storage.setInt(_pinKey, pin);
    await storage.setBool(_authenticationStatusKey, true);
  }

  @override
  bool validatePin(int pin) {
    final storedPin = storage.getInt(_pinKey);

    return storedPin == pin;
  }

  @override
  Future<void> deletePin() async {
    await storage.remove(_pinKey);
    await storage.setBool(_authenticationStatusKey, false);
  }

  @override
  bool get isAuthenticationEnabled {
    final status = storage.getBool(_authenticationStatusKey);

    return status ?? false;
  }
}
