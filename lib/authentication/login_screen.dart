import 'package:admin_web_portal/main_screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String adminEmail = '';
  String adminPassword = '';

  allowAdminToLogin() async {
    SnackBar snackBar = const SnackBar(
      content: Text(
        'Checking Credentials, Please wait...',
        style: TextStyle(
          fontSize: 36,
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.cyan,
      duration: Duration(seconds: 6),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    User? currentAdmin;
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: adminEmail, password: adminPassword)
        .then((fAuth) {
      // success
      currentAdmin = fAuth.user;
    }).catchError((onError) {
      // in case of error
      // display error message
      SnackBar snackBar = SnackBar(
        content: Text(
          'Error Occured: ' + onError.toString(),
          style: const TextStyle(
            fontSize: 36,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.cyan,
        duration: const Duration(seconds: 5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });

    if (currentAdmin != null) {
      // check if that admin record exists in the admins collection in firestore database
      await FirebaseFirestore.instance
          .collection('admins')
          .doc(currentAdmin!.uid)
          .get()
          .then(
        (snap) {
          if (snap.exists) {
            Navigator.push(
                context, MaterialPageRoute(builder: (c) => HomeScreen()));
          } else {
            SnackBar snackBar = const SnackBar(
              content: Text(
                'No record found. You are not an admin.',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.cyan,
              duration: Duration(seconds: 5),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // image
                  Image.asset(
                    'images/admin.png',
                  ),

                  // email text field
                  TextField(
                    onChanged: (value) {
                      adminEmail = value;
                    },
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.cyan,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.pinkAccent,
                          width: 2,
                        ),
                      ),
                      hintText: 'Email',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      icon: Icon(
                        Icons.email,
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  // password text field
                  TextField(
                    onChanged: (value) {
                      adminPassword = value;
                    },
                    obscureText: true,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.cyan,
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.pinkAccent,
                          width: 2,
                        ),
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      icon: Icon(
                        Icons.admin_panel_settings,
                        color: Colors.cyan,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  // button
                  ElevatedButton(
                    onPressed: () {
                      allowAdminToLogin();
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 20,
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.cyan),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.pinkAccent),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 2.0,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
