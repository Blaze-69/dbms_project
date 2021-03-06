import 'package:app/globalHelpers/constants.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:app/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

class ChatCard extends StatelessWidget {
  ChatCard({this.title, this.subtitle, this.type, this.id, this.function});

  String title;
  String subtitle;
  String type;
  String id;
  VoidCallback function;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.vxNav.push(
          Uri(path: Routes.messageScreen, queryParameters: {
            "type": type,
            "id": id,
          }),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding * 0.75),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('P.jpg'),
                ),
                // if (chat.isActive)
                //   Positioned(
                //     right: 0,
                //     bottom: 0,
                //     child: Container(
                //       height: 16,
                //       width: 16,
                //       decoration: BoxDecoration(
                //         color: kPrimaryColor,
                //         shape: BoxShape.circle,
                //         border: Border.all(
                //             color: Theme.of(context).scaffoldBackgroundColor,
                //             width: 3),
                //       ),
                //     ),
                //   )
              ],
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Opacity(
                      opacity: 0.64,
                      child: Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (type == 'single')
              Row(
                children: [
                  Text("Unfriend"),
                  IconButton(
                    onPressed: function,
                    icon: Icon(Icons.highlight_remove_outlined),
                    color: Colors.red,
                  )
                ],
              )
            else if (type == 'group')
              Row(
                children: [
                  Text("Leave"),
                  IconButton(
                    onPressed: function,
                    icon: Icon(
                      Icons.exit_to_app,
                      color: Colors.red,
                    ),
                    color: Colors.red,
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
