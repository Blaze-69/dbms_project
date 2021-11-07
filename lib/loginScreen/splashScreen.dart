import 'dart:async';
import 'package:app/globalHelpers/routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isVisible = false;
  var isloggedIn = false;
  checkLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.get("accessToken");
    print("access token $accessToken");
    if (accessToken != null) {
      isloggedIn = true;
    }
  }

  _SplashScreenState() {
    new Timer(const Duration(milliseconds: 2000), () {
      _navigatetohome();
    });

    new Timer(Duration(milliseconds: 10), () {
      setState(() {
        _isVisible =
            true; // Now it is showing fade effect and navigating to Login page
      });
    });
  }

  @override
  void initState() {
    checkLoggedIn();
    super.initState();
  }

  _navigatetohome() async {
    await Future.delayed(Duration(milliseconds: 1500), () {});
    // Navigator.of(context).pushNamedAndRemoveUntil(
    //     isloggedIn == false ? '/loginPage' : '/chatScreen',
    //     (Route<dynamic> route) => false);
    context.vxNav.push(
        Uri.parse(isloggedIn == false ? Routes.loginPage : Routes.homeScreen));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
          colors: [Colors.green],
          begin: const FractionalOffset(0, 0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0,
        duration: Duration(milliseconds: 1200),
        child: Center(
          child: Container(
            height: 140.0,
            width: 140.0,
            child: Center(
              child: ClipOval(
                child: Icon(
                  Icons.android_outlined,
                  size: 128,
                ), //put your logo here
              ),
            ),
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2.0,
                    offset: Offset(5.0, 3.0),
                    spreadRadius: 2.0,
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
