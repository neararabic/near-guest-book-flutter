
import 'package:flutter/material.dart';
import 'package:near_api_flutter/near_api_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum APIProviderState{
  initial, validatingLogin, loggedInSucceeded, loggedInFailed
}
class APIProvider with ChangeNotifier{
  APIProviderState state = APIProviderState.initial;

  static final APIProvider _singleton = APIProvider._internal();

  factory APIProvider() {
    return _singleton;
  }

  APIProvider._internal();
  validateLogin(userId, KeyPair keyPair)async{
    updateState(APIProviderState.validatingLogin);

    //call api to validate keypair + userid
    await Future.delayed(const Duration(seconds: 3), ()=>{});

    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString(Constants.PRIVATE_KEY_STRING, keyPair.privateKey.toString());
    await pref.setString(Constants.PUBLIC_KEY_STRING, keyPair.publicKey.toString());

    updateState(APIProviderState.loggedInSucceeded);
  }

  updateState(APIProviderState state){
    this.state = state;
    notifyListeners();

  }
}

class Constants {
  static const String PRIVATE_KEY_STRING = "PRIVATE_KEY_STRING";
  static const String PUBLIC_KEY_STRING = "PUBLIC_KEY_STRING";
}