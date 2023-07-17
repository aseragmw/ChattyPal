import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  static Future<void> setValue(String key, dynamic value) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if (value is int) {
      await sharedPreferences.setInt(key, value);
    } else if (value is double) {
      await sharedPreferences.setDouble(key, value);
    } else if (value is String) {
      await sharedPreferences.setString(key, value);
    } else if (value is bool) {
      await sharedPreferences.setBool(key, value);
    }
  }

  static dynamic getValue(String key) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(key);
  }
}
