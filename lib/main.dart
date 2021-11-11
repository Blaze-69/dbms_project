import 'dart:async';

import 'package:app/SongScreen/ArtistSong.dart';
import 'package:app/SongScreen/MusicPlayer.dart';
import 'package:app/chats/Screens/chatGroupScreen.dart';
import 'package:app/chats/Screens/editGroup.dart';
import 'package:app/chats/components/createGroup.dart';
import 'package:app/chats/searchGroup.dart';
import 'package:app/chats/searchUser.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:app/homeScreen/Favourite.dart';
import 'package:app/homeScreen/HomeScreen.dart';
import 'package:app/loginScreen/editprofile.dart';
import 'package:app/loginScreen/loginPage.dart';
import 'package:app/loginScreen/register.dart';
import 'package:app/loginScreen/resetPassword.dart';
import 'package:app/profileSection/profileItems/changePassword.dart';
import 'package:app/profileSection/profileSection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:velocity_x/velocity_x.dart';

import 'SongScreen/searchSong.dart';
import 'chats/chats_main_screen.dart';
import 'chats/components/message.dart';

void main() {
  Vx.setPathUrlStrategy();
  runApp(MyApp());
}

class MyObs extends VxObserver {
  @override
  void didChangeRoute(Uri route, Page page, String pushOrPop) {
    print("${route.path} - $pushOrPop");
  }

  @override
  void didPush(Route route, Route previousRoute) {
    print('Pushed a route');
  }

  @override
  void didPop(Route route, Route previousRoute) {
    print('Popped a route');
  }
}


Future<bool> checkLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final accessToken = prefs.get("accessToken");
  print("access token $accessToken");
  if (accessToken != null) {
    return true;
  }
  return false;
}

class MyApp extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  static final navigator = VxNavigator(
      observers: [MyObs()],
      routes: {
        '/': (_,__) {
          return MaterialPage(
              child: FutureBuilder(
                future: checkLoggedIn(),
                builder: (context,snapshot){
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasData){
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.vxNav.replace(Uri.parse(
                          (snapshot.data == false) ?
                          Routes.loginPage
                          :
                          Routes.homeScreen
                        ));
                      });
                    }
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.deepOrange,
                    ),
                  );
                },
              )
          );
        },
        Routes.loginPage: (_, __) => MaterialPage(child: LoginPage()),
        Routes.homeScreen: (_, __) => MaterialPage(child: HomeScreen()),
        Routes.register: (_, __) => MaterialPage(child: RegistrationPage()),
        Routes.artistSongList: (uri, __) {
          final artist_id = uri.queryParameters["id"];
          return MaterialPage(child: ArtistSongList(artist_id: artist_id));
        },
        Routes.searchSong: (uri, __) {
          final title = uri.queryParameters["title"];
          return MaterialPage(child: SearchSong(title: title));
        },
        Routes.searchUser: (uri, __) {
          final name = uri.queryParameters["name"];
          return MaterialPage(child: SearchUser(name: name));
        },
        Routes.searchGroup: (uri, __) {
          final name = uri.queryParameters["name"];
          return MaterialPage(child: SearchGroup(name: name));
        },
        Routes.profile: (_, __) => MaterialPage(child: Profile()),
        Routes.changePassword: (_, __) => MaterialPage(child: ChangePassword()),
        Routes.fav: (_, __) => MaterialPage(child: Fav()),
        Routes.musicPlayer: (uri, _) {
          final song_id = uri.queryParameters["id"];
          return MaterialPage(
            child: MusicPlayer(
              song_id: song_id,
            ),
          );
        },
        Routes.editGroup: (uri, _) {
          final group_id = uri.queryParameters["id"];
          return MaterialPage(
            child: EditGroup(
              group_id: group_id,
            ),
          );
        },
        Routes.chatScreen: (uri, _) {
          final state = uri.fragment;
          return MaterialPage(
            child: MainScreen(
              state: state,
            ),
          );
        },
        Routes.messageScreen: (uri, _) {
          final to_user_id = uri.queryParameters["id"];
          final type = uri.queryParameters["type"];
          return MaterialPage(
            child: MessageScreen(
              to_user_id: to_user_id,
              type: type,
            ),
          );
        },
        Routes.editProfile: (_, __) => MaterialPage(child: EditProfile()),
        Routes.resetPassword: (_, __) => MaterialPage(child: ResetPasswordPage()),
        Routes.createGroup: (_, __) => MaterialPage(child: CreateGroup()),
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: VxInformationParser(),
      routerDelegate: navigator,
    );
  }
}
