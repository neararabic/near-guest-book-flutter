import 'package:flutter/material.dart';
import 'package:near_api_flutter/near_api_flutter.dart';

class GuestBook extends StatefulWidget {
  const GuestBook({Key? key, accessKey, required this.keyPair}) : super(key: key);
  final KeyPair keyPair;

  @override
  State<GuestBook> createState() => _GuestBookState();
}

class _GuestBookState extends State<GuestBook> {
  @override
  Widget build(BuildContext context) {
    return const Text('Guest Book');
  }
}
