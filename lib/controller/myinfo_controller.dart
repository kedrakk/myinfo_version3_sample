import 'package:myinfo_v3_sample_webapp/network/network_helper.dart';

import '../data/const_myinfo.dart';
import '../helper/myinfo_helper.dart';

class MyInfoController {
  final INetworkHelper networkHelper;
  MyInfoController({
    required this.networkHelper,
  });

  Future<String> authorise() async {
    try {
      var state = MyInfoHelper().generateState();
      return await networkHelper.authorise(
        clientId: MyInfoConsts.clientId,
        purpose: MyInfoConsts.purpose,
        state: state,
        redirectURL: MyInfoConsts.redirectURL,
        attributes: MyInfoConsts.attributes,
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<String> getToken({
    required String code,
    required String state,
  }) async {
    try {
      var url = "${MyInfoConsts.baseURL}/token";
      var headers = await MyInfoHelper().generateRS256Header(
        code,
        url,
        MyInfoConsts.clientId,
        MyInfoConsts.clientSecret,
        isPerson: false,
      );
      return await networkHelper.getToken(
        clientId: MyInfoConsts.clientId,
        clientSecret: MyInfoConsts.clientSecret,
        code: code,
        state: state,
        redirectURL: MyInfoConsts.redirectURL,
        headers: headers,
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<String> getPersonData({
    required String code,
    required String token,
  }) async {
    try {
      var sub = MyInfoHelper().getSubFromToken(token);
      var url = "${MyInfoConsts.baseURL}/person/$sub/";
      var headers = await MyInfoHelper().generateRS256Header(
        code,
        url,
        MyInfoConsts.clientId,
        MyInfoConsts.clientSecret,
        isPerson: true,
        bearerForPerson: token,
      );
      return await networkHelper.getPersonData(
        clientId: MyInfoConsts.clientId,
        code: code,
        headers: headers,
        attributes: MyInfoConsts.attributes,
        authorizationToken: token,
        sub: sub,
      );
    } catch (_) {
      rethrow;
    }
  }
}
