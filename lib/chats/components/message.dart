import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart';
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

class StreamSocket {
  static final _socketResponse = StreamController.broadcast();

  void addResponse(messages) {
    print("printmessage length");
    print(messages.length);
    _socketResponse.add(messages);
  }

  Stream get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

class _MessageScreenState extends State<MessageScreen> {
  IO.Socket socket;
  String message = "";
  Future<User> user;
  User currentUser;
  var group_id;
  StreamSocket streamSocket = StreamSocket();

  TextEditingController _messageController;
  ScrollController _controller;
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  List<Message> messageList = [];

  void _connect() async {
    currentUser = await GlobalHelper.fetchCurrentUser();
    group_id = await _fetchGroupId();
    await _fetchMessages();

    socket = IO.io("http://192.168.1.5:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.onConnect((_) {
      print('connected to websocket');
    });
    socket.emit('openGroup', {"group_id": group_id});
    socket.on('sendMessage', (data) {
      print("data is rinting");
      print(data);
      List<Message> tempMessage = [];
      tempMessage.add(messageFromJson(jsonEncode(data)));
      streamSocket.addResponse(tempMessage);
    });
  }

  // void receiveMessage(data){
  //   setState(() {
  //     Message message = messageFromJson(jsonEncode(data));
  //     messageList.add(message);
  //   });
  // }
  void sendMessage() {
    String messageText = _messageController.text.trim();
    _messageController.text = '';
    if (messageText != '') {
      socket.emit("recieveMessage", {
        "body": messageText,
        "group_id": group_id,
        "user_id": currentUser.userId
      });
    }
  }

  List<Message> parseList(String responseBody) {
    final parsed =
        jsonDecode(responseBody)["messagesList"].cast<Map<String, dynamic>>();
    return parsed.map<Message>((json) => Message.fromJson(json)).toList();
  }

  _fetchMessages() async {
    String link = 'http://localhost:5000/api/messages/${group_id}';
    final response = await GlobalHelper.checkAccessTokenForGet(link);
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
      var list = parseList(response.body);
      streamSocket.addResponse(list);
    }
  }

  Future _fetchGroup() async {
    return this._memoizer.runOnce(() async {
      String link = 'http://localhost:5000/api/groups/${widget.to_user_id}';
      final response = await GlobalHelper.checkAccessTokenForGet(link);
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
    });
  }

  Future _fetchGroupId() async {
    String link =
        'http://localhost:5000/api/groups/getGroupId/${widget.to_user_id}';
    final response = await GlobalHelper.checkAccessTokenForGet(link);
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
      var groupId = responseJson['groupId'];
      return groupId;
    }
  }

  Future _fetchUser() async {
    return this._memoizer.runOnce(() async {
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
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _messageController = TextEditingController();
    _controller = ScrollController();
    _connect();
  }

  @override
  void dispose() {
    _messageController.dispose();
    socket.disconnect();
    super.dispose();
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
                      Expanded(
                          child: StreamBuilder(
                              stream: streamSocket.getResponse,
                              builder: (context, AsyncSnapshot snapshot) {
                                print(snapshot);
                                if (snapshot.connectionState ==
                                    ConnectionState.active) {
                                  if (snapshot.hasData) {
                                    messageList.addAll(snapshot.data);
                                    messageList = messageList.reversed.toList();
                                    return ListView.builder(
                                      controller: _controller,
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      reverse: true,
                                      cacheExtent: 1000,
                                      padding: EdgeInsets.all(20),
                                      itemCount: messageList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final Message message =
                                            messageList[index];
                                        final bool isMe = message.fromUser ==
                                            currentUser.userId;
                                        final bool isSameUser =
                                            prevUserId == message.fromUser;
                                        prevUserId = message.fromUser;
                                        return _chatBubble(
                                            message, isMe, isSameUser);
                                      },
                                    );
                                  }
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.deepOrange,
                                  ),
                                );
                              })),
                      _sendMessageArea(snapshot),
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
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          padding: EdgeInsets.all(20),
                          itemCount: messageList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Message message = messageList[index];
                            final bool isMe =
                                message.fromUser == currentUser.userId;
                            final bool isSameUser =
                                prevUserId == message.fromUser;
                            prevUserId = message.fromUser;
                            return _chatBubble(message, isMe, isSameUser);
                          },
                        ),
                      ),
                      _sendMessageArea(snapshot),
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
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                    message.body,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                )),
            PopupMenuButton<String>(
              onSelected: (val) {
                context.vxNav.push(
                  Uri(path: Routes.deleteAndUpdate, queryParameters: {
                    "type": val,
                    "msgId": message.msgId.toString(),
                    "body": message.body
                  }),
                );
              },
              itemBuilder: (BuildContext context) {
                return {'Delete', 'Edit'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ]),
          !isSameUser
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      message.fromUser.toString(),
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
                        backgroundImage: AssetImage('P.jpg'),
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
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
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
                    message.body,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                )),
            PopupMenuButton<String>(
              onSelected: (val) {
                context.vxNav.push(
                  Uri(path: Routes.deleteAndUpdate, queryParameters: {
                    "type": val,
                    "msgId": message.msgId.toString(),
                    "body": message.body
                  }),
                );
              },
              itemBuilder: (BuildContext context) {
                return {'Delete'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            )
          ]),
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
                      message.fromUser.toString(),
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

  _sendMessageArea(snapshot) {
    snapshot.inState(ConnectionState.done);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: _messageController,
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

Message messageFromJson(String str) => Message.fromJson(json.decode(str));

String messageToJson(Message data) => json.encode(data.toJson());

class Message {
  Message({
    this.body,
    this.msgId,
    this.toUser,
    this.fromUser,
  });

  String body;
  int msgId;
  int toUser;
  int fromUser;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        body: json["body"] == null ? null : json["body"],
        msgId: json["msg_id"] == null ? null : json["msg_id"],
        toUser: json["to_user"] == null ? null : json["to_user"],
        fromUser: json["from_user"] == null ? null : json["from_user"],
      );

  Map<String, dynamic> toJson() => {
        "body": body == null ? null : body,
        "msg_id": msgId == null ? null : msgId,
        "to_user": toUser == null ? null : toUser,
        "from_user": fromUser == null ? null : fromUser,
      };
}
