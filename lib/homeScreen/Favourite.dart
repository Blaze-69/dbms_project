import 'dart:convert';

import 'package:app/HomeScreen/models/PlayList.dart';
import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/models/songModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kPrimaryColor = Color(0xff0968B0);
const kSecondaryColor = Color(0xff7ec8e3);
const kLightColor = Colors.grey;
const kLightColor2 = Color(0xffedf6fa);
const kWhiteColor = Colors.white;
const favoriteColor = Color(0xffd293c6);

class Fav extends StatefulWidget {
  @override
  _FavState createState() => _FavState();
}

class _FavState extends State<Fav> {
  List<Song> parseList(String responseBody) {
    final parsed =
        jsonDecode(responseBody)["songsList"].cast<Map<String, dynamic>>();
    return parsed.map<Song>((json) => Song.fromJson(json)).toList();
  }

  Future _fetchSongs() async {
    String link = 'http://localhost:5000/api/allSongs';
    final response = await GlobalHelper.checkAccessTokenForGet(link);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        _fetchSongs();
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
      return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kWhiteColor,
      appBar: AppBar(
        title: Text(
          'Favourite List',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/profile');
              },
              child: Icon(
                Icons.account_circle,
                color: kPrimaryColor,
                size: 30,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
              height: size.height * 0.72, child: _buildPlaylistAndSongs(size)),
          _buildCurrentPlayingSong(size),
          _buildBottomBar(size)
        ],
      ),
    );
  }

  Widget _buildPlaylistAndSongs(Size size) {
    return Column(
      children: [
        Container(
          height: 0.70 * size.height,
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            future: _fetchSongs(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Song> items = snapshot.data;
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return _buildSonglistItem(items[index]);
                      });
                }
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _buildCurrentPlayingSong(Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/song');
      },
      child: Container(
        height: size.height * 0.100,
        padding: EdgeInsets.symmetric(horizontal: 40.0),
        decoration: BoxDecoration(
            color: kSecondaryColor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50.0),
                topRight: Radius.circular(50.0))),
        child: Row(
          children: [
            CircleAvatar(
                radius: 25, backgroundImage: AssetImage('assets/G.jpg')),
            SizedBox(
              width: 10.0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rewrite the stars',
                  style: TextStyle(
                      color: kPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                Text(
                  'Zac Effron',
                  style: TextStyle(color: kLightColor2, fontSize: 12),
                )
              ],
            ),
            Expanded(
              child: Container(),
            ),
            Icon(
              Icons.favorite_border,
              color: kPrimaryColor,
            ),
            SizedBox(width: 10.0),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadiusDirectional.circular(10.0),
                  color: Colors.white),
              child: Icon(
                Icons.pause,
                color: kPrimaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(Size size) {
    return Container(
      height: size.height * 0.065,
      color: kSecondaryColor,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
            color: kWhiteColor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.home,
              color: kLightColor,
            ),
            Icon(
              Icons.search,
              color: kLightColor,
            ),
            Icon(
              Icons.playlist_play,
              color: kLightColor,
            ),
            Icon(
              Icons.favorite_border,
              color: kLightColor,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPlaylistItem({String artist, String image}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed('/artistSongList',
            arguments: {'artist': artist, 'image': image});
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        width: 250,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.orange,
            image: DecorationImage(image: AssetImage(image), fit: BoxFit.fill)),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  artist,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              Expanded(child: Container(height: 0)),
              Container(
                height: 30,
                width: 30,
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: Icon(
                  Icons.play_circle_outline,
                  color: kPrimaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSonglistItem(Song selectedSong) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed('/musicPlayer', arguments: selectedSong);
      },
      child: ListTile(
        title: Text(selectedSong.title),
        subtitle: Text(selectedSong.artist),
        leading: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/G.jpg"), fit: BoxFit.fill),
              borderRadius: BorderRadius.circular(10.0)),
        ),
      ),
    );
  }
}
