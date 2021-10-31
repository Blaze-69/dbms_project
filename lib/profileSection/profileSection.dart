import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/profileSection/profileListItem.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String profileImageUri;
  String profileName;

  Future refresh() async {
    String link = 'http://localhost:5000/api/allSongs';
    final response = await GlobalHelper.checkAccessTokenForGet(link);
    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Refresh token expired, Please Login again!") {
        Fluttertoast.showToast(
            msg: "Refresh token expired, Please Login again!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      print(json.decode(response.body)["msg"]);
    }
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
        ),
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
              ),
              SizedBox(height: 5),
              Text(
                "qwerty@gmail.com",
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
                      onPressed: () {},
                    ),
                    ProfileListItems(
                      icon: Icons.notifications,
                      text: 'Notification',
                      onPressed: () {},
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
