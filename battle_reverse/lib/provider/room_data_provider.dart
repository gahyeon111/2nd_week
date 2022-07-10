import 'package:battle_reverse/models/player.dart';
import 'package:flutter/material.dart';

class RoomDataProvider extends ChangeNotifier {
  Map<String, dynamic> _roomData = {};
  List<int> _displayElement =
  [0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,
    0,0,0,0,0,0,0,0,];
  int _filledBoxes = 0;

  Player _player1 = Player(nickname: '', socketID: '', points: 0, playerType: 1);
  Player _player2 = Player(nickname: '', socketID: '', points: 0, playerType: 2);

  Map<String, dynamic> get roomData => _roomData;
  List<int> get displayElements => _displayElement;
  int get filledBoxes => _filledBoxes;
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

  void updateDisplayElements(int index, int choice) {
    _displayElement[index] = choice;
    notifyListeners();
  }
}