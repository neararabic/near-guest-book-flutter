import 'package:flutter/material.dart';
import 'package:flutter_guest_book/providers/login.dart';
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
        home: Scaffold(
            appBar: AppBar(
              title: const Text("NEAR Guest Book - testnet"),
            ),
            body: MultiProvider(
              providers: [
                ChangeNotifierProvider<LoginProvider>(
                    create: (_) => LoginProvider()),
              ],
              child: const LoginScreen(),
            )));
  }
}
