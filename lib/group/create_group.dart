import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../widgets.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar('Create Group'),
      body: SafeArea(
          child: Column(
        children: [
          ListTile(
            title: 'Enter group name'.text.xl3.bold.make(),
            subtitle: const TextField(
              style: TextStyle(color: Colors.black, fontSize: 18),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(8.0),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusColor: Colors.black,
                  hintText: 'e.g. Destiny'),
              maxLength: 20,
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
              'Create',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ).wh(120, 40),
        ],
      ).p16()),
    );
  }
}
