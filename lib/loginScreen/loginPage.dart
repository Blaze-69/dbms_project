import 'dart:convert';

import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:app/globalHelpers/theme.dart';
import 'package:app/homeScreen/HomeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';
import 'Register.dart';
import 'header.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String userPassword;
  String userEmailId;
  double _headerHeight = 250;
  final _formKey = GlobalKey<FormState>();
  Future login() async {
    String link = 'http://localhost:5000/api/login';
    final body = {
      "userInfo": {"email": userEmailId, "password": userPassword}
    };
    final response = await GlobalHelper.checkAccessTokenForPost(link, body);

    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        login();
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
      print(responseJson);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("accessToken", responseJson["accessToken"]);
      await prefs.setString("refreshToken", responseJson["refreshToken"]);
      Fluttertoast.showToast(
          msg: responseJson['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #32CD32  , #32CD32)",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      context.vxNav.push(Uri.parse(Routes.homeScreen));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true,
                  Icons.login_rounded), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: EdgeInsets.fromLTRB(
                      20, 10, 20, 10), // This will be the login form
                  child: Column(
                    children: [
                      Text(
                        'Hello',
                        style: TextStyle(
                            fontSize: 60, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Signin into your account',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Container(
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  onSaved: (val) => userEmailId = val,
                                  validator: (val) {
                                    if (!(val.isEmpty) &&
                                        !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                            .hasMatch(val)) {
                                      return "Enter a valid email address";
                                    }
                                    return null;
                                  },
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Email', 'Enter your email'),
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                child: TextFormField(
                                  obscureText: true,
                                  onSaved: (val) => userPassword = val,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return "Please enter your password";
                                    }
                                    return null;
                                  },
                                  decoration: ThemeHelper().textInputDecoration(
                                      'Password', 'Enter your password'),
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 15.0),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 0, 10, 20),
                                alignment: Alignment.topRight,
                                child: GestureDetector(
                                  onTap: () {
                                    // Navigator.push( context, MaterialPageRoute( builder: (context) => ForgotPasswordPage()), );
                                  },
                                  child: Text(
                                    "Forgot your password?",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text(
                                      'Sign In'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (validate()) {
                                      Loader.show(context,
                                          progressIndicator:
                                              CircularProgressIndicator(),
                                          themeData: Theme.of(context).copyWith(
                                              accentColor: Colors.black38),
                                          overlayColor: Color(0x99E8EAF6));
                                      await login();
                                      Loader.hide();
                                    }
                                  },
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                //child: Text('Don\'t have an account? Create'),
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(text: "Don\'t have an account? "),
                                  TextSpan(
                                    text: 'Create',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    RegistrationPage()));
                                      },
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).accentColor),
                                  ),
                                ])),
                              ),
                            ],
                          )),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  bool validate() {
    var valid = _formKey.currentState.validate();
    if (valid) _formKey.currentState.save();
    print(userEmailId);
    print(userPassword);

    return valid;
  }
}
