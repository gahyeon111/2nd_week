import 'package:battle_reverse/provider/room_data_provider.dart';
import 'package:battle_reverse/resources/socket_client.dart';
import 'package:battle_reverse/screens/game_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../utils/utils.dart';
import 'game_methods.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  void createRoom(String nickname) {
    if (nickname.isNotEmpty) {
      _socketClient.emit('createRoom', {
        'nickname': nickname,
      });
    }
  }

  void deleteRoom(String roomId) {
    if (roomId.isNotEmpty) {
      _socketClient.emit('deleteRoom', {
        'roomId': roomId,
      });
    }
  }

  void createRoomSuccessListener(BuildContext context) {
    _socketClient.on('createRoomSuccess', (room) {
      Provider.of<RoomDataProvider>(context, listen: false).updateRoomData(room);
      Navigator.push(context, MaterialPageRoute(builder: (_) => GameScreen()));
      // Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  void updatePlayersStateListener(BuildContext context) {
    _socketClient.on('updatePlayers', (playerData) {
      Provider.of<RoomDataProvider>(context, listen: false).updatePlayer1(
        playerData[0],
      );
      Provider.of<RoomDataProvider>(context, listen: false).updatePlayer2(
        playerData[1],
      );
    });
  }

  void tapGrid(int index, String roomId, RoomDataProvider roomDataProvider, BuildContext context) {
    if (GameMethods().pasteItemToTable((index/8).toInt(), index%8, roomDataProvider.roomData['turn']['playerType'], context)) {
      _socketClient.emit('tap', {
        'index': index,
        'roomId': roomId,
      });
    }
  }

  void updateRoomListener(BuildContext context) {
    _socketClient.on('updateRoom', (data) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(data);
    });
  }

  void tappedListener(BuildContext context) {
    _socketClient.on('tapped', (data) {
      RoomDataProvider roomDataProvider =
        Provider.of<RoomDataProvider>(context, listen: false);
      GameMethods().pasteItemToTable((data['index']/8).toInt(), data['index']%8, data['choice'], context);
      roomDataProvider.updateRoomData(data['room']);
      // check winnner
      GameMethods().checkWinner(context, _socketClient);
      // if (GameMethods().checkWinner(context, _socketClient) == 2) {
      //   _socketClient.emit('tap', {
      //     'index': -1,
      //     'roomId': data['room'],
      //   });
      // }
    });
  }

  // void pointIncreaseListener(BuildContext context) {
  //   _socketClient.on('pointIncrease', (playerData) {
  //     var roomDataProvider =
  //     Provider.of<RoomDataProvider>(context, listen: false);
  //     if (playerData['socketID'] == roomDataProvider.player1.socketID) {
  //       roomDataProvider.updatePlayer1(playerData);
  //     } else {
  //       roomDataProvider.updatePlayer2(playerData);
  //     }
  //   });
  // }

  void endGameListener(BuildContext context) {
    _socketClient.on('endGame', (playerData) {
      showGameDialog(context, '${playerData['nickname']} won the game!');
      Navigator.pop(context);
      // Navigator.popUntil(context, (route) => false);
    });
  }


}