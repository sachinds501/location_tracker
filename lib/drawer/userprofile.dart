// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController _nameController = TextEditingController();
  String? name;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Profile'),
          backgroundColor: const Color.fromARGB(255, 86, 96, 100),
        ),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('location').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return Form(
                key: _formKey,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.all(10),
                          leading: SizedBox(
                              height: 50,
                              width: 50,
                              child: Icon(
                                Icons.person,
                                color: Colors.black,
                                size: 28,
                              )),
                          trailing: Icon(Icons.edit, color: Colors.green),
                          title: Text(
                            'Name',
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 14),
                          ),
                          subtitle: Text(
                            name.toString(),
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                          onTap: () {
                            showModalBottomSheet(
                              constraints: BoxConstraints(maxHeight: 200),
                              context: context,
                              builder: (context) => Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextFormField(
                                      // enabled: false,
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18),
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.all(8.0),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        focusColor: Colors.black,
                                        hintText: 'Enter your name',
                                      ),
                                      // keyboardType: TextInputType.number,
                                      controller: _nameController,
                                      // initialValue: 'sachin',
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      child: SizedBox(
                                        width: 100,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Color.fromARGB(255, 86, 96, 100),
                                            ),
                                            shape: MaterialStateProperty.all(
                                              StadiumBorder(),
                                            ),
                                          ),
                                          onPressed: () {
                                            _formKey.currentState!.save();
                                            updateUser();
                                            // _getdata();
                                          },
                                          child: Text(
                                            'Save',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  CollectionReference currentUser =
      FirebaseFirestore.instance.collection('location');

  Future<void> updateUser() {
    return currentUser
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'name': _nameController.text})
        .then((value) => print('user updated'))
        .catchError((error) => print('User not updated $error'));
  }

  // Future<void> _addData() {
  //   return currentUser.add({'name': name});
  // }

  void _getdata() async {
    if (mounted) {
      User? user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance
          .collection('location')
          .doc(user?.uid)
          .snapshots()
          .listen((userData) {
        setState(() {
          name = userData.data()!['name'];
        });
      });
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _nameController.dispose();
    super.dispose();
  }
}
