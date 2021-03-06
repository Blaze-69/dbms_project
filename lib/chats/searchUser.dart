import 'dart:convert';

import 'package:app/HomeScreen/models/ArtistList.dart';
import 'package:app/globalHelpers/chatScreenScaffold.dart';
import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/globalHelpers/musicScreenScaffold.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:app/models/songModel.dart';
import 'package:app/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

const kPrimaryColor = Color(0xff0968B0);
const kSecondaryColor = Color(0xff7ec8e3);
const kLightColor = Colors.grey;
const kLightColor2 = Color(0xffedf6fa);
const kWhiteColor = Colors.white;
const favoriteColor = Color(0xffd293c6);

class SearchUser extends StatefulWidget {

  String name;
  SearchUser({this.name});
  @override
  _SearchUserState createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
  List<User> parseList(String responseBody) {
    final parsed =
    jsonDecode(responseBody)["usersList"].cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  Future _fetchUsers() async {
    String link = 'http://localhost:5000/api/search/user?name=${widget.name}';
    final response = await GlobalHelper.checkAccessTokenForGet(link);

    print(response.body);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _fetchUsers();
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
          context.vxNav.replace(
            Uri(
                path:Routes.searchUser,
                queryParameters: {"name": widget.name}
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChatScreenScaffold(
      body: FutureBuilder(
        future: _fetchUsers(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              List users = snapshot.data;
              return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return _result(users[index]);
                  });
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
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
}
