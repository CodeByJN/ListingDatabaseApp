import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class EncryptionHelper {
  static final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  static Future<void> setEncryptedString(String key, String value) async {
    await _prefs.setString(key, value);
  }

  static Future<String?> getEncryptedString(String key) async {
    return await _prefs.getString(key);
  }
}
