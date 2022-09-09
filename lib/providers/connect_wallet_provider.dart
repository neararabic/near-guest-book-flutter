import 'package:flutter/material.dart';
import 'package:near_api_flutter/near_api_flutter.dart';
import '../local_storage.dart';
import '../near/near_api_calls.dart';

enum WalletConnectionState {
  initial,
  loggedOut,
  validatingLogin,
  loggedIn,
  loginFailed
}

class WalletConnectProvider with ChangeNotifier {
  KeyPair? keyPair;
  String? userAccountId;
  WalletConnectionState state = WalletConnectionState.initial;

  checkLoggedInUser() async {
    keyPair = await LocalStorage.loadKeys();
    userAccountId = await LocalStorage.loadUserId();

    if (keyPair != null && userAccountId != null) {
      updateState(WalletConnectionState.loggedIn);
    } else {
      updateState(WalletConnectionState.loggedOut);
    }
  }

  checkWalletConnectionResult(accountId, KeyPair keyPair) async {
    updateState(WalletConnectionState.validatingLogin);

    var accessKeyFound = await NEARApi().hasAccessKey(accountId, keyPair);
    if (accessKeyFound) {
      await LocalStorage.saveKeys(keyPair, accountId);
      updateState(WalletConnectionState.loggedIn);
    } else {
      updateState(WalletConnectionState.loginFailed);
    }

  }

  //notify ui with the updates state
  updateState(WalletConnectionState state) {
    this.state = state;
    notifyListeners();
  }

  //singleton
  static final WalletConnectProvider _singleton =
      WalletConnectProvider._internal();

  factory WalletConnectProvider() {
    return _singleton;
  }

  WalletConnectProvider._internal();
}
