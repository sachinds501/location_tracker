import 'package:flutter/material.dart';
import 'package:location_tracker/widgets.dart';
import 'package:velocity_x/velocity_x.dart';

class JoinGroup extends StatefulWidget {
  const JoinGroup({Key? key}) : super(key: key);

  @override
  State<JoinGroup> createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Join Group'),
      body: SafeArea(
          child: Column(
        children: [
          ListTile(
            title: 'Enter group code'.text.xl3.bold.make(),
            subtitle: const TextField(
              style: TextStyle(color: Colors.black, fontSize: 18),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8.0),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusColor: Colors.black,
                  hintText: 'e.g. 3eFg01f'),
              maxLength: 7,
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
              // _formKey.currentState!.save();
              // updateUser();
              // _getdata();
            },
            child: const Text(
              'Join',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ).wh(100, 40),
        ],
      ).p16()),
    );
  }
}
