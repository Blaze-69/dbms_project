import 'dart:convert';

Group groupFromJson(String str) => Group.fromJson(json.decode(str));

String groupToJson(Group data) => json.encode(data.toJson());

class Group {
  Group({
    this.name,
    this.artist,
    this.group_id,
  });

  String name;
  String artist;
  int group_id;

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    name: json["name"] == null ? null : json["name"],
    artist: json["name"] == null ? null : json["artist"],
    group_id: json["user_id"] == null ? null : json["group_id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "artist": artist == null ? null : artist,
    "group_id": group_id == null ? null : group_id,
  };
}
