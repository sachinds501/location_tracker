import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:location_tracker/group/join_group.dart';

import 'group/create_group.dart';

Widget myfloatingButton(BuildContext context) {
  return SpeedDial(
    animatedIcon: AnimatedIcons.add_event,
    animatedIconTheme: const IconThemeData(size: 30.0),
    // this is ignored if animatedIcon is non null
    // child: Icon(Icons.add),
    // visible: _dialVisible,

    curve: Curves.bounceIn,
    overlayColor: Colors.black,
    overlayOpacity: 0.5,
    heroTag: 'speed-dial-hero-tag',
    backgroundColor: Colors.redAccent,
    foregroundColor: Colors.white,
    elevation: 8.0,
    shape: const CircleBorder(),
    children: [
      SpeedDialChild(
          child: const Icon(Icons.add_home),
          backgroundColor: Colors.greenAccent,
          label: 'Create new group',
          // labelStyle: TextTheme(fontSize: 18.0),
          onTap: () => {
                Navigator.of(context).push(SizeTransition5(const CreateGroup()))
              }),
      SpeedDialChild(
          child: const Icon(Icons.join_full),
          backgroundColor: Colors.orangeAccent,
          label: 'Join Group',
          onTap: () {
            Navigator.of(context).push(SizeTransition5(const JoinGroup()));
          }),
    ],
  );
}

class SizeTransition5 extends PageRouteBuilder {
  final Widget page;

  SizeTransition5(this.page)
      : super(
          pageBuilder: (context, animation, anotherAnimation) => page,
          transitionDuration: const Duration(milliseconds: 1000),
          reverseTransitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, anotherAnimation, child) {
            animation = CurvedAnimation(
                curve: Curves.fastLinearToSlowEaseIn,
                parent: animation,
                reverseCurve: Curves.fastOutSlowIn);
            return Align(
              alignment: Alignment.centerRight,
              child: SizeTransition(
                axis: Axis.horizontal,
                sizeFactor: animation,
                axisAlignment: 0,
                child: page,
              ),
            );
          },
        );
}

AppBar myAppBar(title) {
  return AppBar(
    title: Text(title),
    backgroundColor: const Color.fromARGB(255, 86, 96, 100),
  );
}

Color primaryColor() {
  return const Color.fromARGB(255, 86, 96, 100);
}

mySnackBar(BuildContext context, String message) {
  var snackBar = SnackBar(
    content: Text(message),
    backgroundColor: Colors.white,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
