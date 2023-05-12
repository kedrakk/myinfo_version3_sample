import 'package:myinfo_v3_sample_webapp/network/network_helper.dart';

class MyInfoController {
  final INetworkHelper networkHelper;
  MyInfoController({
    required this.networkHelper,
  });

  Future<String> authorise({
    required String clientId,
    required String purpose,
    required String state,
    required String redirectURL,
    required String attributes,
  }) async {
    try {
      return await networkHelper.authorise(
        clientId: clientId,
        purpose: purpose,
        state: state,
        redirectURL: redirectURL,
        attributes: attributes,
      );
    } catch (_) {
      rethrow;
    }
  }
}
