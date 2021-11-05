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
