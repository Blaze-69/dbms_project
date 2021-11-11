import 'dart:convert';
import 'package:app/globalHelpers/musicScreenScaffold.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:app/models/groupModel.dart';
import 'package:app/models/userModel.dart';
import 'package:date_field/date_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

import '../../globalHelpers/global-helper.dart';

class EditGroup extends StatefulWidget {
  String group_id;
  EditGroup ({this.group_id});

  @override
  _EditGroupState createState() => _EditGroupState();
}

class _EditGroupState extends State<EditGroup> {
  User user;
  String groupName;
  String groupArtist;
  List<User> users = [];
  Group group;

  final _formKey = GlobalKey<FormState>();

  Future updateGroup() async {
    String link = 'http://localhost:5000/api/groups';
    final body = {
        "name": groupName,
        "artist" : groupArtist,
        "group_id" : widget.group_id
    };
    http.Response response =
        await GlobalHelper.checkAccessTokenForUpdate(link, body);
    print(response.body);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return updateGroup();
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
      groupName = null;
      groupArtist = null;
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

  Future _sendRequest(friend_id) async {
    String link = 'http://localhost:5000/api/friends/requests';
    final body = {
      "friend_id": friend_id
    };
    final response = await GlobalHelper.checkAccessTokenForPost(link, body);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _sendRequest(friend_id);
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
          webBgColor: "linear-gradient(to right, #32CD32  , #32CD32)",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  List<User> parseList(String responseBody) {
    final parsed =
    jsonDecode(responseBody)["groupMembers"].cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }
  Future _fetchGroup() async {
    String link = 'http://localhost:5000/api/groups/${widget.group_id}';
    final response = await GlobalHelper.checkAccessTokenForGet(link);
    print(response.body);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _fetchGroup();
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
      Group group = groupFromJson(json.encode(responseJson['groupDetails']));
      List<User> list = parseList(response.body);
      return [group,list ];
    }
  }

  String nameValidator(String name) {
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
      body: Column(
        children: [
      Text("Update Group"),
      FutureBuilder(
        future: _fetchGroup(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              group = snapshot.data[0];
              users = snapshot.data[1];
              Loader.hide();
              return
                Expanded(
                  child: Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 30.0),
                                  child: TextFormField(
                                    controller: TextEditingController(
                                        text: group.name),
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (val) => nameValidator(val),
                                    onSaved: (val) => groupName = val,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(bottom: 5),
                                        labelText: "Group Name",
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
                                        text: group.artist),
                                    autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                    validator: (val) => nameValidator(val),
                                    onSaved: (val) => groupArtist = val,
                                    decoration: InputDecoration(
                                        contentPadding:
                                        EdgeInsets.only(bottom: 5),
                                        labelText: "Artist",
                                        floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                        hintStyle: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
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
                                  await updateGroup();
                                  Loader.hide();
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: users.length,
                              itemBuilder: (context, index) {
                                return _result(users[index]);
                              }),
                        ),
                      ],
                    ),
                  ),
                );

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
          return
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30.0),
                              child: TextFormField(
                                initialValue: "Fan Club",
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                validator: (val) => nameValidator(val),
                                onSaved: (val) => groupName = val,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 5),
                                    labelText: "Group Name",
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
                                initialValue: "Arijit",
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                validator: (val) => nameValidator(val),
                                onSaved: (val) => groupArtist = val,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(bottom: 5),
                                    labelText: "Artist",
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
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
                              await updateGroup();
                              Loader.hide();
                            }
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return _result(users[index]);
                          }),
                    ),
                  ],
                ),
              ),
            );
        }),
      ],
      )
    );
  }

  Widget _result(User person) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      "P.jpg",
                    ))),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(person.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Text(person.address,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ),
          ),
          Spacer(),
          Row(
            children: [
              Text("Add Friend"),
              IconButton(
                onPressed: () async {
                  Loader.show(context,
                      progressIndicator:
                      CircularProgressIndicator(),
                      themeData: Theme.of(context).copyWith(
                          accentColor: Colors.black38),
                      overlayColor: Color(0x99E8EAF6));
                  await _sendRequest( person.userId);
                  Loader.hide();
                },
                icon: Icon(Icons.person_add_alt_1_sharp),
                color: Colors.green,
              ),
            ],
          )
        ],
      ),
    );
  }

  bool validate() {
    var valid = _formKey.currentState.validate();
    if (valid) _formKey.currentState.save();
    print(groupName);
    print(groupArtist);
    return valid;
  }
}
