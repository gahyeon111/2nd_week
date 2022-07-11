import 'package:flutter/material.dart';
import 'package:mp_tictactoe/provider/room_data_provider.dart';
import 'package:mp_tictactoe/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

import '../resources/socket_methods.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';

class WaitingLobby extends StatefulWidget {
  const WaitingLobby({Key? key}) : super(key: key);

  @override
  State<WaitingLobby> createState() => _WaitingLobbyState();
}

class _WaitingLobbyState extends State<WaitingLobby> {
  late TextEditingController roomIdController;
  final SocketMethods _socketMethods = SocketMethods();

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
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomText(
              shadows: [
                Shadow(
                  blurRadius: 40,
                  color: Colors.blue,
                ),
              ],
              text: '상대방을 찾고있습니다...',
              fontSize: 20,
            ),
            SizedBox(height: size.height * 0.045),
            CustomButton(
              onTap: () {
                _socketMethods.deleteRoom(
                  roomIdController.text,
                );
                Navigator.pop(context);
              },
              text: '취소',
            ),
          ],
        ),
      ),
    );
  }
}
