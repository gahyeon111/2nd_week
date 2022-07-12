import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mp_tictactoe/provider/room_data_provider.dart';
import 'package:mp_tictactoe/resources/socket_methods.dart';
import 'package:mp_tictactoe/utils/colors.dart';
import 'package:provider/provider.dart';

import '../screens/colorTheme.dart';
import '../utils/block_unit.dart';

class TicTacToeBoard extends StatefulWidget {
  const TicTacToeBoard({Key? key}) : super(key: key);

  @override
  State<TicTacToeBoard> createState() => _TicTacToeBoardState();
}

dynamic i = selected;
const colorTheme = colorThemeClass.colorTheme;

class _TicTacToeBoardState extends State<TicTacToeBoard> {
  final SocketMethods _socketMethods = SocketMethods();

  @override
  void initState() {
    super.initState();
    _socketMethods.tappedListener(context);
  }

  void tapped(int index, RoomDataProvider roomDataProvider, BuildContext context) {
    _socketMethods.tapGrid(
        index,
        roomDataProvider.roomData['_id'],
        roomDataProvider,
        context
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    RoomDataProvider roomDataProvider = Provider.of<RoomDataProvider>(context);




    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: size.height * 0.7,
        maxWidth: 500,
      ),
      child: AbsorbPointer(
        absorbing: roomDataProvider.roomData['turn']['socketID'] !=
            _socketMethods.socketClient.id,
        child: GridView.builder(
          itemCount: 64,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8,
          ),
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () => tapped(index, roomDataProvider, context),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.white24,
                  ),
                ),
                child: Center(
                  child: AnimatedSize(
                      duration: const Duration(milliseconds: 200),
                      child:
                      buildItem(roomDataProvider.displayElements[(index/8).toInt()][index%8])
                    // Text(
                    //   '0',
                    //   style: TextStyle(
                    //       color: Colors.white,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 100,
                    //       shadows: [
                    //         Shadow(
                    //           blurRadius: 40,
                    //           color:
                    //               roomDataProvider.displayElements[(index/8).toInt()][index%8].value == 0
                    //                   ? Colors.red
                    //                   : Colors.blue,
                    //         ),
                    //       ]),
                    // ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildItem(BlockUnit block) {
    if (block.value == ITEM_BLACK) {
      return Container(width: 30, height: 30,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue));
    } else if (block.value == ITEM_WHITE) {
      return Container(width: 30, height: 30,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white));
    } else if (block.value == ITEM_HOLE) {
      return Container(width: 40, height: 40,
        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2),),
      );}
    else if (block.value == HINT) {
      return Container(width: 10, height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Color(colorTheme[i][3]),));
    }
    return Container();
  }
}
