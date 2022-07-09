import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:math';
import 'package:untitled/block_unit.dart';
import 'package:untitled/coordinate.dart';
import 'package:untitled/colortheme.dart';

class PlayScreen extends StatelessWidget {
  const PlayScreen({Key? key}) : super(key: key);

  Future<bool?> _onBackPressed(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text("나가시겠습니까?"),
          actions: <Widget>[
            ElevatedButton(
              child: Text("네"),
              onPressed: () => Navigator.pop(context, true),
            ),
            ElevatedButton(
              child: Text("아니요"),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          return await _onBackPressed(context) ?? false;
        },
        child: MaterialApp(
              title: 'Demo',
              // theme: ThemeData(
              //   primarySwatch: Colors.yellow,
              // ),
              darkTheme: ThemeData.dark(),
              home: const Play(title: 'Play'),
            )
    );
  }
}

class Play extends StatefulWidget {
  const Play({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Play> createState() => _Play();
}

const double BLOCK_SIZE = 40;
const int ITEM_EMPTY = 0;
const int ITEM_WHITE = 1;
const int ITEM_BLACK = 2;
const int ITEM_HOLE = -1;
const int HINT = 3;

// theme index
dynamic i = selected;
const colorTheme = colorThemeClass.colorTheme;
// gem theme
// const gemTheme_1 = Container(width: 30, height: 30,decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white));

class _Play extends State<Play> {
  // late: 선언 후 할당
  late List<List<BlockUnit>> table;
  int currentTurn = ITEM_BLACK;
  int countItemWhite = 0;
  int countItemBlack = 0;

  @override
  void initState() {
    i = selected;
    initTable();
    initTableItems();
    makeHint(ITEM_BLACK);
    super.initState();
  }

  void initTable() {
    table = [];
    // for 5 holes
    var set = <int>{};
    while (set.length != 5) {
      int temp = Random().nextInt(64);
      if ((temp != 27) && (temp != 28) && (temp != 35) && (temp != 36))
      set.add(temp);
    }
    // set init
    for (int row = 0; row < 8; row++) {
      List<BlockUnit> list = [];
      for (int col = 0; col < 8; col++) {
        if (set.contains(row * 8 + col)) {
          list.add(BlockUnit(value: ITEM_HOLE));
        } else {
          list.add(BlockUnit(value: ITEM_EMPTY));
        }
      }
      table.add(list);
    }
  }

  void initTableItems() {
    table[3][3].value = ITEM_WHITE;
    table[4][3].value = ITEM_BLACK;
    table[3][4].value = ITEM_BLACK;
    table[4][4].value = ITEM_WHITE;
  }

  int randomItem() {
    Random random = Random();
    return random.nextInt(3);
  }

  Widget build(BuildContext content) {
    return Scaffold(
          // appBar: AppBar(
          //   title: Text(widget.title),
          //   actions: [
          //     IconButton(
          //         icon: Icon(Icons.light_mode),
          //         onPressed: () {
          //           if (i < 2) i++;
          //           else i = 0;
          //           setState(() {});
          //         })
          //   ],
          // ),
          body: Container(
              color: Color(0xffecf0f1),
              child: Column(children: <Widget>[
                buildMenu(),
                Expanded(child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Color(colorTheme[i][0]),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(width: 8, color: Color(colorTheme[i][1]))),
                      child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: buildTable()
                      )),
                )),
                buildScoreTab()
              ])),
    );
  }

  Widget buildScoreTab() {
    return Row(mainAxisSize: MainAxisSize.max, children: <Widget>[
      Expanded(child: Container(color: Color(0xff34495e),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(padding: EdgeInsets.all(16),
                    child: buildItem(BlockUnit(value: ITEM_WHITE))),
                Text("x $countItemWhite", style: TextStyle(fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))
              ]))),
      Expanded(child: Container(color: Color(0xffbdc3c7),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(padding: EdgeInsets.all(16),
                    child: buildItem(BlockUnit(value: ITEM_BLACK))),
                Text("x $countItemBlack", style: TextStyle(fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black))
              ])))
    ]);
  }

  Container buildMenu() {
    return Container(
      padding: EdgeInsets.only(top: 50, bottom: 12, left: 16, right: 16),
      color: Color(0xffecf0f1),
      child:
      Row(mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(constraints: BoxConstraints(minWidth: 120),
                decoration: BoxDecoration(color: Color(0xffbbada0),
                    borderRadius: BorderRadius.circular(4)),
                padding: EdgeInsets.all(8),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                  Text("TURN", style: TextStyle(fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
                  Container(margin: EdgeInsets.only(left: 8), child:
                  buildItem(BlockUnit(value: currentTurn)))
                ])),
            Expanded(child: Container()),
            GestureDetector(onTap: () {
              restart();
            },
                child: Container(constraints: BoxConstraints(minWidth: 120),
                    decoration: BoxDecoration(color: Color(0xffecf0f1),
                        borderRadius: BorderRadius.circular(4)),
                    padding: EdgeInsets.all(12),
                    child: Column(children: <Widget>[
                      Text("Restart", style: TextStyle(fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))
                    ]))),
          ]),
    );
  }

  List<Row> buildTable() {
    List<Row> listRow = [];
    for (int row = 0; row < 8; row++) {
      List<Widget> listCol = [];
      for (int col = 0; col < 8; col++) {
        listCol.add(buildBlockUnit(row, col));
      }
      Row rowWidget = Row(mainAxisSize: MainAxisSize.min, children: listCol);
      listRow.add(rowWidget);
    }
    return listRow;
  }

  Widget buildBlockUnit(int row, int col) {
    return GestureDetector(
        onTap: () {
          setState(() {
            pasteItemToTable(row, col, currentTurn);
          });
        }, child: Container(
            decoration: BoxDecoration(
                color: Color(colorTheme[i][2]),
                borderRadius: BorderRadius.circular(2),
              ),
            width: BLOCK_SIZE,
            height: BLOCK_SIZE,
            margin: EdgeInsets.all(2),
            child: Center(child: buildItem(table[row][col])),
        )
    );
  }

  bool pasteItemToTable(int row, int col, int item) {
    if ((table[row][col].value == ITEM_EMPTY)||(table[row][col].value == HINT)) {
      List<Coordinate> listCoordinate = [];
      listCoordinate.addAll(checkRight(row, col, item));
      listCoordinate.addAll(checkDown(row, col, item));
      listCoordinate.addAll(checkLeft(row, col, item));
      listCoordinate.addAll(checkUp(row, col, item));
      listCoordinate.addAll(checkUpLeft(row, col, item));
      listCoordinate.addAll(checkUpRight(row, col, item));
      listCoordinate.addAll(checkDownLeft(row, col, item));
      listCoordinate.addAll(checkDownRight(row, col, item));

      if (listCoordinate.isNotEmpty) {
        table[row][col].value = item;
        inverseItemFromList(listCoordinate);
        currentTurn = inverseItem(currentTurn);
        int n = makeHint(currentTurn);
        updateCountItem();
        checkGameOver(n);
        return true;
      }
    }
    return false;
  }

  List<Coordinate> checkRight(int row, int col, int item) {
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

  List<Coordinate> checkLeft(int row, int col, int item) {
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

  List<Coordinate> checkDown(int row, int col, int item) {
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

  List<Coordinate> checkUp(int row, int col, int item) {
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

  List<Coordinate> checkUpLeft(int row, int col, int item) {
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

  List<Coordinate> checkUpRight(int row, int col, int item) {
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

  List<Coordinate> checkDownLeft(int row, int col, int item) {
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

  List<Coordinate> checkDownRight(int row, int col, int item) {
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

  void inverseItemFromList(List<Coordinate> list) {
    for (Coordinate c in list) {
      table[c.row][c.col].value = inverseItem(table[c.row][c.col].value);
    }
  }

  int makeHint(int item) {
    int n = 0;
    for (int r=0; r<8; r++) {
      for (int c=0; c<8; c++) {
        if (table[r][c].value == HINT) {
          table[r][c].value = ITEM_EMPTY;
        }
        if (table[r][c].value == ITEM_EMPTY) {
          List<Coordinate> listCoordinate = [];
          listCoordinate.addAll(checkRight(r, c, item));
          listCoordinate.addAll(checkDown(r, c, item));
          listCoordinate.addAll(checkLeft(r, c, item));
          listCoordinate.addAll(checkUp(r, c, item));
          listCoordinate.addAll(checkUpLeft(r, c, item));
          listCoordinate.addAll(checkUpRight(r, c, item));
          listCoordinate.addAll(checkDownLeft(r, c, item));
          listCoordinate.addAll(checkDownRight(r, c, item));

          if (listCoordinate.isNotEmpty) {
            table[r][c].value = HINT;
            n++;
          }
        }
      }
    }
    return n;
  }

  int inverseItem(int item) {
    if (item == ITEM_WHITE) {
      return ITEM_BLACK;
    } else if (item == ITEM_BLACK) {
      return ITEM_WHITE;
    }
    return item;
  }

  void updateCountItem() {
    countItemBlack = 0;
    countItemWhite = 0;
    for (int row = 0; row < 8; row++) {
      for (int col = 0; col < 8; col++) {
        if (table[row][col].value == ITEM_BLACK) {
          countItemBlack++;
        } else if (table[row][col].value == ITEM_WHITE) {
          countItemWhite++;
        }
      }
    }
  }

  Widget buildItem(BlockUnit block) {
    if (block.value == ITEM_BLACK) {
      return Container(width: 30, height: 30,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black));
    } else if (block.value == ITEM_WHITE) {
      return Container(width: 30, height: 30,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white));
    } else if (block.value == ITEM_HOLE) {
      return Container(width: BLOCK_SIZE, height: BLOCK_SIZE,
          decoration: BoxDecoration(color: Color(colorTheme[i][0]), borderRadius: BorderRadius.circular(2),),
    );}
    else if (block.value == HINT) {
      return Container(width: 10, height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Color(colorTheme[i][3]),));
    }
    return Container();
  }

  void restart() {
    setState(() {
      countItemWhite = 0;
      countItemBlack = 0;
      currentTurn = ITEM_BLACK;
      initTable();
      initTableItems();
      makeHint(ITEM_BLACK);
    });
  }

  void checkGameOver(int n) {
    if((countItemWhite == 0) || (countItemBlack == 0)) {
      GameOver();
    } else if (n == 0) {
      if (makeHint(inverseItem(currentTurn)) == 0) {
        GameOver();
      } else {
        currentTurn = inverseItem(currentTurn);
        setState(() {});
        Fluttertoast.showToast(
            msg: "turn passed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.blue,
            textColor: Colors.black,
            fontSize: 16.0
        );
      }
    }
    return;
  }

  Future<bool?> GameOver() {
    return Fluttertoast.showToast(
        msg: "Game Over",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
    );
  }
}