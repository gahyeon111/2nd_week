import 'package:battle_reverse/resources/socket_methods.dart';
import 'package:battle_reverse/screens/main_menu_screen.dart';
import 'package:flutter/material.dart';


class LoadingScreen extends StatefulWidget {
  static String routeName = '/loading';
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.createRoomSuccessListener(context);
    _socketMethods.updatePlayersStateListener(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('상대방을 찾는 중입니다...'),
            const Text('잠시만 기다려주세요...'),
            ElevatedButton(
              onPressed: () {
                _socketMethods.deleteRoom('닉네임');
                Navigator.pop(context);
              },
              child: const Text('취소'),
            )
          ],
        ),
      ),
    );
  }
}
