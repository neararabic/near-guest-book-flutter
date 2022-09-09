import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_guest_book/models/message.dart';
import 'package:near_api_flutter/near_api_flutter.dart';
import '../near/near_api_calls.dart';

enum HomePageState { initial, addingMessage, reloadMessages, loaded }

class GuestbookPageProvider with ChangeNotifier {
  HomePageState state = HomePageState.initial;

  List messages = [];
  String transactionMessage = "";

  getMessages(KeyPair keyPair, String userAccountId) async {
    String method = 'get_messages';
    String args = '';

    var response =
        await NEARApi().callFunction(userAccountId, keyPair, 0, method, args);
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
    String args = '{"text":"$message"}';
    var response =
        await NEARApi().callFunction(userAccountId, keyPair, deposit, method, args);
    if (response.containsKey("error")) {
      transactionMessage = " Something went wrong! ";
    } else {
      transactionMessage = " Message sent! ";
      messages.add(Message.fromJson({
        "premium": deposit > 0 ? true : false,
        "sender": userAccountId,
        "text": message
      }));
    }
    updateState(HomePageState.reloadMessages);
  }

  //update and notify ui state
  updateState(HomePageState state) {
    this.state = state;
    notifyListeners();
  }

  //singleton
  static final GuestbookPageProvider _singleton =
      GuestbookPageProvider._internal();

  factory GuestbookPageProvider() {
    return _singleton;
  }

  GuestbookPageProvider._internal();
}
