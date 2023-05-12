import 'dart:convert';

import 'package:http/http.dart' as http;

import '../data/const_myinfo.dart';
import 'exception_helper.dart';

abstract class INetworkHelper {
  Future<String> authorise({
    required String clientId,
    required String purpose,
    required String state,
    required String redirectURL,
    required String attributes,
  });
  Future<String> getToken({
    required String code,
    required String state,
    required String clientId,
    required String clientSecret,
    required String redirectURL,
    required Map<String, String> headers,
  });
  Future<String> getPersonData();
}

class NetworkHelper implements INetworkHelper {
  @override
  Future<String> authorise({
    required String clientId,
    required String purpose,
    required String state,
    required String redirectURL,
    required String attributes,
  }) async {
    var url =
        "${MyInfoConsts.baseURL}/authorise?attributes=$attributes&client_id=$clientId&state=$state&redirect_uri=$redirectURL&purpose=$purpose";
    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          "Access-Control-Allow-Origin": "*",
        },
      );
      if (response.statusCode == 200) {
        return url;
      }
      throw AppException(
        message: response.body,
      );
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<String> getToken({
    required String code,
    required String state,
    required String clientId,
    required String clientSecret,
    required String redirectURL,
    required Map<String, String> headers,
  }) async {
    try {
      var url = "${MyInfoConsts.baseURL}/token";
      var body = {
        "grant_type": "authorization_code",
        "code": code,
        "redirect_uri": redirectURL,
        "client_id": clientId,
        "client_secret": clientSecret,
      };
      var response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );
      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        return body["access_token"];
      }
      throw AppException(message: "Cannot Retreieve Token");
    } catch (e) {
      throw AppException(message: e.toString());
    }
  }

  @override
  Future<String> getPersonData() {
    // TODO: implement getPersonData
    throw UnimplementedError();
  }
}
