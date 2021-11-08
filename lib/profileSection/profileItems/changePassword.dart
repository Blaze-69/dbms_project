import 'dart:convert';

import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/globalHelpers/musicScreenScaffold.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String oldPassword;
  String newPassword;
  String reEnterNewPassword;

  void _changePassword() async {
    String link = 'http://localhost:5000/api/changepassword';
    var body = {
      'userInfo': {"password": oldPassword, "newPassword": newPassword}
    };
    if (newPassword != reEnterNewPassword) {
      Fluttertoast.showToast(
          msg: "Password Does not match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          webBgColor: "linear-gradient(to right, #DA0000, #DA0000)",
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    if (newPassword == null || newPassword.length == 0) {
      Fluttertoast.showToast(
          msg: "New Password can not be empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          webBgColor: "linear-gradient(to right, #DA0000, #DA0000)",
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }

    final response = await GlobalHelper.checkAccessTokenForUpdate(link, body);

    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        _changePassword();
      } else {
        Fluttertoast.showToast(
            msg: responseJson['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            webBgColor: "linear-gradient(to right, #DA0000, #DA0000)",
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      var responseJson = json.decode(response.body);
      Fluttertoast.showToast(
          msg: responseJson['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          webBgColor: "linear-gradient(to right, #32CD32  , #32CD32)",
          textColor: Colors.white,
          fontSize: 16.0);
      context.vxNav.push(Uri.parse(Routes.profile));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MusicScreenScaffold(
        body: Container(
            padding: EdgeInsets.only(left: 16, top: 25, right: 16),
            child: ListView(
              children: [
                Text(
                  "Password",
                  style:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 35,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35.0),
                  child: TextField(
                    onChanged: (value) {
                      oldPassword = value;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: "Current Password",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35.0),
                  child: TextField(
                    onChanged: (value) {
                      newPassword = value;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: "New Password",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 35.0),
                  child: TextField(
                    onChanged: (value) {
                      reEnterNewPassword = value;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(bottom: 3),
                        labelText: "Re-enter New Password",
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 35,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                    onPressed: () async {
                      Loader.show(context,
                          isSafeAreaOverlay: false,
                          isAppbarOverlay: true,
                          isBottomBarOverlay: true,
                          progressIndicator: CircularProgressIndicator(),
                          themeData: Theme.of(context)
                              .copyWith(accentColor: Colors.black38),
                          overlayColor: Color(0x99E8EAF6));
                      await _changePassword();
                      Loader.hide();
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                      padding:
                          MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 5)),
                      elevation: MaterialStateProperty.all<double>(2),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                    ),
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  ),
                ])
              ],
            )));
  }
}
