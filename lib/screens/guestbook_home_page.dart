import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_guest_book/constants.dart';
import 'package:flutter_guest_book/providers/guestbook_page_provider.dart';
import 'package:near_api_flutter/near_api_flutter.dart';
import 'package:provider/provider.dart';
import '../models/message.dart';
import '../widgets/centered_progress_indicator.dart';

class GuestbookPage extends StatefulWidget {
  final KeyPair keyPair;
  final String userAccountId;

  const GuestbookPage(
      {Key? key, required this.keyPair, required this.userAccountId})
      : super(key: key);

  @override
  State<GuestbookPage> createState() => _GuestbookPageState();
}

class _GuestbookPageState extends State<GuestbookPage>
    with WidgetsBindingObserver {
  late BuildContext buildContext;
  late GuestbookPageProvider provider;
  final messageController = TextEditingController();
  final donationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<GuestbookPageProvider>(context);
    switch (provider.state) {
      case HomePageState.initial:
      case HomePageState.reloadMessages:
        messageController.text = '';
        donationController.text = '';
        provider.getMessages(widget.keyPair, widget.userAccountId);
        return const CenteredCircularProgressIndicator();
      case HomePageState.addingMessage:
        return const CenteredCircularProgressIndicator();
      case HomePageState.loaded:
        return buildHomePage();
    }
  }

  buildHomePage() {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text("Contract: ${Constants.CONTRACT_ID}",
            style: TextStyle(fontWeight: FontWeight.bold)),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: messageController,
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
                      width: 70,
                      child: TextField(
                        controller: donationController,
                        decoration: const InputDecoration(labelText: ""),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,5}'))
                        ],
                      ),
                    ),
                    const Text("  Ⓝ"),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          String message = messageController.text;
                          double donation = donationController.text.isNotEmpty
                              ? double.parse(donationController.text)
                              : 0;
                          provider.addMessage(widget.keyPair,
                              widget.userAccountId, message, donation);
                        },
                        child: const Text("Sign")),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      provider.transactionMessage,
                      style: const TextStyle(
                          backgroundColor: Colors.blue, color: Colors.white),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
        Card(
          child: Container(),
        ),
        const Text(
          "Messages (last 20)",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: provider.messages.length,
            itemBuilder: (context, index) {
              Message item = provider.messages[index];
              return ListTile(
                contentPadding: const EdgeInsets.all(0),
                horizontalTitleGap: 0,
                minLeadingWidth: 0,
                leading: item.premium!
                    ? const VerticalDivider(
                        color: Colors.blue,
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

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    messageController.dispose();
    donationController.dispose();
    super.dispose();
  }

//this is to reload messages when adding new one and when coming back from signing
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    //detect when app opens back after connecting to te wallet
    switch (state) {
      case AppLifecycleState.resumed:
        if (provider.state == HomePageState.loaded) {
          provider.updateState(HomePageState.reloadMessages);
        }
        break;
      default:
        break;
    }
  }
}
