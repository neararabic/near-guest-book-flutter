import 'package:near_api_flutter/near_api_flutter.dart';

class NearApiFlutter {
  static const String walletURL = 'https://wallet.testnet.near.org/login/?';
  static const String contractId = 'dev-1662536120717-43089161055688';
  static const String appTitle = 'GuestBook';
  static const String signInSuccessUrl =
      'https://near-transaction-serializer.herokuapp.com/success';
  static const String signInFailureUrl =
      'https://near-transaction-serializer.herokuapp.com/failure';
  static const String PRIVATE_KEY_STRING = "";
  static const String PUBLIC_KEY_STRING = "";
  static const String rpcProviderUrl = "https://archival-rpc.testnet.near.org";

  static connectWallet(accountId, KeyPair keyPair) {
    Account account = Account(
        accountId: accountId,
        keyPair: keyPair,
        provider: NEARTestNetRPCProvider());
    var wallet = Wallet(walletURL);
    wallet.connect(contractId, appTitle, signInSuccessUrl, signInFailureUrl,
        account.publicKey);
  }

  static Future<bool> hasAccessKey(accountId, KeyPair keyPair) async {
    Account account = Account(
        accountId: accountId,
        keyPair: keyPair,
        provider: NEARTestNetRPCProvider());
    AccessKey? accessKey = await account.findAccessKey();
    return accessKey.nonce == -1 ? false : true;
  }
}
