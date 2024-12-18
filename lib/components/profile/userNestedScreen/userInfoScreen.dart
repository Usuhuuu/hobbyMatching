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
    _fetchUserData();
  }

  /// Fetch user data from the cache
  void _fetchUserData() {
    setState(() {
      _userInfo = UserCache().fetchUserInfo();
    });
  }

  /// Clear cached user data and refetch
  Future<void> _clearAndRefreshCache() async {
    try {
      await UserCache().clearUserData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cache cleared. Refreshing data...')),
      );
      _fetchUserData(); // Refetch updated data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error clearing cache: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Info'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _clearAndRefreshCache, // Clear cache and refresh
          ),
        ],
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Builder(
                      builder: (context) {
                        // Filter and sort the data
                        var filteredUserInfo = userInfo.entries
                            .where((entry) =>
                                entry.key != 'password' &&
                                entry.key != 'imageUrl' &&
                                entry.key != 'role')
                            .toList()
                          ..sort((a, b) => a.key.compareTo(b.key));

                        return ListView.separated(
                          itemCount: filteredUserInfo.length,
                          itemBuilder: (context, index) {
                            var key = filteredUserInfo[index].key;
                            var value = filteredUserInfo[index].value;

                            return ListTile(
                              title: Text('$key: ${value.toString()}'),
                            );
                          },
                          separatorBuilder: (context, index) => const Divider(),
                        );
                      },
                    ),
                  ),
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
