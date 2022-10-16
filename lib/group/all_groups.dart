// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location_tracker/group/view_group_members.dart';
import '../widgets.dart';

class ViewGroups extends StatefulWidget {
  const ViewGroups({Key? key}) : super(key: key);

  @override
  State<ViewGroups> createState() => _ViewGroupsState();
}

class _ViewGroupsState extends State<ViewGroups> {
  String? uid;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('global_users')
            .doc(uid)
            .collection('user_groups')
            .orderBy('group_name')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  title: Text(
                      snapshot.data!.docs[index]['group_name'].toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    snapshot.data!.docs[index]['group_id'].toString(),
                  ),
                  leading: ClipOval(
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[200],
                      child: Image.asset('assets/images/group.png'),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(SizeTransition5(ShowGroupMembers(
                        group_name:
                            snapshot.data!.docs[index]['group_name'].toString(),
                        group_id: snapshot.data!.docs[index]['group_id']
                            .toString())));
                  },
                );
              });
        },
      ),
    );
  }

  checkPhoneNumeber({required List<dynamic> members}) {
    return members;
  }

  CollectionReference currentUser =
      FirebaseFirestore.instance.collection('global_users');

  Future<void> _addData() async {
    return await currentUser
        .doc(uid)
        .collection('user_groups')
        .doc()
        .set({
          'members': FieldValue.arrayUnion(checkPhoneNumeber(members: [])),
        }, SetOptions(merge: true))
        .then((value) => print('New group created'))
        .catchError((error) => print('Error creating new group'));
  }
}
