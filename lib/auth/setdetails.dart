import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:location_tracker/home.dart';

class SetDetails extends StatefulWidget {
  const SetDetails({super.key});

  @override
  State<SetDetails> createState() => _SetDetailsState();
}

class _SetDetailsState extends State<SetDetails> {
  final loc.Location location = loc.Location();
  final TextEditingController _nameController = TextEditingController();
  String? name;
  String? phone;
  String? uid;

  @override
  void initState() {
    super.initState();
    phone = FirebaseAuth.instance.currentUser!.phoneNumber;
    uid = FirebaseAuth.instance.currentUser!.uid;
    _getdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Profile'),
        backgroundColor: const Color.fromARGB(255, 86, 96, 100),
        actions: [
          IconButton(
              onPressed: () {
                if (name == null) {
                  _addData();
                } else {
                  _updateUser();
                }
                Navigator.of(context)
                    // ignore: prefer_const_constructors
                    .push(MaterialPageRoute(builder: (context) => Home()));
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              // enabled: false,
              style: const TextStyle(color: Colors.black, fontSize: 18),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(8.0),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusColor: Colors.black,
                hintText: 'Enter your name',
              ),
              // keyboardType: TextInputType.number,
              controller: _nameController,
              // initialValue: 'sachin',
            ),
          ],
        ),
      ),
    );
  }

  CollectionReference currentUser =
      FirebaseFirestore.instance.collection('location');

  Future<void> _updateUser() {
    return currentUser
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'name': _nameController.text})
        .then((value) => print('User updated'))
        .catchError((error) => print('User not updated'));
  }

  Future<void> _addData() async {
    final loc.LocationData locationResult = await location.getLocation();
    return await currentUser
        .doc(uid)
        .set(
          {
            'name': _nameController.text,
            'phone': phone,
            'latitude': locationResult.latitude,
            'longitude': locationResult.longitude,
          },
          SetOptions(merge: true),
        )
        .then((value) => print('New user added'))
        .catchError((error) => print('Error adding new user'));
  }

  void _getdata() async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('location')
        .doc(user?.uid)
        .snapshots()
        .listen((userData) {
      setState(() {
        name = userData.data()?['name'];
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _nameController.dispose();
    super.dispose();
  }
}
