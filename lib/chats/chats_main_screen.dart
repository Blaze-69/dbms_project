import 'dart:convert';

import 'package:app/chats/Screens/chatGroupScreen.dart';
import 'package:app/chats/Screens/chatRequestScreen.dart';
import 'package:app/globalHelpers/chatScreenScaffold.dart';
import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

import 'Screens/chatScreen.dart';

class MainScreen extends StatefulWidget {
  String state;
  MainScreen({this.state});
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Create TabController for getting the index of current tab
    if(widget.state == 'friends')
      _controller = TabController(initialIndex:0,length: 3, vsync: this);
    else if(widget.state == 'groups')
      _controller = TabController(initialIndex:1,length: 3, vsync: this);
    else if(widget.state == 'requests')
      _controller = TabController(initialIndex:2,length: 3, vsync: this);
    else
      _controller = TabController(initialIndex:0,length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    return ChatScreenScaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: TabBar(
            controller: _controller,
            indicatorColor: Colors.green,
            indicatorWeight: 3.0,
            labelColor: Colors.green,
            onTap: (index) {
              if(index == 0)
                context.vxNav.push(
                  Uri(
                      path:Routes.chatScreen,
                      fragment: 'friends'
                  ),
                );
              else if(index == 1)
                context.vxNav.push(
                  Uri(
                      path:Routes.chatScreen,
                      fragment: 'groups'
                  ),
                );
              else if(index == 2)
                context.vxNav.push(
                  Uri(
                      path:Routes.chatScreen,
                      fragment: 'requests'
                  ),
                );
            },
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
            controller: _controller,
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
