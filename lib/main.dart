import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guest_book/api_provider.dart';
import 'package:flutter_guest_book/screens/login.dart';
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
          primarySwatch: Colors.deepPurple,
        ),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider<APIProvider>(create: (_) => APIProvider()),
          ],
          child: const MyHomePage(title: 'NEAR Guest Book (testnet)'),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool isLoggedIn = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (kDebugMode) {
      print("State: $state");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoggedIn ? Container() : const LoginScreen(),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
