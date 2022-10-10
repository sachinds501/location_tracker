import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:location_tracker/group/open_group.dart';
import 'package:velocity_x/velocity_x.dart';

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
            .collection('location')
            .doc(uid)
            .collection('groups')
            .orderBy('group_name')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5,
                  child: ListTile(
                    tileColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8))),
                    title: Text(
                        snapshot.data!.docs[index]['group_name'].toString(),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle:
                        Text("id: ${snapshot.data!.docs[index]['group_id']}"),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.transparent,
                      child: Image.asset('assets/images/group.png'),
                    ),
                    onTap: () {
                      Navigator.of(context).push(SizeTransition5(
                          ShowGroupMembers(
                              group_name: snapshot
                                  .data!.docs[index]['group_name']
                                  .toString(),
                              group_id: snapshot.data!.docs[index]['group_id']
                                  .toString())));
                    },
                  ),
                );
              }).pSymmetric(v: 16);
        },
      ),
    );
  }
}
