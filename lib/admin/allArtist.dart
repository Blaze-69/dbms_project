import 'dart:convert';

import 'package:app/chats/components/chat_card.dart';
import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/models/songModel.dart';
import 'package:app/models/userModel.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AllArtist extends StatefulWidget {
  @override
  _AllArtistState createState() => _AllArtistState();
}

class _AllArtistState extends State<AllArtist> {
  List<Artist> parseArtistList(String responseBody) {
    final parsed =
        jsonDecode(responseBody)["artistsList"].cast<Map<String, dynamic>>();
    return parsed.map<Artist>((json) => Artist.fromJson(json)).toList();
  }

  Future _fetchArtists() async {
    String link = 'http://localhost:5000/api/artists/allArtists';
    final response = await GlobalHelper.checkAccessTokenForGet(link);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _fetchArtists();
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
      var list = parseArtistList(response.body);
      return list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        // color: Colors.purple,
        child: FutureBuilder(
          future: _fetchArtists(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<Artist> items = snapshot.data;
                return ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) => _buildArtist(items[index]),
                  ),
                );
              }
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }

  Widget _buildArtist(Artist artist) {
    return ListTile(
      title: Text(artist.name),
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/G.jpg"), fit: BoxFit.fill),
            borderRadius: BorderRadius.circular(10.0)),
      ),
    );
  }
}
