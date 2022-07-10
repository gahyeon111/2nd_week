import 'package:battle_reverse/screens/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:battle_reverse/screens/login_screen.dart';
import '../resources/socket_methods.dart';

class MainMenuScreen extends StatefulWidget {
  static String routeName = '/main-menu';
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final SocketMethods _socketMethods = SocketMethods();

  void onlineMatching(BuildContext context) {
    Navigator.pushNamed(context, LoadingScreen.routeName);
  }

  // 닉네임이랑 점수를 서버에서 받아와야하네.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('점수'),
                ElevatedButton(
                    onPressed: () {
                      onlineMatching(context); // LoadingScreen으로 화면전환
                      _socketMethods.createRoom(
                        '닉네임'
                      );
                    },

                    child: const Text('온라인')
                ),
                ElevatedButton(
                    onPressed: () {
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => PlayScreen()));
                    },
                    child: const Text('오프라인')
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => SkinPage()));
                  },
                  child: const Text('스킨선택'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigator.push(context, MaterialPageRoute(builder: (_) => SkinPage()));
                  },
                  child: const Text('종료'),
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
      ),
    );
  }
}
