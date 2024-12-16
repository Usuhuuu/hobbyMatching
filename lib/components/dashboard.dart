import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class DashboardAndSignUp extends StatefulWidget {
  const DashboardAndSignUp({super.key});

  @override
  State<DashboardAndSignUp> createState() => _DashboardAndSignUpState();
}

class AuthServices {
  static Future<bool> signupUser(String email, String password) async {
    try {
      // Create user with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Get the user's UID
      String uid = userCredential.user!.uid;

      String hashedpasswrd = _hashPassword(password);
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'email': email,
        "password": hashedpasswrd,
        'createdAt': FieldValue.serverTimestamp(),
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
    print(digest.toString());
    return digest.toString();
  }
}

class _DashboardAndSignUpState extends State<DashboardAndSignUp> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  String? _password;
  bool loginStatus = false;
  late Stream<User?> _authStateChanges;

  @override
  void initState() {
    super.initState();
    _authStateChanges = FirebaseAuth.instance.authStateChanges();
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
          const SnackBar(content: Text("Authentication successful")),
        );

        setState(() {
          loginStatus = true;
        });
      } catch (e) {
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
        // Wrap the TextFormFields in a Form widget
        key: _formKey, // Use the _formKey for form validation
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
    );
  }

  Widget userInfo() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register & Login'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome! You are logged in.'),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
