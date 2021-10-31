import 'package:app/SongScreen/ArtistSong.dart';
import 'package:app/homeScreen/HomeScreen.dart';
import 'package:app/loginScreen/loginPage.dart';
import 'package:app/loginScreen/register.dart';
import 'package:app/loginScreen/splashScreen.dart';
import 'package:app/profileSection/profileSection.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => SplashScreen(),
        );
      case '/loginPage':
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
        );
      case '/register':
        return MaterialPageRoute(
          builder: (_) => RegistrationPage(),
        );
      case '/homeScreen':
        return MaterialPageRoute(
          builder: (_) => HomeScreen(),
        );
      case '/artistSongList':
        return MaterialPageRoute(
          builder: (_) => ArtistSongList(args),
        );
      case '/profile':
        return MaterialPageRoute(
          builder: (_) => Profile(),
        );
      default:
        return _errorRoute();
    }
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ERROR"),
      ),
      body: Center(
        child: Text("ERROR"),
      ),
    );
  });
}
