import 'package:near_api_flutter/near_api_flutter.dart';

class NearApiFlutter {
  Future<bool> hasAccessKey(accountId, KeyPair keyPair) async {
    Account account = Account(
        accountId: accountId,
        keyPair: keyPair,
        provider: NEARTestNetRPCProvider());
    AccessKey? accessKey = await account.findAccessKey();
    return accessKey.nonce == -1 ? false : true;
  }
}
