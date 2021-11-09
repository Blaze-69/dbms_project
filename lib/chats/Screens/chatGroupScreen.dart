import 'dart:convert';

import 'package:app/chats/components/chatmodel.dart';
import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:app/models/groupModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

import '../components/chat_card.dart';

class GroupChatScreen extends StatefulWidget {
  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {

  List<Group> parseList(String responseBody) {
    final parsed =
    jsonDecode(responseBody)["groupsList"].cast<Map<String, dynamic>>();
    return parsed.map<Group>((json) => Group.fromJson(json)).toList();
  }

  Future _fetchGroups() async {
    String link = 'http://localhost:5000/api/groups';
    final response = await GlobalHelper.checkAccessTokenForGet(link);

    print(response.body);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _fetchGroups();
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
      var list = parseList(response.body);
      return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fetchGroups(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.done){
            if(snapshot.hasData){
              List<Group> groups = snapshot.data;
              return ListView.builder(
                  itemCount: groups.length,
                  itemBuilder: (context, index) => ChatCard(
                    title: groups[index].name,
                    subtitle: groups[index].artist,
                    type: 'group',
                  ));
            }
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.deepOrange,
            ),
          );
        }
    );
  }
}
