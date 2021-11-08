
import 'package:app/globalHelpers/drawer.dart';
import 'package:app/globalHelpers/global-helper.dart';
import 'package:app/globalHelpers/routes.dart';
import 'package:app/models/userModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

class MusicScreenScaffold extends StatelessWidget {
  final Widget body;

  const MusicScreenScaffold({this.body});

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        drawer: AppDrawer(),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80.0),
          child:AppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return Padding(
                  padding: const EdgeInsets.only(left:20,top:15.0),
                  child: IconButton(
                    icon: const Icon(Icons.menu,size: 28,),
                    onPressed: () { Scaffold.of(context).openDrawer(); },
                    tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
                  ),
                );
              },
            ),
            iconTheme: IconThemeData(color: Colors.black, size: 30),
            backgroundColor: Colors.white,
            flexibleSpace:
            Padding(
              padding: const EdgeInsets.only(left:75.0,top:15.0),
              child: Container(
                  child:Row(
                    children: [
                      Container(
                        height: 48,
                        width: 100,
                        child: TextButton(
                          style: ButtonStyle(
                              backgroundColor:MaterialStateProperty.all<Color>(Colors.black),
                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                  )
                              )
                          ),
                          onPressed: () { },
                          child: Text('Song App',
                            style: new TextStyle(
                                fontSize: 15.0,
                                fontWeight:FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                      Container(
                          child: Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left:20,right:120.0),
                              child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'Search',
                                    prefixIcon:Padding(
                                      padding: const EdgeInsets.only(left:8.0),
                                      child: Icon(Icons.search_sharp,size:25,color:Colors.black54),
                                    ),
                                    hintStyle: TextStyle(color: Colors.grey),
                                    filled: true,
                                    fillColor: Colors.black12,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                      borderSide: BorderSide(color: Colors.black12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                      borderSide: BorderSide(color: Colors.lightBlueAccent,width:4),
                                    ),
                                  ),
                                  style: TextStyle(
                                      color: Colors.black
                                  )
                              ),
                            ),
                          )
                      )
                    ],
                  )
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right:20,top:15.0),
                child: TextButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                                overlayColor:MaterialStateProperty.all<Color>(Colors.black12),
                                shape: MaterialStateProperty.all<CircleBorder>(
                                    CircleBorder(
                                    )
                                )
                            ),
                            onPressed: () {
                              context.vxNav.replace(Uri.parse(Routes.profile));
                            },
                            child: Icon(Icons.person,size:30,color:Colors.white,),
                          )
              ),
            ],
          ),
        ),
        body: body,
      );
  }

}