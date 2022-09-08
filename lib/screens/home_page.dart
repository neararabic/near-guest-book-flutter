import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_guest_book/providers/home_page.dart';
import 'package:near_api_flutter/near_api_flutter.dart';
import 'package:provider/provider.dart';
import '../models/message.dart';

class HomePage extends StatefulWidget {
  final KeyPair keyPair;

  const HomePage({Key? key, required this.keyPair}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String message = "";
  int donation = 0;
  late HomePageProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<HomePageProvider>(context);
    switch (provider.state) {
      case HomePageState.loading:
        provider.getMessages();
        return const Center(
          child: CircularProgressIndicator(),
        );
      case HomePageState.loaded:
        return buildHomePage();
    }
  }

  buildHomePage() {
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
        ),
        Expanded(
          child:  ListView.builder(
            itemCount: provider.messages.length,
            itemBuilder: (context, index) {
              Message item = provider.messages[index];
              return ListTile(
                contentPadding: const EdgeInsets.all(0),
                horizontalTitleGap: 0,
                minLeadingWidth: 0,
                leading: item.premium!
                    ? const VerticalDivider(
                        color: Color.fromARGB(255, 142, 193, 217),
                        thickness: 3,
                      )
                    : const SizedBox(
                        width: 15,
                      ),
                title: Text(item.sender!),
                subtitle: Text(item.text!),
              );
            },
          ),
        )
      ]),
    ));
  }
}
