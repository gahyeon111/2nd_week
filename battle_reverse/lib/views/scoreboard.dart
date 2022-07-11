import 'package:flutter/material.dart';
import 'package:battle_reverse/provider/room_data_provider.dart';
import 'package:provider/provider.dart';

class Scoreboard extends StatelessWidget {
  const Scoreboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                roomDataProvider.player1.nickname,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                roomDataProvider.countItemWhite.toInt().toString(),
                // roomDataProvider.player1.points.toInt().toString(),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                roomDataProvider.player2.nickname,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                roomDataProvider.countItemBlack.toInt().toString(),
                // roomDataProvider.player2.points.toInt().toString(),
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
