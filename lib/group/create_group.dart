// ignore_for_file: non_constant_identifier_names

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:random_string/random_string.dart';
import 'package:velocity_x/velocity_x.dart';

import '../home.dart';
import '../widgets.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _grpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? uid;
  String? group_id;
  List<String> members = [];

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    // group_id = FirebaseAuth.instance.currentUser!.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Create Group'),
      body: SafeArea(
          child: Form(
        key: _formKey,
        child: Column(
          children: [
            ListTile(
              title: 'Enter group name'.text.xl3.bold.make(),
              subtitle: TextFormField(
                style: const TextStyle(color: Colors.black, fontSize: 18),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(8.0),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusColor: Colors.black,
                    hintText: 'e.g. Destiny'),
                maxLength: 30,
                controller: _grpController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Group name can't be empty";
                  } else {
                    members
                        .add(FirebaseAuth.instance.currentUser!.phoneNumber!);
                    var r = Random.secure();
                    group_id = randomAlphaNumeric(7,
                        provider: CoreRandomProvider.from(r));
                    _addData();
                    Navigator.of(context).push(SizeTransition5(const Home()));
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 86, 96, 100),
                ),
                elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all(
                  const StadiumBorder(),
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                }
              },
              child: const Text(
                'Create',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ).wh(120, 40),
          ],
        ).p16(),
      )),
    );
  }

  CollectionReference currentUser =
      FirebaseFirestore.instance.collection('location');

  Future<void> _addData() async {
    return await currentUser
        .doc(uid)
        .collection('groups')
        .doc()
        .set({
          'group_name': _grpController.text,
          'group_id': group_id,
          'members': FieldValue.arrayUnion(members),
        }, SetOptions(merge: true))
        .then((value) => print('New group created'))
        .catchError((error) => print('Error creating new group'));
  }

  @override
  void dispose() {
    _grpController.dispose();
    super.dispose();
  }
}
