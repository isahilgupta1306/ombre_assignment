import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  final String auth_token = "auth_token";
  final String display_name = "display_name";
  final String email_address = "email_address";
  late final SharedPreferences prefs;

//set data into shared preferences like this
  Future<void> setAuthToken(String auth_token) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString(this.auth_token, auth_token);
  }

  Future<void> setUserData(
      String auth_token, String display_name, String email_address) async {
    Map<String, dynamic> user = {
      'auth_token': auth_token,
      'display_name': display_name,
      'email_address': email_address
    };
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    bool result = await prefs.setString('userData', jsonEncode(user));
  }

  Future<Map<String, dynamic>> getUserData() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    String? userPref = prefs.getString('userData');

    Map<String, dynamic> userMap =
        jsonDecode(userPref!) as Map<String, dynamic>;
    print("Printing sessioned Data --> $userMap");
    return userMap;
  }

//get value from shared preferences
  Future<String?> getAuthToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? auth_token;
    auth_token = (pref.getString(this.auth_token));
    print("From Session manager --> $auth_token");
    return auth_token;
  }

  clearAll() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    final SharedPreferences prefs = await _prefs;
    await prefs.clear();
  }
}
