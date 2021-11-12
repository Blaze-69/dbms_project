import 'package:app/admin/allArtist.dart';
import 'package:app/admin/allGroups.dart';
import 'package:app/admin/allSongs.dart';
import 'package:app/admin/allUser.dart';
import 'package:app/globalHelpers/chatScreenScaffold.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

class AdminView extends StatefulWidget {
  String state;
  AdminView({this.state});
  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Create TabController for getting the index of current tab
    if (widget.state == 'allusers')
      _controller = TabController(initialIndex: 0, length: 4, vsync: this);
    else if (widget.state == 'allgroups')
      _controller = TabController(initialIndex: 1, length: 4, vsync: this);
    else if (widget.state == 'allsongs')
      _controller = TabController(initialIndex: 2, length: 4, vsync: this);
    else if (widget.state == 'allartists')
      _controller = TabController(initialIndex: 3, length: 4, vsync: this);
    else
      _controller = TabController(initialIndex: 0, length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return ChatScreenScaffold(
      body: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: TabBar(
            controller: _controller,
            indicatorColor: Colors.green,
            indicatorWeight: 3.0,
            isScrollable: true,
            labelColor: Colors.green,
            onTap: (index) {
              if (index == 0)
                context.vxNav.push(
                  Uri(path: Routes.chatScreen, fragment: 'allusers'),
                );
              else if (index == 1)
                context.vxNav.push(
                  Uri(path: Routes.chatScreen, fragment: 'allgroups'),
                );
              else if (index == 2)
                context.vxNav.push(
                  Uri(path: Routes.chatScreen, fragment: 'allsongs'),
                );
              else if (index == 3)
                context.vxNav.push(
                  Uri(path: Routes.chatScreen, fragment: 'allartists'),
                );
            },
            tabs: [
              Tab(
                child: Chip(
                  label: Text("Users"),
                  backgroundColor: Colors.white,
                ),
              ),
              Tab(
                child: Chip(
                  label: Text("Groups"),
                  backgroundColor: Colors.white,
                ),
              ),
              Tab(
                child: Chip(
                  label: Text("Songs"),
                  backgroundColor: Colors.white,
                ),
              ),
              Tab(
                child: Chip(
                  label: Text("Artist"),
                  backgroundColor: Colors.white,
                ),
              ),
            ],
          ),
          body: TabBarView(
            controller: _controller,
            children: [AllUsers(), AllGroups(), AllSongs(), AllArtist()],
          ),
        ),
      ),
    );
    ;
  }
}
