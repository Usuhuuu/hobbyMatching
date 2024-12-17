import 'package:flutter/material.dart';
import 'package:client/components/fetchUserInfo.dart'; // Import the UserCache class

class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late Future<Map<String, dynamic>?> _userInfo;

  @override
  void initState() {
    super.initState();
    _userInfo = UserCache().fetchUserInfo(); // Fetch cached user info
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userInfo, // Use the cached user info from UserCache
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("An error occurred"));
          } else if (snapshot.hasData) {
            var userInfo = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Username: ${userInfo['userName']}",
                      style: const TextStyle(fontSize: 18)),
                  Text("Email: ${userInfo['email']}",
                      style: const TextStyle(fontSize: 18)),
                  Text("First Name: ${userInfo['firstName']}",
                      style: const TextStyle(fontSize: 18)),
                  Text("Last Name: ${userInfo['lastName']}",
                      style: const TextStyle(fontSize: 18)),
                  Text("Phone Number: ${userInfo['phoneNumber']}",
                      style: const TextStyle(fontSize: 18)),
                  Text("Role: ${userInfo['role']}",
                      style: const TextStyle(fontSize: 18)),
                ],
              ),
            );
          } else {
            return const Center(child: Text("No user data found"));
          }
        },
      ),
    );
  }
}
