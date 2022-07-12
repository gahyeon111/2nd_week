import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mp_tictactoe/provider/room_data_provider.dart';
import 'package:mp_tictactoe/screens/create_room_screen.dart';
import 'package:mp_tictactoe/screens/game_screen.dart';
import 'package:mp_tictactoe/screens/main_menu_screen.dart';
import 'package:mp_tictactoe/utils/colors.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  KakaoSdk.init(nativeAppKey: 'b0c7751657481bf90627c859c9680ca0');
  runApp(const MyApp());
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // prefs.clear();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RoomDataProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: bgColor,
        ),
        routes: {
          MainMenuScreen.routeName: (context) => const MainMenuScreen(),
          CreateRoomScreen.routeName: (context) => const CreateRoomScreen(),
          GameScreen.routeName: (context) => const GameScreen(),
        },
        initialRoute: CreateRoomScreen.routeName,
      ),
    );
  }
}

