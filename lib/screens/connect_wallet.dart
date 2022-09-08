import 'package:flutter/material.dart';
import 'package:flutter_guest_book/providers/connect_wallet_provider.dart';
import 'package:flutter_guest_book/screens/home_page.dart';
import 'package:near_api_flutter/near_api_flutter.dart';
import 'package:provider/provider.dart';

class ConnectWalletScreen extends StatefulWidget {
  const ConnectWalletScreen({Key? key}) : super(key: key);

  @override
  State<ConnectWalletScreen> createState() => _ConnectWalletScreenState();
}

class _ConnectWalletScreenState extends State<ConnectWalletScreen>
    with WidgetsBindingObserver {
  String accountId = "";
  bool invalidAccountId = false;
  bool isConnectWalletDisabled = true;

  late WalletConnectProvider provider;
  late KeyPair keyPair;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<WalletConnectProvider>(context);
    switch (provider.state) {
      case WalletConnectionState.loggedIn:
        Future.delayed(const Duration(seconds: 2)).then((_) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const HomePage()));
        });
        return const CenteredCircularProgressIndicator();
      case WalletConnectionState.loggedOut:
        return buildLoginCard();
      case WalletConnectionState.validatingLogin:
        return const CenteredCircularProgressIndicator();
      case WalletConnectionState.loginFailed:
        return buildLoginFailed();
      default:
        return buildLoginCard();
    }
  }

  buildLoginFailed() {
    return Column(
      children: [
        buildLoginCard(),
        const Text(
          "Wallet connection failed, please try again",
          style: TextStyle(
              color: Colors.redAccent, backgroundColor: Colors.amberAccent),
        )
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    accountId = value;
                    checkNearAccountId(accountId);
                  });
                },
                decoration: const InputDecoration(
                    labelText: "NEAR account to connect with"),
              ),
            ),
            invalidAccountId
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Invalid near account ID (e.g. nearflutter.testnet)",
                      style: TextStyle(
                          color: Colors.redAccent,
                          backgroundColor: Colors.amberAccent),
                    ),
                  )
                : Container(),
            isConnectWalletDisabled
                ? ElevatedButton(
                    onPressed: null,
                    style: ElevatedButton.styleFrom(primary: Colors.grey),
                    child: const Text("Connect Wallet"))
                : ElevatedButton(
                    onPressed: () {
                      connectWallet(accountId);
                    },
                    child: const Text("Connect Wallet"))
          ],
        ),
      ),
    );
  }

  connectWallet(accountId) {
    //TODO replace with your own contract id and urls
    const String walletURL = 'https://wallet.testnet.near.org/login/?';
    const String contractId = 'dev-1662536120717-43089161055688';
    const String appTitle = 'GuestBook';
    const String signInSuccessUrl =
        'https://near-transaction-serializer.herokuapp.com/success';
    const String signInFailureUrl =
        'https://near-transaction-serializer.herokuapp.com/failure';

    keyPair = KeyStore.newKeyPair();

    //Create NEAR Account object to connect to the wallet with
    Account account = Account(
        accountId: accountId,
        keyPair: keyPair,
        provider: NEARTestNetRPCProvider());

    //create a wallet object and connect to it
    //this will open the wallet, and when the user navigates back to this screen,
    //the didChangeAppLifecycleState will be called. We go from there.
    var wallet = Wallet(walletURL);
    wallet.connect(contractId, appTitle, signInSuccessUrl, signInFailureUrl,
        account.publicKey);

  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    //detect when app opens back after connecting to the wallet
    switch (state) {
      case AppLifecycleState.resumed:
        if (accountId != "") {
          WalletConnectProvider()
              .validateLogin(accountId, keyPair); //changes ui state to validating
        }
        break;
      default:
        break;
    }
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
}

class CenteredCircularProgressIndicator extends StatelessWidget {
  const CenteredCircularProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
