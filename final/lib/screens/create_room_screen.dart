import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mp_tictactoe/resources/socket_client.dart';
import 'package:mp_tictactoe/resources/socket_methods.dart';
import 'package:mp_tictactoe/responsive/responsive.dart';
import 'package:mp_tictactoe/screens/main_menu_screen.dart';
import 'package:mp_tictactoe/widgets/custom_button.dart';
import 'package:mp_tictactoe/widgets/custom_text.dart';
import 'package:mp_tictactoe/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';

import '../provider/room_data_provider.dart';
import '../resources/game_methods.dart';

class CreateRoomScreen extends StatefulWidget {
  static String routeName = '/create-room';
  const CreateRoomScreen({Key? key}) : super(key: key);

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}


dynamic nickname;

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final SocketMethods _socketMethods = SocketMethods();
  int _counter = 1000;
  int _login = 0;

  //시작할 때 counter 값을 불러옵니다.
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _counter = (prefs.getInt('counter') ?? 1000);
    });
  }

  _loadLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _login = (prefs.getInt('login') ?? 0);
    });
  }

  @override
  void initState() {
    super.initState();

    _loadCounter();
    _loadLogin();
    _socketMethods.createRoomSuccessListener(context);
    _socketMethods.createHoleSuccessListener(context);
    _socketMethods.updatePlayersStateListener(context);
    // _socketMethods.endGameListener(context);
  }



  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if(_login == 0) {
      return MainMenuScreen();
    } else {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Responsive(
            child: Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    shadows: [
                      Shadow(
                        blurRadius: 40,
                        color: Colors.blue,
                      ),
                    ],
                    text: '$_counter',
                    fontSize: 60,
                  ),


                  SizedBox(height: size.height * 0.08),
                  CustomTextField(
                    controller: _nameController,
                    hintText: '사용할 닉네임을 입력해주세요.',
                  ),
                  SizedBox(height: size.height * 0.045),
                  CustomButton(
                      onTap: () {
                        nickname = _nameController.text;
                        GameMethods().clearBoard(context);

                        _socketMethods.createRoom(_nameController.text, context);

                      },
                      text: '게임시작'),
                  SizedBox(height: size.height * 0.045),
                  CustomButton(
                      onTap: () => SystemNavigator.pop(),
                      text: '게임종료'),
                ],
              ),
            ),
          ),

        ),
      );
    }


  }
}
