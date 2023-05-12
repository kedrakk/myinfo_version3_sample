import 'package:http/http.dart' as http;

import 'exception_helper.dart';

abstract class INetworkHelper {
  Future<String> authorise({
    required String clientId,
    required String purpose,
    required String state,
    required String redirectURL,
    required String attributes,
  });
  Future<String> getToken();
  Future<String> getPersonData();
}

class NetworkHelper implements INetworkHelper {
  String baseURL = "https://test.api.myinfo.gov.sg/com/v3";
  @override
  Future<String> authorise({
    required String clientId,
    required String purpose,
    required String state,
    required String redirectURL,
    required String attributes,
  }) async {
    var url =
        "$baseURL/authorise?attributes=$attributes&client_id=$clientId&state=$state&redirect_uri=$redirectURL&purpose=$purpose";
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
  Future<String> getPersonData() {
    // TODO: implement getPersonData
    throw UnimplementedError();
  }

  @override
  Future<String> getToken() {
    // TODO: implement getToken
    throw UnimplementedError();
  }
}
