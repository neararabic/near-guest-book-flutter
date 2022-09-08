import 'package:flutter_guest_book/constants.dart';
import 'package:near_api_flutter/near_api_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static saveKeys(KeyPair keyPair) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> privateKeyStrList =
        keyPair.privateKey.bytes.map((i) => i.toString()).toList();
    List<String> publicKeyStrList =
        keyPair.publicKey.bytes.map((i) => i.toString()).toList();

    await pref.setStringList(Constants.PRIVATE_KEY_STRING, privateKeyStrList);

    await pref.setStringList(Constants.PUBLIC_KEY_STRING, publicKeyStrList);
  }

  static Future<KeyPair?> loadKeys() async {
    final prefs = await SharedPreferences. getInstance();

    //private key handling
    final List<String>? privateKeyStr =
        prefs.getStringList(Constants.PRIVATE_KEY_STRING);

    if (privateKeyStr == null) {
      return null;
    }

    List<int> privateKeyByteList =
        privateKeyStr.map((i) => int.parse(i)).toList();

    PrivateKey privateKey = PrivateKey(privateKeyByteList);

    //public key handling
    final List<String>? publicKeyStr =
        prefs.getStringList(Constants.PUBLIC_KEY_STRING);

    if (publicKeyStr == null) {
      return null;
    }

    List<int> publicKeyByteList =
        publicKeyStr.map((i) => int.parse(i)).toList();
    PublicKey publicKey = PublicKey(publicKeyByteList);

    KeyPair pair = KeyPair(privateKey, publicKey);

    return pair;
  }
}
