import 'dart:convert';

import 'package:app/globalHelpers/chatScreenScaffold.dart';
import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/globalHelpers/theme.dart';
import 'package:app/loginScreen/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

class DeleteAndUpdate extends StatefulWidget {
  String type;
  var msgId;
  String body;
  DeleteAndUpdate(this.type, this.msgId, this.body);
  @override
  _DeleteAndUpdateState createState() => _DeleteAndUpdateState();
}

class _DeleteAndUpdateState extends State<DeleteAndUpdate> {
  double _headerHeight = 250;
  String newMessage = "";
  final _formKey = GlobalKey<FormState>();
  Future _deleteMessage() async {
    String link = 'http://localhost:5000/api/messages';
    final body = {"msg_id": widget.msgId};
    final response = await GlobalHelper.checkAccessTokenForDelete(link, body);

    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _deleteMessage();
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
      context.vxNav.pop();
    }
  }

  Future _changeMessage() async {
    String link = 'http://localhost:5000/api/messages';
    final body = {"msg_id": widget.msgId, "body": newMessage};
    print(newMessage);
    if (newMessage.length == 0) {
      Fluttertoast.showToast(
          msg: "Message cannot be empty",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          webBgColor: "linear-gradient(to right, #DA0000, #DA0000)",
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    print("request Sent");
    final response = await GlobalHelper.checkAccessTokenForUpdate(link, body);
    print(response.body);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _changeMessage();
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
      context.vxNav.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChatScreenScaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: _headerHeight,
              child: HeaderWidget(_headerHeight, true,
                  Icons.login_rounded), //let's create a common header widget
            ),
            SafeArea(
              child: widget.type == 'Delete'
                  ? Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      margin: EdgeInsets.fromLTRB(
                          20, 10, 20, 10), // This will be the login form
                      child: Column(
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 30.0),
                              Container(
                                child: Text(
                                  widget.body,
                                  style: TextStyle(fontSize: 18),
                                ),
                                decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                              ),
                              SizedBox(height: 30.0),
                              Container(
                                decoration:
                                    ThemeHelper().buttonBoxDecoration(context),
                                child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: Text(
                                      'Delete'.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () async {
                                    Loader.show(context,
                                        progressIndicator:
                                            CircularProgressIndicator(),
                                        themeData: Theme.of(context).copyWith(
                                            accentColor: Colors.black38),
                                        overlayColor: Color(0x99E8EAF6));
                                    await _deleteMessage();
                                    Loader.hide();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ))
                  : Form(
                      key: _formKey,
                      child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          margin: EdgeInsets.fromLTRB(
                              20, 10, 20, 10), // This will be the login form
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    child: Text(
                                      widget.body,
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    decoration: ThemeHelper()
                                        .inputBoxDecorationShaddow(),
                                  ),
                                  SizedBox(height: 30.0),
                                  Container(
                                    child: TextFormField(
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      onChanged: (val) {
                                        setState(() {
                                          newMessage = val;
                                        });
                                      },
                                      decoration: ThemeHelper()
                                          .textInputDecoration("Edit Text"),
                                    ),
                                    decoration: ThemeHelper()
                                        .inputBoxDecorationShaddow(),
                                  ),
                                  SizedBox(height: 30.0),
                                  Container(
                                    decoration: ThemeHelper()
                                        .buttonBoxDecoration(context),
                                    child: ElevatedButton(
                                      style: ThemeHelper().buttonStyle(),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(40, 10, 40, 10),
                                        child: Text(
                                          'Save'.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      onPressed: () async {
                                        Loader.show(context,
                                            progressIndicator:
                                                CircularProgressIndicator(),
                                            themeData: Theme.of(context)
                                                .copyWith(
                                                    accentColor:
                                                        Colors.black38),
                                            overlayColor: Color(0x99E8EAF6));
                                        await _changeMessage();
                                        Loader.hide();
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
