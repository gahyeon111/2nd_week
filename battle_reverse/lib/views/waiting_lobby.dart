import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/room_data_provider.dart';
import '../resources/socket_methods.dart';

class WaitingLobby extends StatefulWidget {
  const WaitingLobby({Key? key}) : super(key: key);

  @override
  State<WaitingLobby> createState() => _WaitingLobbyState();
}

class _WaitingLobbyState extends State<WaitingLobby> {
  final SocketMethods _socketMethods = SocketMethods();
  late TextEditingController roomIdController;


  // bool _onBackPressed(BuildContext context) {
  //   _socketMethods.deleteRoom('닉네임');
  //   Navigator.pop(context);
  //   return true;
  // }
  @override
  void initState() {
    super.initState();
    roomIdController = TextEditingController(
      text:
      Provider.of<RoomDataProvider>(context, listen: false).roomData['_id'],
    );
  }

  @override
  void dispose() {
    super.dispose();
    roomIdController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      // WillPopScope(
      //   onWillPop: () async {
      //     return _onBackPressed(context);
      //     // return true;
      //   },
      //   child:
        Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('상대방을 찾는 중입니다...'),
                const Text('잠시만 기다려주세요...'),
                ElevatedButton(
                  onPressed: () {
                    _socketMethods.deleteRoom(roomIdController.text);
                    Navigator.pop(context);
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
