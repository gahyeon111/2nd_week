import 'package:battle_reverse/provider/room_data_provider.dart';
import 'package:battle_reverse/resources/socket_methods.dart';
import 'package:battle_reverse/screens/loading_screen.dart';
import 'package:battle_reverse/views/scoreboard.dart';
import 'package:battle_reverse/views/tictactoe_board.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatefulWidget {
  static String routeName = '/game';
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.updateRoomListener(context);
    _socketMethods.updatePlayersStateListener(context);
    // _socketMethods.pointIncreaseListener(context);
    _socketMethods.endGameListener(context);
  }


  @override
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);
    return Scaffold(
      body: roomDataProvider.roomData['isJoin'] ? const LoadingScreen() : Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Scoreboard(),
              const TicTacToeBoard(),
              Text(
                  '${roomDataProvider.roomData['turn']['nickname']}\'s turn'),
            ],
          ),
        ),
      ),
    );
  }
}
