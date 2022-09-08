import 'package:flutter/material.dart';
import 'package:flutter_guest_book/providers/login.dart';
import 'package:flutter_guest_book/near_api_flutter.dart';
import 'package:flutter_guest_book/screens/guest_book.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with WidgetsBindingObserver {
  String accountId = "";
  bool invalidAccountId = false;
  bool isConnectWalletDisabled = true;

  late LoginProvider provider;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        if (accountId != "") {
          LoginProvider().validateLogin(accountId);
        }
        break;
      default:
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
    provider = Provider.of<LoginProvider>(context);
    switch (LoginProvider().state) {
      case LoginState.initial:
        provider.loadPrefs();
        return const Center(child: CircularProgressIndicator());
      case LoginState.loggedIn:
        return GuestBook(keyPair: provider.keyPair);
      case LoginState.loggedOut:
        return buildLoginCard();
      case LoginState.validatingLogin:
        return const Center(child: CircularProgressIndicator());
      case LoginState.loginFailed:
        return buildLoginFailed();
      default:
        return buildLoginCard();
    }
  }

  buildLoginFailed() {
    return Column(
      children: [
        buildLoginCard(),
        buildErrorText("Wallet connection failed, please try again")
      ],
    );
  }

  buildLoginCard() {
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
        decoration:
            const InputDecoration(labelText: "NEAR account to connect with"),
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
        ? buildErrorText("Invalid near account ID (e.g. nearflutter.testnet)")
        : Container();
  }

  buildErrorText(errorMessage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        " $errorMessage ",
        style: const TextStyle(
            color: Colors.redAccent, backgroundColor: Colors.amberAccent),
      ),
    );
  }

  buildLoginButton() {
    return isConnectWalletDisabled
        ? ElevatedButton(
            onPressed: null,
            style: ElevatedButton.styleFrom(primary: Colors.grey),
            child: const Text("Connect Wallet"))
        : ElevatedButton(
            onPressed: () {
              NearApiFlutter.connectWallet(accountId, provider.keyPair);
            },
            child: const Text("Connect Wallet"));
  }
}
