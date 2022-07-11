import 'package:flutter/material.dart';
import 'package:mp_tictactoe/resources/game_methods.dart';
import 'package:mp_tictactoe/screens/main_menu_screen.dart';

import '../screens/create_room_screen.dart';
import 'package:restart_app/restart_app.dart';

void showSnackBar(BuildContext context, String content) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

void showGameDialog(BuildContext context, String text) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(text),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                GameMethods().clearBoard(context);
                // Navigator.pop(context);
                // Navigator.pushNamed(context, CreateRoomScreen.routeName);
                // Navigator.popUntil(context, ModalRoute.withName('/create-room'));
                // Navigator.pushNamedAndRemoveUntil(context, CreateRoomScreen.routeName, (route) => false);
                // Navigator.pop(context);
                Restart.restartApp();
              },
              child: const Text(
                '메인 메뉴로',
              ),
            ),
          ],
        );
      });
}
