import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:app/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(
              icon: Icons.music_note,
              text: 'Music Home',
              onTap: () {
                  Navigator.pop(context);
                  context.vxNav.push(Uri.parse(Routes.homeScreen));
              }
          ),
          _createDrawerItem(
              icon: Icons.favorite,
              text: 'Favourite List',
              onTap: () {
                  Navigator.pop(context);
                  context.vxNav.push(Uri.parse(Routes.fav));
              }),
          _createDrawerItem(
              icon: Icons.message,
              text: 'Chat Home',
              onTap: () {
                  Navigator.pop(context);
                  context.vxNav.push(Uri.parse(Routes.chatScreen));
              }),
          _createDrawerItem(
              icon: Icons.logout,
              text: 'Logout',
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove("accessToken");
                await prefs.remove("refreshToken");
                context.vxNav.popToRoot();
                context.vxNav.push(Uri.parse(Routes.loginPage));
              }),
          Divider(),
          _createDrawerItem(icon: Icons.stars, text: 'Useful Links'),
          Divider(),
          _createDrawerItem(icon: Icons.bug_report, text: 'Report an issue'),
          ListTile(
            title: Text('0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('drawer_header_background.png'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Song App",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))),
        ]));;
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }
}
