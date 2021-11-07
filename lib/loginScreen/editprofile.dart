import 'dart:convert';
import 'package:app/globalHelpers/musicScreenScaffold.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:app/models/userModel.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

import '../../globalHelpers/global-helper.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  User user;
  String userName;
  String userAddress;
  String userDob;

  final _formKey = GlobalKey<FormState>();

  Future updateProfile() async {
    String link = 'http://localhost:5000/api/user/updateAccount';
    final body = {
      "userInfo":{
        "name": userName,
        "address" : userAddress,
        "dob":userDob
      }
    };
    print(body);
    http.Response response =
        await GlobalHelper.checkAccessTokenForUpdate(link, body);
    print(response.body);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return updateProfile();
      } else {
        Fluttertoast.showToast(
            msg: responseJson['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      var responseJson = json.decode(response.body);
      userName = null;
      userAddress = null;
      userDob = null;
      Fluttertoast.showToast(
          msg: responseJson['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }


  String nameValidator(String name) {
    if (name.isEmpty) {
      return "Field Cannot Be Empty";
    } else {
      return null;
    }
  }

  String aadharvalidator(String name) {
    if (name.isEmpty) {
      return "Field Cannot Be Empty";
    } else {
      return null;
    }
  }

  @override
  void dispose() {
    Loader.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MusicScreenScaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Text("Update Account"),
          FutureBuilder<User>(
              future: GlobalHelper.fetchCurrentUser(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    user = snapshot.data;
                    Loader.hide();
                    return Column(children: [
                      SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              child: TextFormField(
                                controller: TextEditingController(
                                    text: user.name),
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: (val) => nameValidator(val),
                                onSaved: (val) => userName = val,
                                decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.only(bottom: 5),
                                    labelText: "Full Name",
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              child: TextFormField(
                                controller: TextEditingController(
                                    text: user.address),
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                validator: (val) => nameValidator(val),
                                onSaved: (val) => userAddress = val,
                                decoration: InputDecoration(
                                    contentPadding:
                                    EdgeInsets.only(bottom: 5),
                                    labelText: "Address",
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    )),
                              ),
                            ),
                            DateTimeFormField(
                              initialValue: DateTime(user.dob.year,user.dob.month,user.dob.day),
                              onSaved: (val) => userDob = Moment.parse(val.toString())
                                  .format('yyyy-MM-dd'),
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.black45),
                                errorStyle: TextStyle(color: Colors.redAccent),
                                border: InputBorder.none,
                                suffixIcon: Icon(Icons.event_note),
                                labelText: 'Date Of Birth',
                              ),
                              mode: DateTimeFieldPickerMode.date,
                              autovalidateMode: AutovalidateMode.always,
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }
                } else {
                  Loader.show(context,
                      isSafeAreaOverlay: false,
                      isAppbarOverlay: true,
                      isBottomBarOverlay: true,
                      progressIndicator: CircularProgressIndicator(),
                      themeData: Theme.of(context)
                          .copyWith(accentColor: Colors.black38),
                      overlayColor: Color(0x99E8EAF6));
                }
                return Column(children: [
                  SizedBox(height: 20),
                  Form(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: TextFormField(
                            initialValue: "David",
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (val) => nameValidator(val),
                            onSaved: (val) => userName = val,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 5),
                                labelText: "Full Name",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                )),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30.0),
                          child: TextFormField(
                            initialValue: "Address",
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            validator: (val) => nameValidator(val),
                            onSaved: (val) => userAddress = val,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(bottom: 5),
                                labelText: "Address",
                                floatingLabelBehavior:
                                FloatingLabelBehavior.always,
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                )),
                          ),
                        ),
                        DateTimeFormField(
                          initialValue: (user == null && userDob == null) ? DateTime.now() : DateTime(user.dob.year,user.dob.month,user.dob.day),
                          autovalidateMode:
                          AutovalidateMode.onUserInteraction,
                          onSaved: (val) => userDob = Moment.parse(val.toString())
                              .format('yyyy-MM-dd'),
                          decoration: const InputDecoration(
                            hintStyle: TextStyle(color: Colors.black45),
                            errorStyle: TextStyle(color: Colors.redAccent),
                            border: InputBorder.none,
                            suffixIcon: Icon(Icons.event_note),
                            labelText: 'Date Of Birth',
                          ),
                          mode: DateTimeFieldPickerMode.date,
                        ),
                      ],
                    ),
                  ),
                ]);
              }),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  child: Text("Save Changes"),
                  onPressed: () async {
                    if (validate()) {
                      Loader.show(context,
                          isSafeAreaOverlay: false,
                          isAppbarOverlay: true,
                          isBottomBarOverlay: true,
                          progressIndicator: CircularProgressIndicator(),
                          themeData: Theme.of(context)
                              .copyWith(accentColor: Colors.black38),
                          overlayColor: Color(0x99E8EAF6));
                      await updateProfile();
                      Loader.hide();
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  child: Text("Delete Account"),
                  onPressed: () async {
                  },
                ),
              ),
            ],
          ),
        ]),
      )),
    );
  }

  bool validate() {
    var valid = _formKey.currentState.validate();
    if (valid) _formKey.currentState.save();
    print(userName);
    print(userAddress);
    print(userDob);

    return valid;
  }
}
