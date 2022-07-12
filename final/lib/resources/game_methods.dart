import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mp_tictactoe/provider/room_data_provider.dart';
import 'package:mp_tictactoe/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../screens/colorTheme.dart';
import '../utils/block_unit.dart';
import '../utils/coordinate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mp_tictactoe/screens/create_room_screen.dart';

int score = 0;
dynamic name = nickname;

class GameMethods {

  // _loadCounter() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   score = (prefs.getInt('counter') ?? 1000);
  // }
  //
  _incrementCounter(int score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', (prefs.getInt('counter') ?? 1000) + score);
  }

  void checkWinner(BuildContext context, Socket socketClent) {
    RoomDataProvider roomDataProvider =
    Provider.of<RoomDataProvider>(context, listen: false);

    int winner = 0;

    int currentTurn = roomDataProvider.roomData['turn']['playerType'];

    if((roomDataProvider.countItemWhite == 0) || (roomDataProvider.countItemBlack == 0)) {
      winner = roomDataProvider.countItemWhite > roomDataProvider.countItemBlack ? ITEM_WHITE : ITEM_BLACK;
    } else if (makeHint(currentTurn, context) == 0) {
      // if (makeHint(inverseItem(currentTurn), context) == 0) {
        winner = roomDataProvider.countItemWhite > roomDataProvider.countItemBlack ? ITEM_WHITE : ITEM_BLACK;
      // }
      // else {
      //   currentTurn = inverseItem(roomDataProvider.currentTurn);
      //   setState(() {});
      //   Fluttertoast.showToast(
      //       msg: "turn passed",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.CENTER,
      //       backgroundColor: Colors.blue,
      //       textColor: Colors.black,
      //       fontSize: 16.0
      //   );
      // }
    }

    if (winner != 0) {

      if (roomDataProvider.player1.playerType == winner) {

        showGameDialog(context, '${roomDataProvider.player1.nickname} 승리!');
        socketClent.emit('winner', {
          'winnerSocketId': roomDataProvider.player1.socketID,
          'roomId': roomDataProvider.roomData['_id'],
        });
      } else {

        showGameDialog(context, '${roomDataProvider.player2.nickname} 승리!');
        socketClent.emit('winner', {
          'winnerSocketId': roomDataProvider.player2.socketID,
          'roomId': roomDataProvider.roomData['_id'],
        });
      }
      score = roomDataProvider.player1.nickname == name
          ? (roomDataProvider.countItemWhite - roomDataProvider.countItemBlack)*2
          : (roomDataProvider.countItemBlack - roomDataProvider.countItemWhite)*3;
      _incrementCounter(score);
    }
  }

  void clearBoard(BuildContext context) {
    RoomDataProvider roomDataProvider =
    Provider.of<RoomDataProvider>(context, listen: false);

    List<List<BlockUnit>> table = roomDataProvider.displayElements;


    // set init
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        roomDataProvider.displayElements[row][col] = BlockUnit(value: ITEM_EMPTY);
      }
    }
    roomDataProvider.displayElements[3][3].value = ITEM_WHITE;
    roomDataProvider.displayElements[4][3].value = ITEM_BLACK;
    roomDataProvider.displayElements[3][4].value = ITEM_BLACK;
    roomDataProvider.displayElements[4][4].value = ITEM_WHITE;
    // hint
    roomDataProvider.displayElements[2][4].value = HINT;
    roomDataProvider.displayElements[3][5].value = HINT;
    roomDataProvider.displayElements[4][2].value = HINT;
    roomDataProvider.displayElements[5][3].value = HINT;

    roomDataProvider.setCountItemTo0();

  }

  List<int> createRandomHole(BuildContext context) {
    RoomDataProvider roomDataProvider =
      Provider.of<RoomDataProvider>(context, listen: false);

    List<int> hole = [];
    var set = <int>{};
    while (set.length != 5) {
      int temp = Random().nextInt(64);
      if ((temp != 27) && (temp != 28) && (temp != 35) && (temp != 36))
        set.add(temp);
    }
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (set.contains(row * 8 + col)) {
          hole.add(row * 8 + col);
          // player1의 판에 random hole set
          // roomDataProvider.displayElements[row][col] = BlockUnit(value: ITEM_HOLE);
        }
      }
    }
    // print('create call');
    return hole;
  }

  void settingHole(BuildContext context, List hole) {
    RoomDataProvider roomDataProvider =
      Provider.of<RoomDataProvider>(context, listen: false);

    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (hole.contains(row * 8 + col)) {
          // random hole set
          roomDataProvider.displayElements[row][col] = BlockUnit(value: ITEM_HOLE);
        }
      }
    }
    // print('setting call');
  }

  // List<List<BlockUnit>> initTable() {
  //   List<List<BlockUnit>> table = [];
  //
  //   // set init
  //   for (int row = 0; row < 8; row++) {
  //     List<BlockUnit> list = [];
  //     for (int col = 0; col < 8; col++) {
  //       list.add(BlockUnit(value: ITEM_EMPTY));
  //     }
  //     table.add(list);
  //   }
  //   table[3][3].value = ITEM_WHITE;
  //   table[4][3].value = ITEM_BLACK;
  //   table[3][4].value = ITEM_BLACK;
  //   table[4][4].value = ITEM_WHITE;
  //   // hint
  //   table[2][3].value = HINT;
  //   table[3][2].value = HINT;
  //   table[4][5].value = HINT;
  //   table[5][4].value = HINT;
  //
  //   return table;
  // }

  bool pasteItemToTable(int row, int col, int item, BuildContext context) {
    RoomDataProvider roomDataProvider =
    Provider.of<RoomDataProvider>(context, listen: false);

    List<List<BlockUnit>> table = roomDataProvider.displayElements;
    int currentTurn = roomDataProvider.roomData['turn']['playerType'];

    if ((table[row][col].value == ITEM_EMPTY)||(table[row][col].value == HINT)) {
      List<Coordinate> listCoordinate = [];
      listCoordinate.addAll(checkRight(row, col, item, context));
      listCoordinate.addAll(checkDown(row, col, item, context));
      listCoordinate.addAll(checkLeft(row, col, item, context));
      listCoordinate.addAll(checkUp(row, col, item, context));
      listCoordinate.addAll(checkUpLeft(row, col, item, context));
      listCoordinate.addAll(checkUpRight(row, col, item, context));
      listCoordinate.addAll(checkDownLeft(row, col, item, context));
      listCoordinate.addAll(checkDownRight(row, col, item, context));

      if (listCoordinate.isNotEmpty) {
        roomDataProvider.displayElements[row][col].value = item;
        inverseItemFromList(listCoordinate, context);
        currentTurn = inverseItem(currentTurn);
        int n = makeHint(currentTurn, context);
        roomDataProvider.updateCountItem();
        //checkGameOver(n);
        return true;
      }
    }
    return false;
  }

  void inverseItemFromList(List<Coordinate> list, BuildContext context) {
    RoomDataProvider roomDataProvider =
    Provider.of<RoomDataProvider>(context, listen: false);

    List<List<BlockUnit>> table = roomDataProvider.displayElements;

    for (Coordinate c in list) {
      roomDataProvider.displayElements[c.row][c.col].value = inverseItem(table[c.row][c.col].value);
    }
  }

  int inverseItem(int item) {
    if (item == ITEM_WHITE) {
      return ITEM_BLACK;
    } else if (item == ITEM_BLACK) {
      return ITEM_WHITE;
    }
    return item;
  }

  int makeHint(int item, BuildContext context) {
    RoomDataProvider roomDataProvider =
    Provider.of<RoomDataProvider>(context, listen: false);

    List<List<BlockUnit>> table = roomDataProvider.displayElements;

    int n = 0;
    for (int r=0; r<8; r++) {
      for (int c=0; c<8; c++) {
        if (roomDataProvider.displayElements[r][c].value == HINT) {
          table[r][c].value = ITEM_EMPTY;
        }
        if (table[r][c].value == ITEM_EMPTY) {
          List<Coordinate> listCoordinate = [];
          listCoordinate.addAll(checkRight(r, c, item, context));
          listCoordinate.addAll(checkDown(r, c, item, context));
          listCoordinate.addAll(checkLeft(r, c, item, context));
          listCoordinate.addAll(checkUp(r, c, item, context));
          listCoordinate.addAll(checkUpLeft(r, c, item, context));
          listCoordinate.addAll(checkUpRight(r, c, item, context));
          listCoordinate.addAll(checkDownLeft(r, c, item, context));
          listCoordinate.addAll(checkDownRight(r, c, item, context));

          if (listCoordinate.isNotEmpty) {
            roomDataProvider.displayElements[r][c].value = HINT;
            n++;
          }
        }
      }
    }
    return n;
  }

  List<Coordinate> checkRight(int row, int col, int item, BuildContext context) {
    RoomDataProvider roomDataProvider =
    Provider.of<RoomDataProvider>(context, listen: false);

    List<List<BlockUnit>> table = roomDataProvider.displayElements;

    List<Coordinate> list = [];
    if (col + 1 < 8) {
      for (int c = col + 1; c < 8; c++) {
        if (table[row][c].value == item) {
          return list;
        } else if ((table[row][c].value == ITEM_EMPTY)||(table[row][c].value == HINT)) {
          return [];
        } else if (table[row][c].value == ITEM_HOLE) {
          return [];
        } else {
          list.add(Coordinate(row: row, col: c));
        }
      }
    }
    return [];
  }

  List<Coordinate> checkLeft(int row, int col, int item, BuildContext context) {
    RoomDataProvider roomDataProvider =
    Provider.of<RoomDataProvider>(context, listen: false);

    List<List<BlockUnit>> table = roomDataProvider.displayElements;

    List<Coordinate> list = [];
    if (col - 1 >= 0) {
      for (int c = col - 1; c >= 0; c--) {
        if (table[row][c].value == item) {
          return list;
        } else if ((table[row][c].value == ITEM_EMPTY)||(table[row][c].value == HINT)) {
          return [];
        } else if (table[row][c].value == ITEM_HOLE) {
          return [];
        } else {
          list.add(Coordinate(row: row, col: c));
        }
      }
    }
    return [];
  }

  List<Coordinate> checkDown(int row, int col, int item, BuildContext context) {
    RoomDataProvider roomDataProvider =
    Provider.of<RoomDataProvider>(context, listen: false);

    List<List<BlockUnit>> table = roomDataProvider.displayElements;

    List<Coordinate> list = [];
    if (row + 1 < 8) {
      for (int r = row + 1; r < 8; r++) {
        if (table[r][col].value == item) {
          return list;
        } else if ((table[r][col].value == ITEM_EMPTY)||(table[r][col].value == HINT)) {
          return [];
        } else if (table[r][col].value == ITEM_HOLE) {
          return [];
        } else {
          list.add(Coordinate(row: r, col: col));
        }
      }
    }
    return [];
  }

  List<Coordinate> checkUp(int row, int col, int item, BuildContext context) {
    RoomDataProvider roomDataProvider =
    Provider.of<RoomDataProvider>(context, listen: false);

    List<List<BlockUnit>> table = roomDataProvider.displayElements;

    List<Coordinate> list = [];
    if (row - 1 >= 0) {
      for (int r = row - 1; r >= 0; r--) {
        if (table[r][col].value == item) {
          return list;
        } else if ((table[r][col].value == ITEM_EMPTY)||(table[r][col].value == HINT)) {
          return [];
        } else if (table[r][col].value == ITEM_HOLE) {
          return [];
        } else {
          list.add(Coordinate(row: r, col: col));
        }
      }
    }
    return [];
  }

  List<Coordinate> checkUpLeft(int row, int col, int item, BuildContext context) {
    RoomDataProvider roomDataProvider =
    Provider.of<RoomDataProvider>(context, listen: false);

    List<List<BlockUnit>> table = roomDataProvider.displayElements;

    List<Coordinate> list = [];
    if (row - 1 >= 0 && col - 1 >= 0) {
      int r = row - 1;
      int c = col - 1;
      while (r >= 0 && c >= 0) {
        if (table[r][c].value == item) {
          return list;
        } else if ((table[r][c].value == ITEM_EMPTY)||(table[r][c].value == HINT)) {
          return [];
        } else if (table[r][c].value == ITEM_HOLE) {
          return [];
        } else {
          list.add(Coordinate(row: r, col: c));
        }
        r--;
        c--;
      }
    }
    return [];
  }

  List<Coordinate> checkUpRight(int row, int col, int item, BuildContext context) {
    RoomDataProvider roomDataProvider =
    Provider.of<RoomDataProvider>(context, listen: false);

    List<List<BlockUnit>> table = roomDataProvider.displayElements;

    List<Coordinate> list = [];
    if (row - 1 >= 0 && col + 1 < 8) {
      int r = row - 1;
      int c = col + 1;
      while (r >= 0 && c < 8) {
        if (table[r][c].value == item) {
          return list;
        } else if ((table[r][c].value == ITEM_EMPTY)||(table[r][c].value == HINT)) {
          return [];
        } else if (table[r][c].value == ITEM_HOLE) {
          return [];
        } else {
          list.add(Coordinate(row: r, col: c));
        }
        r--;
        c++;
      }
    }
    return [];
  }

  List<Coordinate> checkDownLeft(int row, int col, int item, BuildContext context) {
    RoomDataProvider roomDataProvider =
    Provider.of<RoomDataProvider>(context, listen: false);

    List<List<BlockUnit>> table = roomDataProvider.displayElements;

    List<Coordinate> list = [];
    if (row + 1 < 8 && col - 1 >= 0) {
      int r = row + 1;
      int c = col - 1;
      while (r < 8 && c >= 0) {
        if (table[r][c].value == item) {
          return list;
        } else if ((table[r][c].value == ITEM_EMPTY)||(table[r][c].value == HINT)) {
          return [];
        } else if (table[r][c].value == ITEM_HOLE) {
          return [];
        } else {
          list.add(Coordinate(row: r, col: c));
        }
        r++;
        c--;
      }
    }
    return [];
  }

  List<Coordinate> checkDownRight(int row, int col, int item, BuildContext context) {
    RoomDataProvider roomDataProvider =
    Provider.of<RoomDataProvider>(context, listen: false);

    List<List<BlockUnit>> table = roomDataProvider.displayElements;

    List<Coordinate> list = [];
    if (row + 1 < 8 && col + 1 < 8) {
      int r = row + 1;
      int c = col + 1;
      while (r < 8 && c < 8) {
        if (table[r][c].value == item) {
          return list;
        } else if ((table[r][c].value == ITEM_EMPTY)||(table[r][c].value == HINT)) {
          return [];
        } else if (table[r][c].value == ITEM_HOLE) {
          return [];
        } else {
          list.add(Coordinate(row: r, col: c));
        }
        r++;
        c++;
      }
    }
    return [];
  }
}
