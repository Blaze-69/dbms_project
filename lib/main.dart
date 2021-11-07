import 'package:app/SongScreen/ArtistSong.dart';
import 'package:app/SongScreen/MusicPlayer.dart';
import 'package:app/chats/chats_screen.dart';
import 'package:app/chats/message.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:app/homeScreen/Favourite.dart';
import 'package:app/homeScreen/HomeScreen.dart';
import 'package:app/loginScreen/loginPage.dart';
import 'package:app/loginScreen/register.dart';
import 'package:app/loginScreen/splashScreen.dart';
import 'package:app/profileSection/profileItems/changePassword.dart';
import 'package:app/profileSection/profileSection.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:velocity_x/velocity_x.dart';

void main() {
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routeInformationParser: VxInformationParser(),
      routerDelegate: VxNavigator(routes: {
        '/': (_, __) => MaterialPage(child: SplashScreen()),
        Routes.loginPage: (_, __) => MaterialPage(child: LoginPage()),
        Routes.homeScreen: (_, __) => MaterialPage(child: HomeScreen()),
        Routes.register: (_, __) => MaterialPage(child: RegistrationPage()),
        // Routes.artistSongList: (_, __) => MaterialPage(child: ArtistSongList()),
        Routes.profile: (_, __) => MaterialPage(child: Profile()),
        Routes.changePassword: (_, __) => MaterialPage(child: ChangePassword()),
        // Routes.musicPlayer: (_, __) => MaterialPage(child: MusicPlayer()),
        Routes.fav: (_, __) => MaterialPage(child: Fav()),
        Routes.chatScreen: (_, __) => MaterialPage(child: ChatsScreen()),
        Routes.messageScreen: (_, __) => MaterialPage(child: MessageScreen()),
      }),
    );
  }
}
