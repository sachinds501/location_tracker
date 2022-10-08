// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location_tracker/drawer/userprofile.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String? name;

  @override
  void initState() {
    super.initState();
    _getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width / 1.5,
      // backgroundColor: const Color.fromARGB(255, 86, 96, 100),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('location').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          return SafeArea(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                    onDetailsPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserProfile()));
                    },
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 86, 96, 100),
                    ),
                    accountName: Text(name.toString()),
                    accountEmail: Text('$name@gmail.com'.toLowerCase()))
              ],
            ),
          );
        },
      ),
    );
  }

  void _getdata() async {
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
