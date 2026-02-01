import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// ignore: camel_case_types
class pinStorage {
  // ignore: constant_identifier_names
  static const _Storage = FlutterSecureStorage();
  static const _key = 'user pin';
  static Future<void> savepin(String pin) async {
    await _Storage.write(key: _key, value: pin);
  }

  static Future<String?> getPin() async {
    return await _Storage.read(key: _key);
  }

  static Future<void> delete() async {
    return await _Storage.delete(key: _key);
  }

  static Future<void> update(String newpin) async {
    final existingpin = await _Storage.read(key: _key);
    if (existingpin == null) {
      throw Exception('No existing pin to update');
    }
    await _Storage.write(key: _key, value: newpin);
  }
}
