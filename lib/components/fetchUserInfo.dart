import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserCache {
  static final UserCache _instance = UserCache._internal();
  factory UserCache() => _instance;

  UserCache._internal();

  Map<String, dynamic>? _cachedUserData;

  // Getter for cached data
  Map<String, dynamic>? get cachedUserData => _cachedUserData;

  // Method to fetch cached user data
  Future<Map<String, dynamic>?> fetchUserInfo() async {
    try {
      // Return in-memory cache if available
      if (_cachedUserData != null) {
        print('Returning in-memory cache: $_cachedUserData');
        return _cachedUserData;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cachedData = prefs.getString('user_data');

      if (cachedData != null) {
        _cachedUserData = jsonDecode(cachedData);
        print('Loaded data from SharedPreferences: $_cachedUserData');
      } else {
        print('No user data found in SharedPreferences.');
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
      print('User data saved: $userData');
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Method to clear user data
  Future<void> clearUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Remove from SharedPreferences
      bool removed = await prefs.remove('user_data');
      if (removed) {
        print('User data successfully removed from SharedPreferences.');
      } else {
        print('Failed to remove user data from SharedPreferences.');
      }

      // Clear in-memory cache
      _cachedUserData = null;
      print('In-memory cache cleared.');
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }
}
