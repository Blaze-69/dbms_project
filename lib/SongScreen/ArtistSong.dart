import 'dart:convert';
import 'dart:ui';

import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/globalHelpers/musicScreenScaffold.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:app/models/songModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

class ArtistSongList extends StatefulWidget {
  String artist_id;
  ArtistSongList({this.artist_id});

  @override
  _ArtistSongListState createState() => _ArtistSongListState();
}

class _ArtistSongListState extends State<ArtistSongList> {
  List<Song> parseSongList(String responseBody) {
    final parsed =
    jsonDecode(responseBody)["songsList"].cast<Map<String, dynamic>>();
    return parsed.map<Song>((json) => Song.fromJson(json)).toList();
  }

  Future _fetchSong() async {
    String link = 'http://localhost:5000/api/artists/allSongs/${widget.artist_id}';
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
      var list = parseSongList(response.body);
      return list;
    }
  }

  Future _fetchArtist() async {
    String link = 'http://localhost:5000/api/artists/${widget.artist_id}';
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

      Artist artist = artistFromJson(json.encode(responseJson['artist']));
      return artist;
    }
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return MusicScreenScaffold(
      body:
      FutureBuilder(
          future: Future.wait([_fetchSong(),_fetchArtist()]),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasData){
                List<Song> listSong = snapshot.data[0];
                Artist artist = snapshot.data[1];
                return
                  Stack(
                    children: <Widget>[
                      _buildWidgetAlbumCover(mediaQuery),
                      _buildWidgetArtistName(mediaQuery,artist),
                      _buildWidgetListSong(mediaQuery,listSong),
                    ],
                  );
              }
            }
            return Center(
              child: CircularProgressIndicator(
                color: Colors.deepOrange,
              ),
            );
          })
    );
  }

  Widget _buildWidgetArtistName(MediaQueryData mediaQuery, Artist artist) {
    return SizedBox(
      height: 400,
      child:
      Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: <Widget>[
                Positioned(
                  child: Text(
                    artist.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "CoralPen",
                      fontSize: 72.0,
                    ),
                  ),
                  top: constraints.maxHeight - 140.0,
                ),
                Positioned(
                  child: Text(
                    "Trending",
                    style: TextStyle(
                      color: Color(0xFF7D9AFF),
                      fontSize: 14.0,
                      fontFamily: "Campton_Light",
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  top: constraints.maxHeight - 160.0,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWidgetListSong(MediaQueryData mediaQuery,List<Song> listSong) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.0,
        top: 410,
        right: 20.0,
        bottom: mediaQuery.padding.bottom + 16.0,
      ),
      child: Column(
        children: <Widget>[
          _buildWidgetHeaderSong(),
          SizedBox(height: 16.0),
                  Expanded(
                    child: ScrollConfiguration(
                      behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },),
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
                        separatorBuilder: (BuildContext context, int index) {
                          return Opacity(
                            opacity: 0.5,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 2.0),
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                          );
                        },
                        itemCount: listSong.length,
                        itemBuilder: (BuildContext context, int index) {
                          Song song = listSong[index];
                          return InkWell(
                            onTap: () {
                              context.vxNav.push(
                                Uri(
                                    path:Routes.musicPlayer,
                                    queryParameters: {"id": song.songId.toString()}
                                ),
                              );
                            },
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    song.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Campton_Light",
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Icon(
                                  Icons.more_horiz,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  )
        ],
      ),
    );
  }

  Widget _buildWidgetHeaderSong() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          child: Text(
            "Popular",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 24.0,
              fontFamily: "Campton_Light",
            ),
          ),
        ),
        InkWell(
          child: Text(
            "Show all",
            style: TextStyle(
              color: Color(0xFF7D9AFF),
              fontWeight: FontWeight.w600,
              fontFamily: "Campton_Light",
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWidgetAlbumCover(MediaQueryData mediaQuery) {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(48.0),
        ),
        image: DecorationImage(
          image: AssetImage("assets/G.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}