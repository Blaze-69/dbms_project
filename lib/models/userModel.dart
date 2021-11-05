import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.name,
    this.email,
    this.address,
    this.dob,
    this.userId,
  });

  String name;
  String email;
  String address;
  DateTime dob;
  int userId;

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        address: json["address"] == null ? null : json["address"],
        dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
        userId: json["user_id"] == null ? null : json["user_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "address": address == null ? null : address,
        "dob": dob == null ? null : dob.toIso8601String(),
        "user_id": userId == null ? null : userId,
      };
}
