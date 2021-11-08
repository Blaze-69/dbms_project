import 'dart:convert';
import 'dart:ui';

import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/globalHelpers/musicScreenScaffold.dart';
import 'package:app/models/songModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MusicPlayer extends StatefulWidget {
  String song_id;
  MusicPlayer({this.song_id});

  @override
  _MusicPlayerState createState() => _MusicPlayerState();
}

double currentSlider = 0;

class _MusicPlayerState extends State<MusicPlayer> {

  Future _fetchSong() async {
    String link = 'http://localhost:5000/api/songs/${widget.song_id}';
    final response = await GlobalHelper.checkAccessTokenForGet(link);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _fetchSong();
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
      Song song = songFromJson(json.encode(responseJson['song']));
      return song;
    }
  }
  Future _checkIsFavourite() async {
    String link = 'http://localhost:5000/api/songs/isFav/${widget.song_id}';
    final response = await GlobalHelper.checkAccessTokenForGet(link);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _fetchSong();
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
      return responseJson["isFav"];
    }
  }
  Future addToFav() async {
    String link = 'http://localhost:5000/api/songs/addToFav';
    final body = {
      "song_id": widget.song_id
    };
    final response = await GlobalHelper.checkAccessTokenForPost(link, body);

    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return addToFav();
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
      Fluttertoast.showToast(
          msg: responseJson['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #32CD32  , #32CD32)",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
  Future removeFromFav() async {
    String link = 'http://localhost:5000/api/songs/removeFromFav';
    final body = {
      "song_id": widget.song_id
    };
    final response = await GlobalHelper.checkAccessTokenForDelete(link, body);

    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return addToFav();
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
      Fluttertoast.showToast(
          msg: responseJson['msg'],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          webBgColor: "linear-gradient(to right, #32CD32  , #32CD32)",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MusicScreenScaffold(
      body: Stack(
                children: [
                  Hero(
                    tag: "image",
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/G.jpg"), fit: BoxFit.cover)),
                    ),
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.only(bottom: 50, left: 20, right: 20),
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            blurRadius: 14,
                            spreadRadius: 16,
                            color: Colors.black.withOpacity(0.2),
                          )
                        ]),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                            child: Container(
                              height: 280,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      width: 1.5, color: Colors.white.withOpacity(0.2))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        FutureBuilder(
                                        future: _fetchSong(),
                                        builder: (context,snapshot){
                                          if(snapshot.connectionState == ConnectionState.done){
                                            if(snapshot.hasData){
                                              Song song = snapshot.data;
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                               children: [
                                                Text(
                                                  song.title,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 30,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                 Text(
                                                   song.artist,
                                                   style: TextStyle(color: Colors.white),
                                                 ),
                                               ],
                                              );
                                            }
                                          }
                                          return Center(
                                            child: CircularProgressIndicator(
                                            color: Colors.deepOrange,
                                            ),
                                          );
                                        }
                                          ),
                                        Container(
                                          width: 40,
                                          height: 40,
                                          child: FutureBuilder(
                                              future: _checkIsFavourite(),
                                              builder: (context,snapshot){
                                                if(snapshot.connectionState == ConnectionState.done){
                                                  if(snapshot.hasData){
                                                    bool isFav = snapshot.data;
                                                    if(isFav == true){
                                                      return InkWell(
                                                        onTap: () async {
                                                          snapshot.inState(ConnectionState.waiting);
                                                          await removeFromFav();
                                                          setState(() {
                                                            isFav = false;
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.favorite,
                                                          color: Colors.red,
                                                          size: 40,
                                                        ),
                                                      );
                                                    }
                                                    else{
                                                      return InkWell(
                                                        onTap: () async {
                                                          snapshot.inState(ConnectionState.waiting);
                                                          await addToFav();
                                                          setState(() {
                                                            isFav = false;
                                                          });
                                                        },
                                                        child: Icon(
                                                          Icons.favorite,
                                                          color: Colors.white,
                                                          size: 40,
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
                                              }
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                          thumbShape: RoundSliderThumbShape(
                                              enabledThumbRadius: 2),
                                          trackShape: RectangularSliderTrackShape(),
                                          trackHeight: 6),
                                      child: Slider(
                                        value: currentSlider,
                                        max: 5.00,
                                        min: 0,
                                        inactiveColor: Colors.white70,
                                        activeColor: Colors.red,
                                        onChanged: (val) {
                                          currentSlider = val;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Duration(seconds: currentSlider.toInt())
                                              .toString()
                                              .split('.')[0]
                                              .substring(2),
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          Duration(seconds: 25)
                                              .toString()
                                              .split('.')[0]
                                              .substring(2),
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.skip_previous_outlined,
                                          color: Colors.white, size: 40),
                                      Icon(Icons.pause, color: Colors.white, size: 50),
                                      Icon(Icons.skip_next_outlined,
                                          color: Colors.white, size: 40)
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Icon(Icons.replay_outlined,
                                            color: Colors.white, size: 40),
                                        Icon(Icons.shuffle, color: Colors.white, size: 40)
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              )
    );
  }
}
