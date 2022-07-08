import 'package:flutter/material.dart';
import 'package:untitled/main.dart';
import 'package:untitled/game/play.dart';
import 'package:untitled/kakaologin/main_view_model.dart';

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
                          Navigator.push(context, MaterialPageRoute(builder: (_) => PlayScreen()));
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
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => MyApp()));
                      },
                      child: const Text('Logout'),
                    ),
                  ]
              )
          )
        // )
    );
  }
}