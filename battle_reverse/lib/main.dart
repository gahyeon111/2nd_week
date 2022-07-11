import 'package:battle_reverse/provider/room_data_provider.dart';
import 'package:battle_reverse/screens/game_screen.dart';
import 'package:battle_reverse/screens/login_screen.dart';
import 'package:battle_reverse/screens/main_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';

void main() {
  KakaoSdk.init(nativeAppKey: 'b0c7751657481bf90627c859c9680ca0');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RoomDataProvider(),
      child: MaterialApp(
        title: '배틀 리버스',
        routes: {
          LoginScreen.routeName: (context) => const LoginScreen(),
          MainMenuScreen.routeName: (context) => const MainMenuScreen(),
          GameScreen.routeName: (context) => const GameScreen(),
        },
        initialRoute: LoginScreen.routeName,
      ),
    );
  }
}
