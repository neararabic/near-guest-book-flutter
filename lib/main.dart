import 'package:flutter/material.dart';
import 'package:flutter_guest_book/providers/connect_wallet_provider.dart';
import 'package:flutter_guest_book/providers/home_page.dart';
import 'package:flutter_guest_book/screens/home_page.dart';
import 'package:flutter_guest_book/screens/connect_wallet.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Guest Book',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(primary: const Color.fromARGB(255, 142, 193, 217))
            // primarySwatch: const Color.fromARGB(255, 142, 193, 217),
            ),
        home: Scaffold(
            appBar: AppBar(
              title: const Text("NEAR Guest Book - testnet"),
            ),
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider<WalletConnectProvider>(
                    create: (_) => WalletConnectProvider()),
                ChangeNotifierProvider<HomePageProvider>(
                    create: (_) => HomePageProvider())
              ],
              child: const AppContainer(),
            )));
  }
}

class AppContainer extends StatelessWidget {
  const AppContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WalletConnectProvider provider =
        Provider.of<WalletConnectProvider>(context);

    switch (provider.state) {
      case WalletConnectionState.initial:
        provider.checkLoggedInUser();
        return const CenteredCircularProgressIndicator();
      case WalletConnectionState.loggedIn:
        return HomePage(keyPair: provider.keyPair!);
      case WalletConnectionState.loggedOut:
      case WalletConnectionState.loginFailed:
        return const ConnectWalletScreen();
      case WalletConnectionState.validatingLogin:
        return const CenteredCircularProgressIndicator();
      default:
        return Container();
    }
  }
}
