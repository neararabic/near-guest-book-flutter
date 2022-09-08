import 'package:flutter/material.dart';
import 'package:flutter_guest_book/near_api_flutter.dart';
import 'package:near_api_flutter/near_api_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginState { initial, loggedOut, validatingLogin, loggedIn, loginFailed }

class LoginProvider with ChangeNotifier {
  LoginState state = LoginState.initial;
  KeyPair keyPair = KeyStore.newKeyPair();

  static final LoginProvider _singleton = LoginProvider._internal();

  factory LoginProvider() {
    return _singleton;
  }

  LoginProvider._internal();

  loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? privateKey =
        prefs.getString(NearApiFlutter.PRIVATE_KEY_STRING);
    if (privateKey != null) {
      updateState(LoginState.loggedIn);
    } else {
      updateState(LoginState.loggedOut);
    }
  }

  validateLogin(accountId) async {
    updateState(LoginState.validatingLogin);
    if (await NearApiFlutter.hasAccessKey(accountId, keyPair)) {
      await setLoginPrefs(keyPair);
      updateState(LoginState.loggedIn);
    } else {
      updateState(LoginState.loginFailed);
    }
  }

  updateState(LoginState state) {
    this.state = state;
    notifyListeners();
  }

  setLoginPrefs(KeyPair keyPair) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(
        NearApiFlutter.PRIVATE_KEY_STRING,
        keyPair.privateKey.bytes
            .toString()
            .substring(1, keyPair.privateKey.bytes.toString().length - 1));
    await pref.setString(
        NearApiFlutter.PUBLIC_KEY_STRING,
        keyPair.privateKey.bytes
            .toString()
            .substring(1, keyPair.publicKey.bytes.toString().length - 1));
  }
}
