import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/profileSection/profileListItem.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String profileImageUri;
  String profileName;

  Future refresh() async {}

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
        backgroundColor: Colors.black,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.only(top: 30),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 30,
                    ),
                    CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        foregroundImage: AssetImage("assets/G.jpg")),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Draco9421",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 5),
              Text(
                "qwerty@gmail.com",
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(height: 20),
              Expanded(
                  child: Column(children: [
                SizedBox(
                  height: 10,
                ),
                Expanded(
                    child: ListView(
                  children: [
                    ProfileListItems(
                      icon: Icons.edit,
                      text: 'Edit Profile',
                      onPressed: () {},
                    ),
                    ProfileListItems(
                      icon: Icons.password,
                      text: 'Change Password',
                      onPressed: () {
                        Navigator.of(context).pushNamed('/changePassword');
                      },
                    ),
                    ProfileListItems(
                      icon: Icons.security,
                      text: 'About Us',
                      onPressed: () {},
                    ),
                    ProfileListItems(
                        icon: Icons.logout, text: 'Logout', onPressed: () {}),
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ))
              ])),
            ],
          ),
        ));
  }
}
