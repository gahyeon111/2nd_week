import 'package:battle_reverse/kakaologin/kakao_login.dart';
import 'package:battle_reverse/kakaologin/login_view_model.dart';
import 'package:battle_reverse/screens/main_menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  final viewModel = LoginViewModel(KakaoLogin());

  //TODO
  //StreamBuilder를 써야하는가?
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('배틀 리버스'),
              Text(viewModel.user?.kakaoAccount?.profile?.nickname ?? ''),
              ElevatedButton(
                // Navigator.push(context, MaterialPageRoute(builder: (_) => MainMenuScreen()));

                onPressed: () async {
                  await viewModel.login();
                  setState(() {});
                  Navigator.pushNamed(context, MainMenuScreen.routeName);
                },
                child: const Text('카카오톡으로 시작하기'),
              ),
            ],
          ),
        ),
      );

  }
}
