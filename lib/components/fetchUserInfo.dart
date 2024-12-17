import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserCache {
  static final UserCache _instance = UserCache._internal();
  factory UserCache() => _instance;

  UserCache._internal();

  Map<String, dynamic>? _cachedUserData;

  // Method to fetch cached user data
  Future<Map<String, dynamic>?> fetchUserInfo() async {
    if (_cachedUserData != null) {
      return _cachedUserData; // Return cached data if already loaded
    }

    // If not in memory, fetch from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('user_data');

    if (cachedData != null) {
      _cachedUserData = jsonDecode(cachedData); // Parse into Map
    }

    return _cachedUserData;
  }

  // Method to save user data to SharedPreferences
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_data', jsonEncode(userData));
    _cachedUserData = userData; // Store in memory as well
  }
}
