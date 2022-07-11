import 'package:mp_tictactoe/kakaologin/social_login.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class LoginViewModel {
  final SocialLogin _socialLogin;
  bool isLogined = false;
  User? user;

  LoginViewModel(this._socialLogin);

  Future login() async {
    isLogined = await _socialLogin.login();
    if (isLogined) {
      user = await UserApi.instance.me();
    }
  }

  Future logout() async {
    await _socialLogin.logout();
    isLogined = false;
    user = null;
  }
}