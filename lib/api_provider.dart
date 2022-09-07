
import 'package:flutter/material.dart';
import 'package:near_api_flutter/near_api_flutter.dart';

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

    updateState(APIProviderState.loggedInSucceeded);
  }

  updateState(APIProviderState state){
    this.state = state;
    notifyListeners();

  }
}