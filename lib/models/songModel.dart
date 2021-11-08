import 'dart:convert';

Song songFromJson(String str) => Song.fromJson(json.decode(str));

String songToJson(Song data) => json.encode(data.toJson());

class Song {
  Song({
    this.artist,
    this.title,
    this.year,
    this.songId,
    this.album,
  });

  String artist;
  String title;
  DateTime year;
  int songId;
  String album;

  factory Song.fromJson(Map<String, dynamic> json) => Song(
        artist: json["artist"] == null ? null : json["artist"],
        title: json["title"] == null ? null : json["title"],
        year: json["year"] == null ? null : DateTime.parse(json["year"]),
        songId: json["song_id"] == null ? null : json["song_id"],
        album: json["album"] == null ? null : json["album"],
      );

  Map<String, dynamic> toJson() => {
        "artist": artist == null ? null : artist,
        "title": title == null ? null : title,
        "year": year == null ? null : year.toIso8601String(),
        "song_id": songId == null ? null : songId,
        "album": album == null ? null : album,
      };
}


Artist artistFromJson(String str) => Artist.fromJson(json.decode(str));

String artistToJson(Artist data) => json.encode(data.toJson());

class Artist {
  Artist({
    this.name,
    this.artist_id
  });

  String name;
  int artist_id;

  factory Artist.fromJson(Map<String, dynamic> json) => Artist(
    name: json["name"] == null ? null : json["name"],
    artist_id: json["artist_id"] == null ? null : json["artist_id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "artist_id": artist_id == null ? null : artist_id,
  };
}


Album AlbumFromJson(String str) => Album.fromJson(json.decode(str));

String AlbumToJson(Album data) => json.encode(data.toJson());

class Album {
  Album({
    this.name,
    this.artist,
    this.album_id
  });

  String name;
  String artist;
  int album_id;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
    name: json["name"] == null ? null : json["name"],
    artist: json["artist"] == null ? null : json["artist"],
    album_id: json["album_id"] == null ? null : json["album_id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "artist": artist == null ? null : artist,
    "album_id": artist == null ? null : album_id,
  };
}




