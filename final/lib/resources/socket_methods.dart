import 'package:flutter/material.dart';
import 'package:mp_tictactoe/provider/room_data_provider.dart';
import 'package:mp_tictactoe/resources/game_methods.dart';
import 'package:mp_tictactoe/resources/socket_client.dart';
import 'package:mp_tictactoe/screens/game_screen.dart';
import 'package:mp_tictactoe/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketMethods {
  final _socketClient = SocketClient.instance.socket!;

  Socket get socketClient => _socketClient;

  // EMITS
  void createRoom(String nickname, BuildContext context) {
    if (nickname.isNotEmpty) {
      List<int> hole = GameMethods().createRandomHole(context);
      _socketClient.emit('createRoom', {
        'nickname': nickname,
        'hole': hole
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

  // void joinRoom(String nickname, String roomId) {
  //   if (nickname.isNotEmpty && roomId.isNotEmpty) {
  //     _socketClient.emit('joinRoom', {
  //       'nickname': nickname,
  //       'roomId': roomId,
  //     });
  //   }
  // }

  void tapGrid(int index, String roomId, RoomDataProvider roomDataProvider, BuildContext context) {
    if (GameMethods().pasteItemToTable((index/8).toInt(), index%8, roomDataProvider.roomData['turn']['playerType'], context)) {
      _socketClient.emit('tap', {
        'index': index,
        'roomId': roomId,
      });
    }
  }

  // LISTENERS
  void createRoomSuccessListener(BuildContext context) {
    _socketClient.on('createRoomSuccess', (room) {
      Provider.of<RoomDataProvider>(context, listen: false)
          .updateRoomData(room);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }
  void createHoleSuccessListener(BuildContext context) {
    _socketClient.on('createHoleSuccess', (hole) {
      // Provider.of<RoomDataProvider>(context, listen: false)
      //     .updateRoomData(hole);
      GameMethods().settingHole(context, hole);
      Navigator.pushNamed(context, GameScreen.routeName);
    });
  }

  // void joinRoomSuccessListener(BuildContext context) {
  //   _socketClient.on('joinRoomSuccess', (room) {
  //     Provider.of<RoomDataProvider>(context, listen: false)
  //         .updateRoomData(room);
  //     Navigator.pushNamed(context, GameScreen.routeName);
  //   });
  // }

  // void errorOccuredListener(BuildContext context) {
  //   _socketClient.on('errorOccurred', (data) {
  //     showSnackBar(context, data);
  //   });
  // }

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
      print(data);
      // check winnner
      GameMethods().checkWinner(context, _socketClient);
    });
  }

  // void pointIncreaseListener(BuildContext context) {
  //   _socketClient.on('pointIncrease', (playerData) {
  //     var roomDataProvider =
  //         Provider.of<RoomDataProvider>(context, listen: false);
  //     if (playerData['socketID'] == roomDataProvider.player1.socketID) {
  //       roomDataProvider.updatePlayer1(playerData);
  //     } else {
  //       roomDataProvider.updatePlayer2(playerData);
  //     }
  //   });
  // }

  // void endGameListener(BuildContext context) {
  //   _socketClient.on('endGame', (playerData) {
  //
  //     // score = roomDataProvider.player1.nickname == name
  //     //     ? (roomDataProvider.countItemWhite - roomDataProvider.countItemBlack)
  //     //     : (roomDataProvider.countItemBlack - roomDataProvider.countItemWhite);
  //     // _incrementCounter((score/2).toInt());
  //
  //
  //     showGameDialog(context, '${playerData['nickname']} won the game!');
  //     // Provider.of<RoomDataProvider>(context, listen: false).
  //
  //   });
  // }
}
