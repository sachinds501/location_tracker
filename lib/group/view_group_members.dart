// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:location_tracker/home.dart';
import 'package:location_tracker/mymap.dart';
import 'package:location_tracker/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

class ShowGroupMembers extends StatefulWidget {
  final String? group_name;
  final String? group_id;
  const ShowGroupMembers(
      {required String this.group_name,
      required String this.group_id,
      Key? key})
      : super(key: key);

  @override
  State<ShowGroupMembers> createState() => ShowGroupMembersState();
}

class ShowGroupMembersState extends State<ShowGroupMembers> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 66,
        title: SizedBox(
          height: 66,
          child: ListTile(
            contentPadding: const EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
            onTap: () {
              Navigator.of(context).push(SizeTransition5(const Home()));
            },
            title: widget.group_name!.text.xl.semiBold.white.make(),
            subtitle: 'Click to view group info'
                .text
                .size(14)
                .gray300
                .caption(context)
                .make(),
          ),
        ),
        leadingWidth: 65,
        leading: InkWell(
            onTap: () {
              Navigator.of(context).push(SizeTransition5(const Home()));
            },
            child: Row(children: [
              const Icon(Icons.arrow_back),
              const Spacer(),
              CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Image.asset('assets/images/group.png')),
            ])),
        backgroundColor: primaryColor(),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('location').snapshots(),
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
                  title: Text(snapshot.data!.docs[index].get('name').toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    snapshot.data!.docs[index].get('phone').toString(),
                  ),
                  leading: CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.transparent,
                    child: Image.asset('assets/images/person.png'),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: _callNumber,
                          icon: const Icon(
                            Icons.call,
                            color: Colors.green,
                          )),
                      IconButton(
                        icon: const Icon(Icons.directions),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  MyMap(snapshot.data!.docs[index].id)));
                        },
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }

  _callNumber() async {
    String number = FirebaseAuth.instance.currentUser!.phoneNumber
        .toString(); //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(number);
  }
}
