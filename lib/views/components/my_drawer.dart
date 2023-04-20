import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  final User user;

  MyDrawer({required this.user});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 60),
          CircleAvatar(
            radius: 60,
            foregroundImage: (widget.user.isAnonymous)
                ? null
                : (widget.user.photoURL == null)
                    ? null
                    : NetworkImage(widget.user.photoURL as String),
          ),
          (widget.user.isAnonymous)
              ? Text("Anonymous User")
              : Text("Username: ${widget.user.displayName}"),
          (widget.user.isAnonymous)
              ? Container()
              : Text("Email: ${widget.user.email}"),
        ],
      ),
    );
  }
}
