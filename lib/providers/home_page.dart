import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_guest_book/constants.dart';
import 'package:flutter_guest_book/models/message.dart';
import 'package:near_api_flutter/near_api_flutter.dart';

enum HomePageState { loadingMessages, addingMessage, loaded }

class HomePageProvider with ChangeNotifier {
  HomePageState state = HomePageState.loadingMessages;

  static final HomePageProvider _singleton = HomePageProvider._internal();

  factory HomePageProvider() {
    return _singleton;
  }

  HomePageProvider._internal();

  List messages = [];
  String transactionMessage = "";

  getMessages(KeyPair keyPair, String userAccountId) async {
    String method = 'get_messages';
    String methodArgs = '';
    Account connectedAccount = Account(
        accountId: userAccountId,
        keyPair: keyPair,
        provider: NEARTestNetRPCProvider());

    Contract contract = Contract(Constants.CONTRACT_ID, connectedAccount);

    Map response = await contract.callFunction(method, methodArgs);
    try {
      var result = utf8.decode(
          base64.decoder.convert(response['result']['status']['SuccessValue']));
      messages = (json.decode(result) as List)
          .map((e) => Message.fromJson(e))
          .toList();
    } catch (e) {
      transactionMessage = " RPC Error! Please try again later. ";
    }
    updateState(HomePageState.loaded);
  }

  addMessage(KeyPair keyPair, String userAccountId, String message,
      double deposit) async {
    updateState(HomePageState.addingMessage);
    String method = 'add_message';
    String methodArgs = '{"text":"$message"}';
    Account connectedAccount = Account(
        accountId: userAccountId,
        keyPair: keyPair,
        provider: NEARTestNetRPCProvider());

    Contract contract = Contract(Constants.CONTRACT_ID, connectedAccount);
    Map response = {};
    if (deposit > 0) {
      var wallet = Wallet(Constants.WALLET_LOGIN_URL);
      response = await contract.callFunctionWithDeposit(
          method,
          methodArgs,
          wallet,
          deposit,
          Constants.WEB_SUCCESS_URL,
          Constants.WEB_FAILURE_URL,
          Constants.WALLET_SIGN_URL);
    } else {
      response = await contract.callFunction(method, methodArgs);
    }
    if (response.containsKey("error")) {
      transactionMessage = " Something went wrong! ";
    } else {
      transactionMessage = " Thank you for the message! ";
      messages.add(Message.fromJson({
        "premium": deposit > 0 ? true : false,
        "sender": userAccountId,
        "text": message
      }));
    }
    updateState(HomePageState.loaded);
  }

  updateState(HomePageState state) {
    this.state = state;
    notifyListeners();
  }
}
