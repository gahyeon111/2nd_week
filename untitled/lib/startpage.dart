import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/main.dart';
import 'package:untitled/play.dart';
import 'package:untitled/colortheme.dart';
import 'package:untitled/main_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:io';

class StartPage extends StatelessWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Start',
      theme: ThemeData(
        primaryColor: Colors.yellow,
      ),
      home: const Start(title: 'Start'),
    );
  }
}

class Start extends StatefulWidget {
  const Start({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Start> createState() => _Start();
  }

class _Start extends State<Start> {

  @override
  Widget build(BuildContext content) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body:
        // WillPopScope(
        //   onWillPop: () {
        //     return Future(() => false);
        //   },
        //   child:
          Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                        onPressed: () {
                          //Navigator.push(context, MaterialPageRoute(builder: (_) => Matching()));
                          showMatching();
                        },
                        child: const Text('Online')
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => PlayScreen()));
                        },
                        child: const Text('Offline')
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => SkinPage()));
                      },
                      child: const Text('Skin'),
                    ),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     Navigator.pop(context);
                    //     Navigator.push(context, MaterialPageRoute(builder: (_) => MyApp()));
                    //   },
                    //   child: const Text('Logout'),
                    // ),
                  ]
              )
          )
        // )
    );
  }

  Future showMatching() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {

        Future.delayed(Duration(seconds: 3), () {
          Navigator.pop(context);
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0)
          ),
          content: SizedBox(
            height: 200,
            child: Column(children: <Widget>[
              Text('매칭중입니다.'),
              Container(
                margin: EdgeInsets.only(top: 70),
                child: Center(
                      child: new CircularProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation(Colors.blue),
                          strokeWidth: 8.0
                      )
                  ),
              )
            ],
            )
          ),
        );
      },
    );
      // showDialog(
      //   context: context,
      //   barrierDismissible: false,
      //   builder: (BuildContext ctx) {
      //     return AlertDialog(
      //       content: SizedBox(
      //         child: Column(
      //           mainAxisAlignment: MainAxisAlignment.center,
      //           children: <Widget>[
      //               ElevatedButton(
      //                   onPressed: () {
      //                     Navigator.of(ctx).pop();
      //                     Navigator.push(context, MaterialPageRoute(builder: (_) => PlayScreen()));
      //                   },
      //                   child: const Text('방 개설'),
      //               ),
      //               ElevatedButton(
      //                   onPressed: () {
      //                   Navigator.of(ctx).pop();
      //                   Navigator.push(context, MaterialPageRoute(builder: (_) => PlayScreen()));
      //                   },
      //                   child: const Text('방 참여'),
      //               ),
      //           ],
      //         ),
      //         height: 100.0,
      //         width: 50.0,
      //       ),
      //     );
      //   });
  }
}