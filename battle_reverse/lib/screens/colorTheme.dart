import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:battle_reverse/utils/block_unit.dart';

class colorThemeClass{
  // color theme 배경, 테두리, 칸, 힌트
  static const colorTheme_1 = [0xff34495e, 0xff34495e, 0xff27ae60, 0xff9e9e9e];
  static const colorTheme_2 = [0xff001542, 0xff001542, 0xffFFB30D, 0xff9e9e9e];
  static const colorTheme_3 = [0xffBFADA3, 0xffBFADA3, 0xff594A3C, 0xffD9CEC5];
  static const colorTheme_4 = [0xff404040, 0xff404040, 0xffF2F0EF, 0xff595959];
  static const colorTheme_5 = [0xffF2F0EF, 0xffF2F0EF, 0xff404040, 0xffffffff];
  static const colorTheme_6 = [0xff595959, 0xff595959, 0xff73A9D9, 0xffF2F2F2];
  static const colorTheme_7 = [0xff133463, 0xff133463, 0xffDEA1BC, 0xffF2F0EF];
  // static const List<List> colorTheme = [colorTheme_1, colorTheme_2, colorTheme_3];
  static const List<List> colorTheme = [colorTheme_1, colorTheme_2, colorTheme_3, colorTheme_4, colorTheme_5, colorTheme_6, colorTheme_7];
}

class tierClass {
  static const List tierTheme = [0xff000000, 0xffa5704b, 0xffc8c8c8, 0xffffdc37];
}

class SkinPage extends StatelessWidget {
  const SkinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Start',
      theme: ThemeData(
        primaryColor: Colors.yellow,
      ),
      home: const Skin(title: 'Start'),
    );
  }
}

class Skin extends StatefulWidget {
  const Skin({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Skin> createState() => _Skin();
}

const double BLOCK_SIZE = 40;
const int ITEM_EMPTY = 0;
const int ITEM_WHITE = 1;
const int ITEM_BLACK = 2;
const int ITEM_HOLE = -1;
const int HINT = 3;

dynamic selected = 0;
const colorTheme = colorThemeClass.colorTheme;

dynamic t = 0;
const tierTheme = tierClass.tierTheme;

class _Skin extends State<Skin> {

  late List<List<BlockUnit>> table;

  void initTable() {
    table = [];
    // set init
    for (int row = 0; row < 8; row++) {
      List<BlockUnit> list = [];
      for (int col = 0; col < 8; col++) {
        list.add(BlockUnit(value: ITEM_EMPTY));
      }
      table.add(list);
    }
  }

  void initTableItems() {
    // 말
    table[1][1].value = ITEM_WHITE;
    table[2][1].value = ITEM_BLACK;
    table[1][2].value = ITEM_BLACK;
    table[2][2].value = ITEM_WHITE;
    // hint
    table[1][0].value = HINT;
    table[0][1].value = HINT;
    table[3][2].value = HINT;
    table[2][3].value = HINT;
  }

  // listview scrollbar 생성
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: EdgeInsets.all(20),
          color: Color(0xffF2EFE9),
          child: Column(children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50),),
            // Text('<적용할 스킨을 선택하세요.>',
            //   style: TextStyle(
            //     fontFamily: 'f1_L',
            //     letterSpacing: 2.3,
            //     fontSize: 20,
            //   ),
            // ),
            Container(child: Center(
              child: Container(
                decoration: BoxDecoration(
                    color: Color(colorTheme[selected][0]),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 8, color: Color(colorTheme[selected][1]))),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: buildTable()
                ),
              ),
            ),
              margin: EdgeInsets.only(top: 90, bottom: 90),
            ),
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              decoration: BoxDecoration(
                  color: Color(0xffffffff), borderRadius: BorderRadius.circular(10),
                  border: Border.all(width:6, color: Color(0xff403D39))
              ),
              child: Column(
                  children: <Widget>[
                    Text('테마',
                      style: TextStyle(
                        fontFamily: 'f1_L',
                        letterSpacing: 2.3,
                        fontSize: 20,
                      ),
                    ),
                    Text('----'),
                    Container(
                      padding: EdgeInsets.only(top: 5),
                      //color: Colors.black,
                      height: 90,
                      child: Scrollbar(
                        controller: _scrollController,
                        thickness: 3,
                        child: ListView.builder(
                          //controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            itemCount: colorTheme.length,
                            itemBuilder: (context, int index) {
                              return buildListView(index);
                            }),),
                    ),
                  ]
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Text('티어',
                style: TextStyle(
                  fontFamily: 'f1_L',
                  letterSpacing: 2.3,
                  fontSize: 20,
                ),
              ),)
          ],
          ),
        )
    );
  }

  Widget buildListView(index) {
    return Container(
      //margin: EdgeInsets.only(bottom: 5, top: 5),
      child: GestureDetector(onTap: () {
        changeView(index);
        Fluttertoast.showToast(
            msg: "해당 스킨이 적용됩니다.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            fontSize: 16.0
        );
      },
        child: Stack(
          children: <Widget>[
            Center(
                child: candidate(index)),
            Center(
              child: Container(width: 10, height:10,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Color(colorTheme[index][3]),)),)
          ],
        ),
      ),
      width: 80,
      height: 80,
    );
  }

  void changeView(index) {
    selected = index;
    setState(() {});
  }

  Widget candidate(index) {
    if (index == selected) {
      return Container(width: 60, height:60,
          decoration: BoxDecoration(color: Color(colorTheme[index][2]),
            borderRadius: BorderRadius.circular(8),));
    } else {
      return Container(width: 50, height:50,
          decoration: BoxDecoration(color: Color(colorTheme[index][2]),
            borderRadius: BorderRadius.circular(8),));
    }
  }

  List<Row> buildTable() {
    initTable();
    initTableItems();
    List<Row> listRow = [];
    for (int row = 0; row < 4; row++) {
      List<Widget> listCol = [];
      for (int col = 0; col < 4; col++) {
        listCol.add(
            Container(
              decoration: BoxDecoration(
                color: Color(colorTheme[selected][2]),
                borderRadius: BorderRadius.circular(2),
              ),
              width: BLOCK_SIZE,
              height: BLOCK_SIZE,
              margin: EdgeInsets.all(2),
              child: Center(child: buildItem(table[row][col]),),
            )
        );
      }
      Row rowWidget = Row(mainAxisSize: MainAxisSize.min, children: listCol);
      listRow.add(rowWidget);
    }
    return listRow;
  }

  // Widget buildBlockUnit(int row, int col)

  Widget buildItem(BlockUnit block) {
    if (block.value == ITEM_BLACK) {
      return Container(width: 30, height: 30,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Color(tierTheme[t])));
    } else if (block.value == ITEM_WHITE) {
      return Container(width: 30, height: 30,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white));
    } else if (block.value == ITEM_HOLE) {
      return Container(width: BLOCK_SIZE, height: BLOCK_SIZE,
        decoration: BoxDecoration(color: Color(colorTheme[selected][0]), borderRadius: BorderRadius.circular(2),),
      );}
    else if (block.value == HINT) {
      return Container(width: 10, height: 10,
          decoration: BoxDecoration(shape: BoxShape.circle, color: Color(colorTheme[selected][3]),));
    }
    return Container();
  }
}