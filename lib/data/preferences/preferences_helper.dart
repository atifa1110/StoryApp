
import 'package:shared_preferences/shared_preferences.dart';
class PreferencesHelper {

  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper(this.sharedPreferences);

  static const token = "token";
  static const login = "login";

  Future<String> get getToken async {
    final prefs = await sharedPreferences;
    return prefs.getString(token) ?? "";
  }

  void setToken(String value) async {
    final prefs = await sharedPreferences;
    prefs.setString(token, value);
  }

  Future<bool> get isLogin async {
    final prefs = await sharedPreferences;
    return prefs.getBool(login) ?? false;
  }

  void setLogin(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(login, value);
  }
}