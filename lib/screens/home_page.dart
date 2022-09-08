import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:near_api_flutter/near_api_flutter.dart';

class HomePage extends StatefulWidget {
  final KeyPair keyPair;

  const HomePage({Key? key, required this.keyPair}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String message = "";
  int donation = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Sign the guest book, dev-1662536120717-43089161055688!"),
        TextField(
          onChanged: (value) {
            setState(() {
              message = value;
            });
          },
          decoration: const InputDecoration(labelText: "Message:"),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text("Donation (optional)"),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              width: 50,
              child: TextField(
                decoration: const InputDecoration(labelText: ""),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
              ),
            ),
            const Text("  Ⓝ"),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(onPressed: () {}, child: const Text("Sign")),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Messages",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        )
      ]),
    ));
  }
}
