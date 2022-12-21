import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinSecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _pinNumber = 'pin';

  // Set Pin number to secure storage
  static Future setPinNumber(String pinNumber) async =>
      await _storage.write(key: _pinNumber, value: pinNumber);

  // Read Pin number from secure storage
  static Future<String?> getPinNumber() async =>
      await _storage.read(key: _pinNumber);

  // Delete Pin number from secure storage
  static deletePinNumber() async =>
      await _storage.delete(key: _pinNumber);
}
