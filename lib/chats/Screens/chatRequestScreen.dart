import 'dart:convert';

import 'package:app/globalHelpers/global-helper.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PendingRequest extends StatefulWidget {
  @override
  PendingRequestState createState() => PendingRequestState();
}

class PendingRequestState extends State<PendingRequest> {
  Future _fetchRequests() async {
    String link = 'http://localhost:5000/api/friends/getFriendRequests';
    final response = await GlobalHelper.checkAccessTokenForGet(link);

    print(response.body);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _fetchRequests();
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
    } else {}
  }

  // Future _denyRequests() async {
  //   String link = 'http://localhost:5000/api/friends/getFriendRequests';
  //   final response = await GlobalHelper.checkAccessTokenForGet(link);

  //   print(response.body);
  //   if (response.statusCode == 400) {
  //     var responseJson = json.decode(response.body);
  //     if (responseJson['msg'] == "Access token expired") {
  //       await GlobalHelper.refresh();
  //       return _fetchRequests();
  //     } else {
  //       Fluttertoast.showToast(
  //           msg: responseJson['msg'],
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 2,
  //           backgroundColor: Colors.red,
  //           webBgColor: "linear-gradient(to right, #DA0000, #DA0000)",
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     }
  //   } else {}
  // }

  Future _acceptRequests() async {
    String link = 'http://localhost:5000/api/friends/acceptFriendRequest';
    final response = await GlobalHelper.checkAccessTokenForGet(link);

    print(response.body);
    if (response.statusCode == 400) {
      var responseJson = json.decode(response.body);
      if (responseJson['msg'] == "Access token expired") {
        await GlobalHelper.refresh();
        return _fetchRequests();
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
      Fluttertoast.showToast(
          msg: "Request Accepted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          webBgColor: "linear-gradient(to right, #DA0000, #DA0000)",
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _fetchRequests(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  List items = snapshot.data;
                  if (snapshot.hasData) {
                    return ListView.builder(
                        // itemCount: items.length,
                        itemBuilder: (context, index) {
                      return _request(items[index]);
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
      ),
    );
  }

  Widget _request(var person) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      "assets/P.jpg",
                    ))),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("harsh",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                // "${widget.carInfo.biddingData.highestBider.phone.substring(3, 5)}"
                // ${widget.carInfo.biddingData.highestBider.phone.substring(11, 13)}
                Text("+91 " + "84" + "***" + "23",
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
              ],
            ),
          ),
          Spacer(),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.highlight_remove_outlined),
                color: Colors.red,
              ),
              SizedBox(
                width: 2,
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.file_download_done_outlined),
                color: Colors.green,
              ),
            ],
          )
        ],
      ),
    );
  }
}
