import 'package:flutter/material.dart';
import 'package:mp_tictactoe/provider/room_data_provider.dart';
import 'package:mp_tictactoe/resources/socket_methods.dart';
import 'package:mp_tictactoe/views/scoreboard.dart';
import 'package:mp_tictactoe/views/tictactoe_board.dart';
import 'package:mp_tictactoe/views/waiting_lobby.dart';
import 'package:provider/provider.dart';
import 'package:mp_tictactoe/screens/create_room_screen.dart';

import '../widgets/custom_button.dart';

class GameScreen extends StatefulWidget {
  static String routeName = '/game';
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

dynamic name = nickname;

class _GameScreenState extends State<GameScreen> {
  final SocketMethods _socketMethods = SocketMethods();



  @override
  void initState() {
    super.initState();
    _socketMethods.updateRoomListener(context);
    _socketMethods.updatePlayersStateListener(context);
    // _socketMethods.pointIncreaseListener(context);
    // _socketMethods.endGameListener(context);
  }

  @override
  Widget build(BuildContext context) {
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);


    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: roomDataProvider.roomData['isJoin']
            ? const WaitingLobby()
            : SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(name),
                    // CustomButton(
                    // onTap: roomDataProvider.roomData['turn']['nickname'] ==
                    //         ? null
                    //         : () {
                    //   // socketClent.emit('winner', {
                    //   //   roomDataProvider.player1.playerType
                    //   //   'winnerSocketId': roomDataProvider.player1.socketID,
                    //   //   'roomId': roomDataProvider.roomData['_id'],
                    //   // });
                    //   _socketMethods.deleteRoom(
                    //     roomIdController.text,
                    //   );
                    //   Navigator.pop(context);
                    //   print('항복을 눌렀슴니다');
                    // },
                    // text: '항복',
                    // ),
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
