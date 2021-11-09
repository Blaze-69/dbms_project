import 'dart:convert';

import 'package:app/chats/components/chatmodel.dart';
import 'package:app/globalHelpers/constants.dart';
import 'package:app/globalHelpers/filledOutline.dart';
import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:app/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

import '../components/chat_card.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  List<User> parseList(String responseBody) {
    final parsed =
    jsonDecode(responseBody)["usersList"].cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  Future _fetchFriends() async {
    String link = 'http://localhost:5000/api/friends';
    final response = await GlobalHelper.checkAccessTokenForGet(link);
    print(response.body);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _fetchFriends();
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
      future: _fetchFriends(),
      builder: (context,snapshot){
        if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasData){
            List<User> friends = snapshot.data;
            return ListView.builder(
                itemCount: friends.length,
                itemBuilder: (context, index) => ChatCard(
                  title: friends[index].name,
                  subtitle: friends[index].address,
                  type: 'user',
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
