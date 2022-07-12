import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserDataSource {
  Future<void> savePin(int pin);
  Future<void> deletePin();
  bool validatePin(int pin);
  bool get isAuthenticationEnabled;
  bool get hasPinEnabled;
  Future<bool> authenticateByFingerprint();
  Future<bool> hasFingerprintEnabled();
  Future<void> toggleFingerprintUsage();
}

class UserDataSourceImpl implements UserDataSource {
  const UserDataSourceImpl({
    required this.storage,
    required this.auth,
  });

  final SharedPreferences storage;
  final LocalAuthentication auth;

  static const _pinKey = 'pin';
  static const _authenticationStatusKey = 'authenticationStatus';
  static const _fingerprintUsageKey = 'ignoreFingerprint';

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

    final hasFingerprint = await hasFingerprintEnabled();
    if (!hasFingerprint) {
      await storage.setBool(_authenticationStatusKey, false);
    }
  }

  @override
  bool get isAuthenticationEnabled {
    final status = storage.getBool(_authenticationStatusKey);

    return status ?? false;
  }

  @override
  Future<bool> authenticateByFingerprint() async {
    try {
      final isAuthenticated = await auth.authenticate(
        localizedReason: 'Authenticate with fingerpint',
        options: const AuthenticationOptions(
          biometricOnly: true,
        ),
      );

      return isAuthenticated;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> hasFingerprintEnabled() async {
    final shouldUseFingerprint = storage.getBool(_fingerprintUsageKey);

    if (shouldUseFingerprint == null || !shouldUseFingerprint) {
      return false;
    } else {
      return true;
    }
  }

  @override
  Future<void> toggleFingerprintUsage() async {
    final shouldUseFingerprint = storage.getBool(_fingerprintUsageKey);

    final canCheckFingerprint = await auth.canCheckBiometrics;
    final isDeviceSupported = await auth.isDeviceSupported();

    if (canCheckFingerprint && isDeviceSupported) {
      if (shouldUseFingerprint != null) {
        await storage.setBool(_fingerprintUsageKey, !shouldUseFingerprint);
        await storage.setBool(
            _authenticationStatusKey, !shouldUseFingerprint || hasPinEnabled);
      } else {
        await storage.setBool(_fingerprintUsageKey, true);
        await storage.setBool(_authenticationStatusKey, true);
      }
    } else {
      await storage.setBool(_fingerprintUsageKey, false);
      await storage.setBool(_authenticationStatusKey, hasPinEnabled);
    }
  }

  @override
  bool get hasPinEnabled => storage.getInt(_pinKey) != null;
}
