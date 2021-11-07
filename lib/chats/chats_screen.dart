import 'package:app/globalHelpers/chatScreenScaffold.dart';
import 'package:app/globalHelpers/constants.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class ChatsScreen extends StatefulWidget {
  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  int _selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    return ChatScreenScaffold(
      body: Body(),
    );
  }
}
