import 'package:client/components/fetchUserInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  late Future<Map<String, dynamic>?> _userInfo;
  String? _sendingUserName;

  @override
  void initState() {
    super.initState();
    _userInfo = UserCache().fetchUserInfo();
  }

  void fetchUserFriendData() async {
    if (_sendingUserName == null || _sendingUserName!.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please enter a username before proceeding.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    try {
      Map<String, dynamic>? userInfo = await _userInfo;
      String ownUserName = userInfo!['userName'];

      if (userInfo['uid'] != null) {
        String userId = userInfo['uid'];
        DocumentReference<Map<String, dynamic>> userFriends =
            FirebaseFirestore.instance.collection("user_friends").doc(userId);

        QuerySnapshot<Map<String, dynamic>> userSnapshot =
            await FirebaseFirestore.instance
                .collection("users")
                .where('userName', isEqualTo: _sendingUserName)
                .get();

        print("pisda${userSnapshot.docs[0].data()}");
        print("sdas ${userSnapshot.docs[0].data()['uid']}");

        if (userSnapshot.docs.isNotEmpty) {
          DocumentSnapshot<Map<String, dynamic>> userDoc = userSnapshot.docs[0];
          DocumentSnapshot userFriendsSnapshot = await userFriends.get();
          print("$_sendingUserName and $ownUserName");
          if (!userFriendsSnapshot.exists) {
            await userFriends.set({
              'sentRequests': [_sendingUserName],
            });
          } else {
            await userFriends.update({
              'sentRequests': FieldValue.arrayUnion([_sendingUserName]),
            });
          }

          await FirebaseFirestore.instance
              .collection("user_friends")
              .doc(userDoc.data()?['uid'])
              .set({
            'receivedRequests': FieldValue.arrayUnion([ownUserName]),
          }, SetOptions(merge: true));

          print("Friend request sent to $_sendingUserName");
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('User not found'),
                content:
                    const Text('The user you are trying to add does not exist'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (err) {
      print("Error: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
        actions: [
          IconButton(
            icon: Image.asset(
              'lib/assets/icon/add-friend.png',
              width: 25,
              height: 25,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  TextEditingController textController =
                      TextEditingController();
                  FocusNode textFieldFocusNode = FocusNode();

                  return AlertDialog(
                    title: const Text('Add Friend'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          focusNode: textFieldFocusNode,
                          controller: textController,
                          decoration: const InputDecoration(
                            hintText: 'Enter friend\'s username',
                          ),
                          onChanged: (value) {
                            _sendingUserName = value;
                          },
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          fetchUserFriendData();
                        },
                        child: const Text('Add Friend'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: const Center(
        child: Text('Friends Screen'),
      ),
    );
  }
}
