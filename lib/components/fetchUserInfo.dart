import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserCache {
  static final UserCache _instance = UserCache._internal();
  factory UserCache() => _instance;
  Future<void> clearUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      _cachedUserData = null;
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }

  UserCache._internal();

  Map<String, dynamic>? _cachedUserData;

  // Getter for cached data
  Map<String, dynamic>? get cachedUserData => _cachedUserData;

  // Method to fetch cached user data
  Future<Map<String, dynamic>?> fetchUserInfo() async {
    try {
      if (_cachedUserData != null) return _cachedUserData;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('user_data');

      if (cachedData != null) {
        _cachedUserData = jsonDecode(cachedData);
      }
      return _cachedUserData;
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }

  // Method to save user data to SharedPreferences
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', jsonEncode(userData));
      _cachedUserData = userData;
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Method to clear user data
}
