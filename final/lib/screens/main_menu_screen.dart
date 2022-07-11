import 'package:flutter/material.dart';
import 'package:mp_tictactoe/responsive/responsive.dart';
import 'package:mp_tictactoe/screens/create_room_screen.dart';
import 'package:mp_tictactoe/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../kakaologin/kakao_login.dart';
import '../kakaologin/login_view_model.dart';
import '../widgets/custom_text.dart';

class MainMenuScreen extends StatefulWidget {
  static String routeName = '/main-menu';
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  void createRoom(BuildContext context) {
    Navigator.pushNamed(context, CreateRoomScreen.routeName);
  }

  final viewModel = LoginViewModel(KakaoLogin());

  _changeLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('login', (prefs.getInt('login') ?? 0));
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Responsive(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CustomText(
              shadows: [
                Shadow(
                  blurRadius: 40,
                  color: Colors.blue,
                ),
              ],
              text: '배틀 리버스',
              fontSize: 60,
            ),
            SizedBox(height: size.height * 0.08),
            GestureDetector(
              onTap: () async {
                await viewModel.login();
                setState(() {});
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setInt('login', 1);
                createRoom(context);
                // Navigator.pop(context);
                }, // Image tapped
              child: Image.asset(
                'assets/kakao_login_medium_wide.png',
                fit: BoxFit.cover, // Fixes border issues
                // width: 110.0,
                // height: 110.0,
              ),
            )
            // CustomButton(
            //   onTap: () => createRoom(context),
            //   text: '카카오톡으로 시작하기',
            // ),
          ],
        ),
      ),
    );
  }
}
