import 'package:app/chats/components/chatmodel.dart';
import 'package:app/globalHelpers/constants.dart';
import 'package:app/globalHelpers/filledOutline.dart';
import 'package:flutter/material.dart';

import 'chat_card.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          color: kPrimaryColor,
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FillOutlineButton(press: () {}, text: "Friends"),
                FillOutlineButton(
                  press: () {},
                  text: "Artist Groups",
                  isFilled: false,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: chatsData.length,
            itemBuilder: (context, index) => ChatCard(
                chat: chatsData[index],
                press: () => Navigator.of(context).pushNamed('/messageScreen')),
          ),
        ),
      ],
    );
  }
}
