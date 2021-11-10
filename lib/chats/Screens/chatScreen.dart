import 'dart:convert';

import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  Future _unFriend(friend_id) async {

    String link = 'http://localhost:5000/api/friends';
    final body = {
      "friend_id": friend_id
    };
    final response = await GlobalHelper.checkAccessTokenForDelete(link, body);
    print(response.body);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _unFriend(friend_id);
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
      context.vxNav.push(Uri.parse(Routes.chatScreen));
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
                  function: () async {
                    Loader.show(context,
                        progressIndicator:
                        CircularProgressIndicator(),
                        themeData: Theme.of(context).copyWith(
                            accentColor: Colors.black38),
                        overlayColor: Color(0x99E8EAF6));
                    await _unFriend(friends[index].userId);
                    Loader.hide();
                  },
                ));
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.deepOrange,
            ),
          );
        });
  }
}
