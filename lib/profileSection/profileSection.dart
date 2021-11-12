import 'package:app/globalHelpers/drawer.dart';
import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/globalHelpers/musicScreenScaffold.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:app/models/userModel.dart';
import 'package:app/profileSection/profileListItem.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String profileImageUri;
  String profileName;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MusicScreenScaffold(
        body: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: Colors.black),
      child: Column(
        children: [
          FutureBuilder(
            future: GlobalHelper.fetchCurrentUser(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  User user = snapshot.data;
                  return Column(
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                        margin: EdgeInsets.only(top: 30),
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                foregroundImage: AssetImage("assets/G.jpg")),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        user.name,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        Moment.parse(user.dob.toString()).format('dd-MM-yyyy'),
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        user.email,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        user.address,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 20),
                    ],
                  );
                }
              }
              return Container(
                height: 220,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepOrange,
                  ),
                ),
              );
            },
          ),
          Expanded(
              child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: ListView(
              children: [
                ProfileListItems(
                  icon: Icons.edit,
                  text: 'Edit Profile',
                  onPressed: () {
                    context.vxNav.push(Uri.parse(Routes.editProfile));
                  },
                ),
                ProfileListItems(
                  icon: Icons.password,
                  text: 'Change Password',
                  onPressed: () {
                    context.vxNav.push(Uri.parse(Routes.changePassword));
                  },
                ),
                ProfileListItems(
                  icon: Icons.security,
                  text: 'Admin',
                  onPressed: () {
                    context.vxNav.push(
                      Uri(path: Routes.admin, fragment: 'allusers'),
                    );
                  },
                ),
                ProfileListItems(
                    icon: Icons.logout,
                    text: 'Logout',
                    onPressed: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.remove("accessToken");
                      await prefs.remove("refreshToken");
                      context.vxNav.popToRoot();
                      context.vxNav.push(Uri.parse(Routes.loginPage));
                    }),
                SizedBox(
                  height: 40,
                ),
              ],
            ))
          ])),
        ],
      ),
    ));
  }
}
