import 'package:flutter/material.dart';
import 'package:flutter_guest_book/api_provider.dart';
import 'package:flutter_guest_book/near_api_flutter.dart';
import 'package:near_api_flutter/near_api_flutter.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver{
  String accountId = "";
  bool invalidAccountId = false;
  bool isConnectWalletDisabled = true;
  KeyPair keyPair = KeyStore.newKeyPair();
  bool isLoggedIn = false;

  late APIProvider provider;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print(state);
    switch(state){
      case AppLifecycleState.resumed:
        APIProvider().validateLogin(accountId,keyPair);
        break;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<APIProvider>(context);
    switch (APIProvider().state) {
      case APIProviderState.loggedInSucceeded:
        return const Center(child: Text("LoggedIn"));
      case APIProviderState.validatingLogin:
        return const Center(child: Text("loading........."));
      default:
        return SizedBox(
          height: 150,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildUserAccountIdTextField(),
                buildAccountIdErrorMessage(),
                buildLoginButton()
              ],
            ),
          ),
        );
    }
  }

  buildUserAccountIdTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        onChanged: (value) {
          setState(() {
            accountId = value;
            checkNearAccountId(accountId);
          });
        },
        decoration: const InputDecoration(labelText: "NEAR account to connect with"),
      ),
    );
  }

  checkNearAccountId(accountId) {
    RegExp regExp = RegExp(
      r"^\w+(?:\.\w+)*\.testnet$",
      caseSensitive: true,
      multiLine: false,
    );
    if (regExp.allMatches(accountId).isNotEmpty) {
      invalidAccountId = false;
      isConnectWalletDisabled = false;
    } else {
      invalidAccountId = true;
      isConnectWalletDisabled = true;
    }
  }

  buildAccountIdErrorMessage() {
    return invalidAccountId
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              " Invalid near account ID (e.g. nearflutter.testnet) ",
              style: TextStyle(
                  color: Colors.redAccent, backgroundColor: Colors.amberAccent),
            ),
          )
        : Container();
  }

  buildLoginButton() {
    return isConnectWalletDisabled
        ? ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(primary: Colors.grey),
            child: const Text("Connect Wallet"))
        : ElevatedButton(
            onPressed: () {
              setState(() {
                isLoggedIn = true;
              });
              NearApiFlutter.connectWallet(accountId, keyPair);
            },
            child: const Text("Connect Wallet"));
  }
}
