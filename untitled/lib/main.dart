import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';

// kakao login
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:untitled/kakaologin/kakao_login.dart';
import 'package:untitled/kakaologin/main_view_model.dart';
import 'package:untitled/game/play.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled/startpage.dart';

void main() {
  KakaoSdk.init(nativeAppKey: '1c4ed3e0ce0a5df6c1b25d0000111392');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  //StreamController<Int> streamController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const MyHomePage(title: 'Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final viewModel = MainViewModel(KakaoLogin());

  final Stream<int> _bids = (() {
    late final StreamController<int> controller;
    controller = StreamController<int>(
      onListen: () async {
        await Future<void>.delayed(const Duration(seconds: 1));
        controller.add(1);
        await Future<void>.delayed(const Duration(seconds: 1));
        await controller.close();
      },
    );
    return controller.stream;
  })();

  // login
  final formkey = new GlobalKey<FormState>();

  late String _id;
  late String _password;

  void validateAndSave() {
    final form = formkey.currentState;
    if (form!.validate()) {
      form.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo22',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: StreamBuilder(
        stream: _bids,
        builder: (context, snapshot) {
          if (viewModel.isLogined) {
            return StartPage();
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text(widget.title),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // Image.network(
                    //     viewModel.user?.kakaoAccount?.profile?.profileImageUrl ?? ''),
                    Text(
                      '${viewModel.isLogined}',
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      child: new Form(
                          key: formkey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              TextFormField(
                                decoration: new InputDecoration(labelText: 'ID'),
                                validator: (value) => value!.isEmpty ? 'ID cannot be empty': null,
                                onSaved: (value) => _id = value!,
                              ),
                              TextFormField(
                                decoration: new InputDecoration(labelText: 'PW'),
                                validator: (value) => value!.isEmpty ? 'PW cannot be empty': null,
                                onSaved: (value) => _password = value!,
                              ),
                              ElevatedButton(
                                  onPressed: validateAndSave,
                                  child: Text('로그인')
                              ),
                              ElevatedButton(
                                  onPressed: validateAndSave,
                                  child: Text('이메일로 회원가입')
                              ),
                            ],
                          )
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await viewModel.logout();
                        await viewModel.login();
                        if (viewModel.isLogined) {
                          // Navigator.push(context, MaterialPageRoute(builder: (_) => PlayScreen()));
                          // Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (_) => StartPage()));
                        }
                        setState(() {}); // reload
                      },
                      child: const Text('Kakao Login'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await viewModel.logout();
                        setState(() {}); // reload
                      },
                      child: const Text('Kakao Logout'),
                    ),
                  ],
                ),
              ),
            );
          }
        }
      ),
    );
  }
}
