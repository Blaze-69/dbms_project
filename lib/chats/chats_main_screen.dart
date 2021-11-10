import 'dart:convert';

import 'package:app/chats/Screens/chatGroupScreen.dart';
import 'package:app/chats/Screens/chatRequestScreen.dart';
import 'package:app/globalHelpers/chatScreenScaffold.dart';
import 'package:app/globalHelpers/global-helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Screens/chatScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  Future _fetchfriends() async {
    String link = 'http://localhost:5000/api/friends';
    final response = await GlobalHelper.checkAccessTokenForGet(link);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _fetchfriends();
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
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchfriends();
  }

  @override
  Widget build(BuildContext context) {
    return ChatScreenScaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: TabBar(
            indicatorColor: Colors.green,
            indicatorWeight: 3.0,
            labelColor: Colors.green,
            onTap: (index) {},
            tabs: [
              Tab(
                child: Chip(
                  label: Text("Friends"),
                  backgroundColor: Colors.white,
                ),
              ),
              Tab(
                child: Chip(
                  label: Text("Artist Groups"),
                  backgroundColor: Colors.white,
                ),
              ),
              Tab(
                child: Chip(
                  label: Text("Request"),
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
          body: TabBarView(
            children: [
              ChatScreen(),
              GroupChatScreen(),
              PendingRequest(),
            ],
          ),
        ),
      ),
    );
  }
}
