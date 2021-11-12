import 'dart:convert';

import 'package:app/chats/components/chat_card.dart';
import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AllUsers extends StatefulWidget {
  @override
  _AllUsersState createState() => _AllUsersState();
}

class _AllUsersState extends State<AllUsers> {
  List<User> parseList(String responseBody) {
    final parsed =
        jsonDecode(responseBody)["usersList"].cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  Future _allUsers() async {
    String link = 'http://localhost:5000/api/friends';
    final response = await GlobalHelper.checkAccessTokenForGet(link);
    print(response.body);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _allUsers();
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
        future: _allUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List<User> friends = snapshot.data;
              return ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) => ChatCard(
                        id: friends[index].userId.toString(),
                        title: friends[index].name,
                        subtitle: friends[index].address,
                      ));
            }
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.deepOrange,
            ),
          );
        });
  }
}
