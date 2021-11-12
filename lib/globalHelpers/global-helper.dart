import 'dart:async';
import 'dart:convert';
import 'package:app/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GlobalHelper {
  static final shared = GlobalHelper();

  static Future refresh() async {
    String url = 'http://localhost:5000/api/refresh';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final refreshToken = await prefs.getString('refreshToken');
    print("refreshtoken $refreshToken");
    final body = json.encode({"token": refreshToken});
    final response = await http.post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: body);
    final responseJson = json.decode(response.body);
    if (response.statusCode == 200) {
      final accessToken = responseJson['accessToken'];
      await prefs.setString("accessToken", accessToken);
    } else {
      Fluttertoast.showToast(
          msg: "Something went wrong, Please Login again!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  static Future checkAccessTokenForGet(link) async {
    String url = link;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = await prefs.getString("accessToken");
    final response = await http.get(Uri.parse(url), headers: {
      "Authorization": "Bearer $accessToken",
    });
    return response;
  }

  static Future checkAccessTokenForPost(link, body) async {
    String url = link;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = await prefs.getString("accessToken");
    final response = await http.post(Uri.parse(url),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: json.encode(body));
    return response;
  }

  static Future checkAccessTokenForUpdate(link, body) async {
    String url = link;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = await prefs.getString("accessToken");
    final response = await http.put(Uri.parse(url),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: json.encode(body));
    return response;
  }

  static Future checkAccessTokenForDelete(link, body) async {
    String url = link;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final accessToken = await prefs.getString("accessToken");
    final response = await http.delete(Uri.parse(url),
        headers: {
          "Authorization": "Bearer $accessToken",
          "Content-Type": "application/json",
        },
        body: json.encode(body));
    return response;
  }

  static Future<User> fetchCurrentUser() async {
    String link = 'http://localhost:5000/api/user';
    http.Response response = await checkAccessTokenForGet(link);
    print(response.body);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await refresh();
        return fetchCurrentUser();
      } else {
        Fluttertoast.showToast(
            msg: responseJson['msg'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } else {
      print(response.body);
      var responseJson = json.decode(response.body);
      User user = userFromJson(json.encode(responseJson['user']));
      return user;
    }
  }
}
