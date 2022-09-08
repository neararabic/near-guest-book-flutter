import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_guest_book/local_storage.dart';
import 'package:flutter_guest_book/models/message.dart';
import 'package:near_api_flutter/near_api_flutter.dart';

enum HomePageState { loading, loaded }

class HomePageProvider with ChangeNotifier {
  HomePageState state = HomePageState.loading;

  static final HomePageProvider _singleton = HomePageProvider._internal();

  factory HomePageProvider() {
    return _singleton;
  }

  HomePageProvider._internal();

  List messages = [];

  getMessages() async {
    String method = 'get_messages';
    String methodArgs ='';
    String contractId = 'guestbook.nearflutter.testnet';
    String nearSignInSuccessUrl =
        'https://near-transaction-serializer.herokuapp.com/success';
    String nearSignInFailUrl =
        'https://near-transaction-serializer.herokuapp.com/failure';
    KeyPair  keyPair = (await LocalStorage.loadKeys())!;
    Account connectedAccount = Account(
        accountId: "mhassanist.testnet",
        keyPair: keyPair,
        provider: NEARTestNetRPCProvider());

    Contract contract = Contract(contractId, connectedAccount);

    Map response = await contract.callFunction(method, methodArgs);
    var result = utf8.decode(base64.decoder
        .convert(response['result']['status']['SuccessValue']));
    messages = (json.decode(result) as List).map((e) => Message.fromJson(e)).toList();
    updateState(HomePageState.loaded);
  }

  updateState(HomePageState state) {
    this.state = state;
    notifyListeners();
  }
}
