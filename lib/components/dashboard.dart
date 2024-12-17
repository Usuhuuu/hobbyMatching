import 'package:client/components/profile/notification.dart';
import 'package:client/components/profile/settings.dart';
import 'package:client/models/profileModel.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:client/widgets/bottomnavigator.dart';
import 'package:faker_dart/faker_dart.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DashboardAndSignUp extends StatefulWidget {
  const DashboardAndSignUp({super.key});

  @override
  State<DashboardAndSignUp> createState() => _DashboardAndSignUpState();
}

final faker = Faker.instance;

class AuthServices {
  static Future<bool> signupUser(String email, String password) async {
    try {
      // Create user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get the user's UID
      String uid = userCredential.user!.uid;
      String randomUsername =
          "${faker.animal.type()}${faker.datatype.hexaDecimal()}";
      String fakeFirstName = faker.name.firstName();
      String fakeLastName = faker.name.lastName();
      String hashedpasswrd = _hashPassword(password);
      String fakePhoneNumber = faker.phoneNumber.phoneFormat();
      String avatarUrl = RandomAvatarString('saytoonz');
      print(avatarUrl);
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': email,
        'firstName': fakeFirstName,
        'lastName': fakeLastName,
        "password": hashedpasswrd,
        "imageUrl": avatarUrl,
        'phoneNumber': fakePhoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'userName': randomUsername,
        'role': 'user',
      });
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        try {
          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);
          return true;
        } on FirebaseAuthException catch (err) {
          if (err.code == 'wrong-password') {
            throw Exception("wrong password provided for user");
          }
        } catch (err) {
          throw Exception("error occured on login :$err");
        }
      } else if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else {
        throw Exception('Sign up failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('An unknown error occurred: $e');
    }
    return false;
  }

  static String _hashPassword(String password) {
    // Generate a SHA-256 hash
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}

class _DashboardAndSignUpState extends State<DashboardAndSignUp> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  bool loginStatus = false;
  late Stream<User?> _authStateChanges;
  late List<ProfileModel> profileComponents =
      ProfileModel.getProfileComponents();
  static Map<String, dynamic>? _cachedUserData;

  @override
  void initState() {
    super.initState();
    _authStateChanges = FirebaseAuth.instance.authStateChanges();
    _loadCachedUserData();
  }

  Future<void> _loadCachedUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('user_data');
    if (cachedData != null) {
      _cachedUserData = jsonDecode(cachedData);
      setState(() {});
    }
  }

  Future<Map<String, dynamic>> fetchUserInfo() async {
    if (_cachedUserData != null) {
      return _cachedUserData!; // Return cached data if available
    }

    String? uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      throw Exception("User is not authenticated");
    }

    // Fetch user document from Firestore and exclude 'createdAt' if not needed
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData =
          Map<String, dynamic>.from(userDoc.data() as Map<String, dynamic>);

      userData.remove('createdAt');
      userData.remove('password');
      _cachedUserData = userData;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('user_data', jsonEncode(userData));

      return userData;
    } else {
      throw Exception("User document does not exist");
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Save the form fields
      _formKey.currentState!.save();

      if (_email == null || _password == null) {
        print("Email or Password is null");
        return;
      }

      try {
        await AuthServices.signupUser(_email!, _password!);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication Success")),
        );

        setState(() {
          loginStatus = true;
        });
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } else {
      print("Form validation failed.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("An error occurred"));
          } else if (snapshot.hasData) {
            return userInfo();
          } else {
            return inputDataForms();
          }
        });
  }

  Scaffold inputDataForms() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register & Login'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                key: const ValueKey('email'),
                decoration: const InputDecoration(
                  labelText: 'Enter Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                key: const ValueKey("password"),
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Enter Password",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 7) {
                    return 'Password must be at least 7 characters long';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    debugPrint("Email: $_email");
                    debugPrint("Password: $_password");
                    _submitForm();
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigator(context),
    );
  }

  Widget userInfo() {
    return Scaffold(
      body: userInfoBody(),
      bottomNavigationBar: bottomNavigator(context),
    );
  }

  Container userInfoBody() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.all(20),
      child: FutureBuilder<Map<String, dynamic>>(
        future: fetchUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(child: Text("An error occurred"));
          } else if (snapshot.hasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, top: 50),
                  child: Center(
                    child: SvgPicture.string(
                      '${_cachedUserData?['imageUrl']}',
                      height: 100,
                      width: 100,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: profileComponents.length + 1, // Add 1 for Logout
                    itemBuilder: (context, index) {
                      if (index == profileComponents.length) {
                        return ListTile(
                          leading: const Icon(Icons.logout),
                          title: const Text("Logout"),
                          onTap: () async {
                            try {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.remove('user_data');

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'You have successfully logged out.')),
                              );
                              await FirebaseAuth.instance.signOut();
                              setState(() {
                                _cachedUserData = null;
                              });
                            } catch (err) {
                              print("Error clearing cache during logout: $err");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Error occurred while logging out: $err')),
                              );
                            }
                          },
                        );
                      }

                      final component = profileComponents[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => component.destinationScreen,
                            ),
                          );
                        },
                        child: ListTile(
                          leading: Icon(component.iconText),
                          title: Text(component.components),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("No user data found"));
          }
        },
      ),
    );
  }

  AppBar userInfoAppBar() {
    return AppBar(
      title: const Text(
        'My Profile',
        style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 25,
            fontWeight: FontWeight.bold),
      ),
      leading: IconButton(
        iconSize: 25,
        icon: const Icon(
          Icons.settings,
          color: Colors.blueAccent,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()));
        },
      ),
      actions: [
        IconButton(
          iconSize: 25,
          icon: const Icon(
            Icons.notifications,
            color: Colors.blueAccent,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationScreen()));
          },
        )
      ],
    );
  }
}
