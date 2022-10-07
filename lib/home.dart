// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:location_tracker/mymap.dart';
import 'package:permission_handler/permission_handler.dart';

import 'login.dart';

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

  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    phone = FirebaseAuth.instance.currentUser!.phoneNumber;
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Live Location Tracker'), actions: [
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false);
              }),
        ]),
        body: Column(
          children: [
            TextButton(
                onPressed: () {
                  _getLocation();
                },
                child: const Text('add my location')),
            TextButton(
                onPressed: () {
                  _listenLocation();
                },
                child: const Text('enable live location')),
            TextButton(
                onPressed: () {
                  _stopListening();
                },
                child: const Text('stop live location')),
            Expanded(
                child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('location').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          tileColor: Colors.grey[200],
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          title: Text(
                              "${snapshot.data!.docs[index]['name']} - ${FirebaseAuth.instance.currentUser!.phoneNumber}",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          subtitle: Row(
                            children: [
                              Text(snapshot.data!.docs[index]['latitude']
                                  .toString()),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(snapshot.data!.docs[index]['longitude']
                                  .toString()),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.directions),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      MyMap(snapshot.data!.docs[index].id)));
                            },
                          ),
                        ),
                      );
                    });
              },
            )),
          ],
        ),
      ),
    );
  }

  _getLocation() async {
    try {
      final loc.LocationData locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc(uid).set({
        'latitude': locationResult.latitude,
        'longitude': locationResult.longitude,
        'name': 'krishna',
        'phone': phone,
      }, SetOptions(merge: true));
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('location').doc(uid).set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'name': 'krishna',
        'phone': phone,
      }, SetOptions(merge: true));
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      // print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
