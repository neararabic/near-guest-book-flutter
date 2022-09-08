import 'package:flutter/material.dart';
import 'package:flutter_guest_book/near_api_flutter.dart';
import 'package:near_api_flutter/near_api_flutter.dart';
import '../local_storage.dart';

enum WalletConnectionState {
  initial,
  loggedOut,
  validatingLogin,
  loggedIn,
  loginFailed
}

class WalletConnectProvider with ChangeNotifier {
  WalletConnectionState state = WalletConnectionState.initial;

  static final WalletConnectProvider _singleton =
      WalletConnectProvider._internal();

  factory WalletConnectProvider() {
    return _singleton;
  }

  WalletConnectProvider._internal();

  KeyPair? keyPair;

  checkLoggedInUser() async {
    keyPair = await LocalStorage.loadKeys();
    if (keyPair != null) {
      updateState(WalletConnectionState.loggedIn);
    } else {
      updateState(WalletConnectionState.loggedOut);
    }
  }

  validateLogin(accountId, KeyPair keyPair) async {
    updateState(WalletConnectionState.validatingLogin);
    if (await NearApiFlutter().hasAccessKey(accountId, keyPair)) {
      await LocalStorage.saveKeys(keyPair);
      updateState(WalletConnectionState.loggedIn);
    } else {
      updateState(WalletConnectionState.loginFailed);
    }
  }

  updateState(WalletConnectionState state) {
    this.state = state;
    notifyListeners();
  }
}
