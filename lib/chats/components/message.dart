import 'dart:convert';

import 'package:app/globalHelpers/chatScreenScaffold.dart';
import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:app/globalHelpers/theme.dart';
import 'package:app/models/groupModel.dart';
import 'package:app/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class MessageScreen extends StatefulWidget {
  String to_user_id;
  String type;
  MessageScreen({this.to_user_id, this.type});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  IO.Socket socket;
  String message = "";
  Future<User> user;
  User currentUser;
  void _connect() async {
    socket = IO.io("http://192.168.1.5:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.emit("signIn", {"clientId": "1"});
  }

  void sendMessage() {
    socket.emit("message",
        {"message": message, "from_id": "2", "to_user": widget.to_user_id});
    setState(() {
      message = "";
    });
  }

  Future _fetchGroup() async {
    print("fetchgroup");
    String link = 'http://localhost:5000/api/groups/${widget.to_user_id}';
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
      return group;
    }
  }

  Future _fetchUser() async {
    String link = 'http://localhost:5000/api/user/${widget.to_user_id}';
    final response = await GlobalHelper.checkAccessTokenForGet(link);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _fetchUser();
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
      User user = userFromJson(json.encode(responseJson['user']));
      return user;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = GlobalHelper.fetchCurrentUser();
    _connect();
  }

  @override
  Widget build(BuildContext context) {
    int prevUserId;
    return ChatScreenScaffold(
      body: FutureBuilder(
        future: (widget.type == 'single') ? _fetchUser() : _fetchGroup(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              User user;
              Group group;
              if (widget.type == 'single') {
                User user = snapshot.data;
                return Scaffold(
                  backgroundColor: Color(0xFFF6F6F6),
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    brightness: Brightness.dark,
                    centerTitle: true,
                    title: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: user.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              )),
                          TextSpan(
                              text: '\n' + user.address,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              )),
                          // widget.user.isOnline
                          //     ? TextSpan(
                          //   text: 'Online',
                          //   style: TextStyle(
                          //     fontSize: 11,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // )
                          //     : TextSpan(
                          //   text: 'Offline',
                          //   style: TextStyle(
                          //     fontSize: 11,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    actions: [
                      if (widget.type == 'group')
                        PopupMenuButton<String>(
                          onSelected: (val) {
                            switch (val) {
                              case 'GroupInfo':
                                {
                                  context.vxNav.push(
                                    Uri(
                                        path: Routes.editGroup,
                                        queryParameters: {"id": "1"}),
                                  );
                                }
                                break;
                              default:
                                {
                                  context.vxNav.push(
                                    Uri(
                                        path: Routes.editGroup,
                                        queryParameters: {"id": "1"}),
                                  );
                                }
                            }
                          },
                          itemBuilder: (BuildContext context) {
                            return {'GroupInfo'}.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                    ],
                  ),
                  body: Column(
                    children: <Widget>[
                      // Expanded(
                      //   child: ListView.builder(
                      //     reverse: true,
                      //     padding: EdgeInsets.all(20),
                      //     itemCount: messages.length,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       final Message message = messages[index];
                      //       final bool isMe = message.sender.id == currentUser.id;
                      //       final bool isSameUser = prevUserId == message.sender.id;
                      //       prevUserId = message.sender.id;
                      //       return _chatBubble(message, isMe, isSameUser);
                      //     },
                      //   ),
                      // ),
                      _sendMessageArea(),
                    ],
                  ),
                );
              } else {
                Group group = snapshot.data;
                return Scaffold(
                  backgroundColor: Color(0xFFF6F6F6),
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    brightness: Brightness.dark,
                    centerTitle: true,
                    title: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: group.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              )),
                          TextSpan(
                              text: '\n' + group.artist,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              )),
                          // widget.user.isOnline
                          //     ? TextSpan(
                          //   text: 'Online',
                          //   style: TextStyle(
                          //     fontSize: 11,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // )
                          //     : TextSpan(
                          //   text: 'Offline',
                          //   style: TextStyle(
                          //     fontSize: 11,
                          //     fontWeight: FontWeight.w400,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    actions: [
                      PopupMenuButton<String>(
                        onSelected: (val) {
                          switch (val) {
                            case 'GroupInfo':
                              {
                                context.vxNav.push(
                                  Uri(path: Routes.editGroup, queryParameters: {
                                    "id": group.group_id.toString()
                                  }),
                                );
                              }
                              break;
                            default:
                              {
                                context.vxNav.push(
                                  Uri(path: Routes.editGroup, queryParameters: {
                                    "id": group.group_id.toString()
                                  }),
                                );
                              }
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return {'GroupInfo'}.map((String choice) {
                            return PopupMenuItem<String>(
                              value: choice,
                              child: Text(choice),
                            );
                          }).toList();
                        },
                      ),
                    ],
                  ),
                  body: Column(
                    children: <Widget>[
                      // Expanded(
                      //   child: ListView.builder(
                      //     reverse: true,
                      //     padding: EdgeInsets.all(20),
                      //     itemCount: messages.length,
                      //     itemBuilder: (BuildContext context, int index) {
                      //       final Message message = messages[index];
                      //       final bool isMe = message.sender.id == currentUser.id;
                      //       final bool isSameUser = prevUserId == message.sender.id;
                      //       prevUserId = message.sender.id;
                      //       return _chatBubble(message, isMe, isSameUser);
                      //     },
                      //   ),
                      // ),
                      _sendMessageArea(),
                    ],
                  ),
                );
              }
            }
          }
          return Center(
            child: CircularProgressIndicator(
              color: Colors.deepOrange,
            ),
          );
        },
      ),
    );
  }

  _chatBubble(Message message, bool isMe, bool isSameUser) {
    if (isMe) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      message.time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage('P.jpg}'),
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
          ),
          !isSameUser
              ? Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: AssetImage('P.jpg'),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      message.time,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    }
  }

  _sendMessageArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (val) => message = val,
              decoration: ThemeHelper()
                  .textInputDecoration('Message', 'Enter your Message'),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              sendMessage();
            },
          ),
        ],
      ),
    );
  }
}

class Message {
  final User sender;
  final String
      time; // Would usually be type DateTime or Firebase Timestamp in production apps
  final String text;
  final bool unread;

  Message({
    this.sender,
    this.time,
    this.text,
    this.unread,
  });
}
