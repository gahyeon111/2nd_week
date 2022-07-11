
import 'package:battle_reverse/views/waiting_lobby.dart';
import 'package:flutter/material.dart';
import '../resources/socket_methods.dart';
import '../widgets/custom_textfield.dart';

class MainMenuScreen extends StatefulWidget {
  static String routeName = '/main-menu';
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final TextEditingController _nameController = TextEditingController();
  final SocketMethods _socketMethods = SocketMethods();


  @override
  void initState() {
    super.initState();
    _socketMethods.createRoomSuccessListener(context);
    _socketMethods.updatePlayersStateListener(context);
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('1000'),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Enter your nickname',
                ),
                ElevatedButton(
                    onPressed: () =>
                      // onlineMatching(context); // LoadingScreen으로 화면전환
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => WaitingLobby()));
                      _socketMethods.createRoom(
                        _nameController.text,
                      ),

                    child: const Text('온라인')
                ),
                // ElevatedButton(
                //     onPressed: () {
                //       // Navigator.push(context, MaterialPageRoute(builder: (_) => PlayScreen()));
                //     },
                //     child: const Text('오프라인')
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(context, MaterialPageRoute(builder: (_) => SkinPage()));
                //   },
                //   child: const Text('스킨선택'),
                // ),
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.pop(context);
                //     Navigator.push(context, MaterialPageRoute(builder: (_) => MyApp()));
                //   },
                //   child: const Text('Logout'),
                // ),
              ]
          )
      ),
    );
  }
}
