import 'dart:convert';

import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:app/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

class PendingRequest extends StatefulWidget {
  @override
  PendingRequestState createState() => PendingRequestState();
}

class PendingRequestState extends State<PendingRequest> {

  List<User> parseList(String responseBody) {
    final parsed =
    jsonDecode(responseBody)["requests"].cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromJson(json)).toList();
  }

  Future _fetchRequests() async {
    String link = 'http://localhost:5000/api/friends/requests';
    final response = await GlobalHelper.checkAccessTokenForGet(link);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _fetchRequests();
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

  Future _denyRequests(friend_id) async {
    String link = 'http://localhost:5000/api/friends/requests';
    final body = {
      "friend_id": friend_id
    };
    final response = await GlobalHelper.checkAccessTokenForDelete(link, body);

    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _acceptRequests(friend_id);
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
          context.vxNav.push(
            Uri(
                path:Routes.chatScreen,
                fragment: 'requests'
            ),
          );
    }
  }

  Future _acceptRequests(friend_id) async {
    String link = 'http://localhost:5000/api/friends/requests';
    final body = {
      "friend_id": friend_id
    };
    final response = await GlobalHelper.checkAccessTokenForUpdate(link, body);

    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _acceptRequests(friend_id);
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
          context.vxNav.push(
            Uri(
                path:Routes.chatScreen,
                fragment: 'requests'
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _fetchRequests(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List items = snapshot.data;
                    return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                      return _request(items[index]);
                    });
                  }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _request(User person) {
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
              IconButton(
                onPressed: () async {
                  Loader.show(context,
                      progressIndicator:
                      CircularProgressIndicator(),
                      themeData: Theme.of(context).copyWith(
                          accentColor: Colors.black38),
                      overlayColor: Color(0x99E8EAF6));
                  await _denyRequests(person.userId);
                  Loader.hide();
                },
                icon: Icon(Icons.highlight_remove_outlined),
                color: Colors.red,
              ),
              SizedBox(
                width: 2,
              ),
              IconButton(
                onPressed: () async {
                  Loader.show(context,
                      progressIndicator:
                      CircularProgressIndicator(),
                      themeData: Theme.of(context).copyWith(
                          accentColor: Colors.black38),
                      overlayColor: Color(0x99E8EAF6));
                  await _acceptRequests(person.userId);
                  Loader.hide();
                },
                icon: Icon(Icons.file_download_done_outlined),
                color: Colors.green,
              ),
            ],
          )
        ],
      ),
    );
  }
}
