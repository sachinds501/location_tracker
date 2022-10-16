// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:location_tracker/group/all_groups.dart';
import 'drawer/drawer.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  String? uid;
  String? phone;
  String? name;

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    phone = FirebaseAuth.instance.currentUser!.phoneNumber;

    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
    _getdata();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text('Live Location Tracker'),
          backgroundColor: const Color.fromARGB(255, 86, 96, 100),
          bottom: const TabBar(
            tabs: [Tab(text: "GROUPS"), Tab(text: "LOCATION STATUS")],
          ),
        ),
        body: TabBarView(
          children: [
            const ViewGroups(),
            Column(
              children: [
                TextButton(
                    onPressed: () {
                      _listenLocation();
                    },
                    child: Text('Enable live location',
                        style: TextStyle(
                            color: Colors.green[600],
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                TextButton(
                    onPressed: () {
                      _stopListening();
                    },
                    child: Text('Stop live location',
                        style: TextStyle(
                            color: Colors.red[600],
                            fontSize: 18,
                            fontWeight: FontWeight.bold))),
                const Divider(
                  thickness: 2,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('global_users').doc(uid).set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
      }, SetOptions(merge: true));
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  void _getdata() async {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('global_users')
        .doc(user?.uid)
        .snapshots()
        .listen((userData) {
      if (mounted) {
        setState(() {
          name = userData.data()?['name'];
        });
      }
    });
  }
}
