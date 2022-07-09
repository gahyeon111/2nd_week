import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/block_unit.dart';

class colorThemeClass{
  // color theme 배경, 테두리, 칸, 힌트
  static const colorTheme_1 = [0xff34495e, 0xff34495e, 0xff27ae60, 0xff9e9e9e];
  static const colorTheme_2 = [0xff001542, 0xff001542, 0xffFFB30D, 0xff9e9e9e];
  static const colorTheme_3 = [0xff802922, 0xff802922, 0xff4A4633, 0xffBFBE9C];
  // static const List<List> colorTheme = [colorTheme_1, colorTheme_2, colorTheme_3];
  static const List<List> colorTheme = [colorTheme_1, colorTheme_2, colorTheme_3, colorTheme_3, colorTheme_3, colorTheme_3, colorTheme_3, colorTheme_3];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('스킨 선택'),
        // actions: [
        //   IconButton(
        //       icon: Icon(Icons.light_mode),
        //       onPressed: () {
        //         if (selected < 2) selected++;
        //         else selected = 0;
        //         setState(() {});
        //       })
        // ],
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        color: Color(0xffecf0f1),
        child: Column(children: <Widget>[
          Expanded(child: Center(
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
          )),
          SizedBox(
            height: 100,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: colorTheme.length,
                itemBuilder: (context, int index) {
                  return buildListView(index);
                }),
          )
        ],
        ),
      )
    );
  }

  Widget buildListView(index) {
    return Container(
      margin: EdgeInsets.all(10),
      color: Color(0xffecf0f1),
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
                  decoration: BoxDecoration(shape: BoxShape.circle, color: Color(colorTheme[selected][3]),)),)
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
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.black));
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