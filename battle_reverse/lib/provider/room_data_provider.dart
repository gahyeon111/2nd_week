import 'dart:math';

import 'package:flutter/material.dart';
import 'package:battle_reverse/models/player.dart';
import 'package:battle_reverse/utils/block_unit.dart';
import 'package:battle_reverse/screens/colorTheme.dart';

// theme index
dynamic i = selected;
const colorTheme = colorThemeClass.colorTheme;

// score
dynamic score = 1000;

class RoomDataProvider extends ChangeNotifier {
  Map<String, dynamic> _roomData = {};
  //List<String> _displayElement = ['', '', '', '', '', '', '', '', ''];
  List<List<BlockUnit>> _displayElement = [
    [BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY)],
    [BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY)],
    [BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: HINT), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY)],
    [BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_WHITE), BlockUnit(value: ITEM_BLACK), BlockUnit(value: HINT), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY)],
    [BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: HINT), BlockUnit(value: ITEM_BLACK), BlockUnit(value: ITEM_WHITE), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY)],
    [BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: HINT), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY)],
    [BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY)],
    [BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY), BlockUnit(value: ITEM_EMPTY)],
  ];
  // List<List<BlockUnit>> _displayElement = [];

  //int _filledBoxes = 0;
  int _countItemWhite = 2;
  int _countItemBlack = 2;

  Player _player1 = Player(
    nickname: '',
    socketID: '',
    points: 0,
    playerType: 1,
  );

  Player _player2 = Player(
    nickname: '',
    socketID: '',
    points: 0,
    playerType: 2,
  );

  Map<String, dynamic> get roomData => _roomData;
  List<List<BlockUnit>> get displayElements => _displayElement;
  //int get filledBoxes => _filledBoxes;
  int get countItemWhite => _countItemWhite;
  int get countItemBlack => _countItemBlack;
  Player get player1 => _player1;
  Player get player2 => _player2;

  void updateRoomData(Map<String, dynamic> data) {
    _roomData = data;
    notifyListeners();
  }

  void updatePlayer1(Map<String, dynamic> player1Data) {
    _player1 = Player.fromMap(player1Data);
    notifyListeners();
  }

  void updatePlayer2(Map<String, dynamic> player2Data) {
    _player2 = Player.fromMap(player2Data);
    notifyListeners();
  }

  // void updateDisplayElements(int row, int col, BlockUnit choice) {
  //   _displayElement[row][col] = choice;
  //   //_filledBoxes += 1;
  //   _countItemBlack = 0;
  //   _countItemWhite = 0;
  //   for (int row = 0; row < 8; row++) {
  //     for (int col = 0; col < 8; col++) {
  //       if (_displayElement[row][col].value == ITEM_BLACK) {
  //         _countItemBlack++;
  //       } else if (_displayElement[row][col].value == ITEM_WHITE) {
  //         _countItemWhite++;
  //       }
  //     }
  //   }
  //   notifyListeners();
  // }

  void updateCountItem() {
    _countItemBlack = 0;
    _countItemWhite = 0;
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (_displayElement[row][col].value == ITEM_BLACK) {
          _countItemBlack++;
        } else if (_displayElement[row][col].value == ITEM_WHITE) {
          _countItemWhite++;
        }
      }
    }
    // notifyListeners();
  }

  void setCountItemTo0() {
    _countItemWhite = 0;
    _countItemBlack = 0;
  }
}
