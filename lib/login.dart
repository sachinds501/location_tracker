// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location_tracker/otp.dart';

import 'home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Something Went Wrong'));
          } else if (snapshot.hasData) {
            return Home();
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: [
                  Container(
                    margin: const EdgeInsets.only(top: 60),
                    child: const Center(
                      child: Text(
                        'Phone Authentication',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 28),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 40, right: 10, left: 10),
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: 'Phone Number',
                        prefix: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text('+91'),
                        ),
                      ),
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      controller: _controller,
                    ),
                  )
                ]),
                Container(
                  margin: EdgeInsets.all(10),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OTPScreen(_controller.text)));
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
