import 'package:client/components/dashboard.dart';
import 'package:client/components/fetchUserInfo.dart';
import 'package:client/models/hobbyModels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoriteHobbiesScreen extends StatefulWidget {
  const FavoriteHobbiesScreen({super.key});

  @override
  State<FavoriteHobbiesScreen> createState() => _FavoriteHobbiesScreenState();
}

class _FavoriteHobbiesScreenState extends State<FavoriteHobbiesScreen> {
  late Future<Map<String, dynamic>?> _userInfo;
  final List<HobbyModel> favoriteHobbiesModel = HobbyModel.getHobbyModel();

  String? selectedHobbyName;
  List<String> selectedSubHobbies = [];

  @override
  void initState() {
    super.initState();
    _userInfo = UserCache().fetchUserInfo();
    fetchFavoriteInfo();
  }

  void saveToDatabase() async {
    try {
      Map<String, dynamic>? userInfo = await _userInfo;

      if (userInfo != null && userInfo['uid'] != null) {
        final String userId = userInfo['uid'];
        // Save the selected hobby and sub-hobbies to Firestore
        DocumentReference userHobbyDoc = FirebaseFirestore.instance
            .collection('user_hobby_favorite')
            .doc(userId);

        DocumentSnapshot userHobbySnapshot = await userHobbyDoc.get();

        if (!userHobbySnapshot.exists) {
          await userHobbyDoc.set({
            'selectedHobbyName': selectedHobbyName,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('New hobby preferences saved successfully!')),
          );
        } else {
          print("Sda shalgaj bn $selectedSubHobbies");
          await userHobbyDoc.update({
            'selectedHobbyName': selectedHobbyName,
            'selectedSubHobbies': selectedSubHobbies,
            'updatedAt': FieldValue.serverTimestamp(), // Update timestamp
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Hobby preferences updated successfully!')),
          );
        }
      } else {
        throw Exception('User ID not found.');
      }
    } catch (err) {
      print("Error saving to database: $err");

      // Show error notification
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Failed to save preferences. Please try again.')),
      );
    }
  }

  Future<Map<String, dynamic>?> fetchFavoriteInfo() async {
    try {
      Map<String, dynamic>? userInfo = await _userInfo;
      if (userInfo != null && userInfo['uid'] != null) {
        String userId = userInfo['uid'];
        DocumentSnapshot<Map<String, dynamic>> userFavoriteData =
            await FirebaseFirestore.instance
                .collection('user_hobby_favorite')
                .doc(userId)
                .get();
        print(userFavoriteData.data());
        setState(() {
          selectedSubHobbies =
              List<String>.from(userFavoriteData['selectedSubHobbies'] ?? []);
        });
        return userFavoriteData.data();
      }
    } catch (err) {
      print(err);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Hobbies'),
      ),
      body: favoriteHobbies(),
    );
  }

  Container favoriteHobbies() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: FutureBuilder<Map<String, dynamic>?>(
        future: _userInfo,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("An error occurred"));
          } else if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: favoriteHobbiesModel.length,
                    itemBuilder: (context, index) {
                      var hobby = favoriteHobbiesModel[index];
                      var hobbyName = hobby.hobbyName;
                      var hobbyIcon = hobby.hobbyIcon;
                      var hobbyDescription = hobby.hobbyDescription;

                      return Column(
                        children: [
                          ListTile(
                            leading: Icon(hobbyIcon),
                            title: Text(hobbyName),
                            subtitle: Text(hobbyDescription),
                            onTap: () async {
                              if (selectedHobbyName != null &&
                                  selectedHobbyName != hobbyName &&
                                  selectedSubHobbies.isNotEmpty) {
                                bool shouldSave = await showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Icon(
                                        Icons.warning_amber_rounded,
                                        color: Colors.red,
                                        size: 40,
                                      ),
                                      content: Text(
                                        'Save changes for "$selectedHobbyName" before switching?',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: const Text('No'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            saveToDatabase();
                                            Navigator.of(context).pop(true);
                                          },
                                          child: const Text('Yes'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (shouldSave) {
                                  setState(() {
                                    selectedHobbyName = hobbyName;
                                  });
                                }
                              } else {
                                setState(() {
                                  selectedHobbyName = hobbyName;
                                });
                              }
                            },
                          ),
                          if (selectedHobbyName == hobbyName &&
                              hobby.subHobbies.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: hobby.subHobbies.length,
                              itemBuilder: (context, subIndex) {
                                var subHobby = hobby.subHobbies[subIndex];
                                var isSelected =
                                    selectedSubHobbies.contains(subHobby);
                                return ListTile(
                                  title: Text(subHobby),
                                  trailing: isSelected
                                      ? const Icon(Icons.check_circle,
                                          color: Colors.blueAccent)
                                      : const Icon(
                                          Icons.radio_button_unchecked),
                                  onTap: () async {
                                    if (isSelected) {
                                      bool shouldUncheck = await showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Icon(
                                              Icons.warning_amber_rounded,
                                              color: Colors.red,
                                              size: 40,
                                            ),
                                            content: Text(
                                              'Do you want to uncheck "$subHobby"?',
                                              style:
                                                  const TextStyle(fontSize: 16),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: const Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(true);
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      if (shouldUncheck) {
                                        setState(() {
                                          selectedSubHobbies.remove(subHobby);
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        selectedSubHobbies.add(subHobby);
                                      });
                                      print(selectedSubHobbies);
                                    }
                                  },
                                );
                              },
                            ),
                          const Divider(),
                        ],
                      );
                    },
                  ),
                ),
                // if (selectedHobbyName != null && selectedSubHobbies.isNotEmpty)
                //   Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: ElevatedButton(
                //       onPressed: confirmSave,
                //       child: const Text('Save Selection'),
                //     ),
                //   ),
              ],
            );
          } else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
