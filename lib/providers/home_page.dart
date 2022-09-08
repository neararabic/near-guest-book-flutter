import 'package:flutter/material.dart';
import 'package:flutter_guest_book/near_api_flutter.dart';

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
    await Future.delayed(const Duration(seconds: 3));
    updateState(HomePageState.loaded);
  }

  updateState(HomePageState state) {
    this.state = state;
    notifyListeners();
  }
}
