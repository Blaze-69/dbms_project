import 'package:app/chats/components/chatmodel.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

import '../components/chat_card.dart';

class GroupChatScreen extends StatefulWidget {
  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: chatsData.length,
              itemBuilder: (context, index) => ChatCard(
                    chat: chatsData[index],
                    press: () =>
                        context.vxNav.push(Uri.parse(Routes.messageScreen)),
                  )),
        ),
      ],
    );
  }
}
