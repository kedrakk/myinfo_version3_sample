import 'dart:convert';
import 'dart:math';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/services.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:myinfo_v3_sample_webapp/network/exception_helper.dart';

import '../data/const_myinfo.dart';

class MyInfoHelper {
  String generateState() {
    var res = Random.secure().nextInt(999999) + 1000000;
    return res.toString();
  }

  String getSubFromToken(String bToken) {
    Map<String, dynamic> payload = Jwt.parseJwt(bToken);
    return payload['sub'];
  }

  Future<Map<String, String>> generateRS256Header(
    String code,
    String url,
    String clientId,
    String clientSecret, {
    required bool isPerson,
    String bearerForPerson = "",
  }) async {
    var cacheCtrl = "nocache";
    var contentType = "application/x-www-form-urlencoded";
    var method = isPerson ? "GET" : "POST";

    var headerParams = {
      "Content-Type": contentType,
      "Cache-Control": cacheCtrl,
    };
    var privateKeyContent = await _readingPrivateKey();
    var authHeader = _authHeaderGenerate(
      url,
      method,
      privateKeyContent,
      code,
      clientId,
      clientSecret,
      isInfoURL: isPerson,
    );
    if (isPerson) {
      authHeader += ",Bearer $bearerForPerson";
    }
    headerParams.addAll(
      {
        "Authorization": authHeader,
      },
    );
    return headerParams;
  }

  _authHeaderGenerate(
    url,
    String method,
    keyContent,
    code,
    String clientId,
    String clientSecret, {
    required bool isInfoURL,
  }) {
    var nounceValue = _nounceGenerator();
    var timeStamp = _timeStampGenerator();
    var baseParams = {
      "app_id": clientId,
      "client_id": clientId,
      "client_secret": clientSecret,
      "code": code,
      "grant_type": "authorization_code",
      "nonce": nounceValue,
      "redirect_uri": MyInfoConsts.redirectURL,
      "signature_method": "RS256",
      "timestamp": timeStamp,
    };
    if (isInfoURL) {
      baseParams = {
        "app_id": clientId,
        "attributes": MyInfoConsts.attributes,
        "client_id": clientId,
        "nonce": nounceValue,
        "signature_method": "RS256",
        "timestamp": timeStamp,
      };
    }
    var baseParamString = _mapToParam(baseParams);
    var baseString = "${method.toUpperCase()}&$url&$baseParamString";
    var signature = _generateSign(baseString, keyContent);
    var strAuthHeader =
        "PKI_SIGN timestamp=\"$timeStamp\",nonce=\"$nounceValue\",app_id=\"$clientId\",signature_method=\"RS256\",signature=\"$signature\"";
    return strAuthHeader;
  }

  _generateSign(String data, dynamic secretKey) {
    try {
      final message = utf8.encode(data);
      var unint8Data = Uint8List.fromList(message);
      var sign = CryptoUtils.rsaSign(
        secretKey,
        unint8Data,
      );
      var res = base64Encode(sign);
      return res;
    } catch (exp) {
      throw AppException(message: exp.toString());
    }
  }

  _nounceGenerator() {
    final rand = Random.secure();
    var nonceValue = List<int>.generate(20, (i) => rand.nextInt(256));
    return nonceValue.map((i) => i.toRadixString(16).padLeft(2, '0')).join();
  }

  _timeStampGenerator() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  _readingPrivateKey() async {
    try {
      var res = await rootBundle.loadString(MyInfoConsts.privateCert);
      var data = CryptoUtils.rsaPrivateKeyFromPem(
        res,
      );
      return data;
    } catch (exp) {
      throw AppException(message: exp.toString());
    }
  }

  _mapToParam(Map myMap) {
    String res = "";
    for (var element in myMap.entries) {
      res += element.key + "=" + element.value + "&";
    }
    var newString = res.substring(0, res.length - 1);
    return newString;
  }
}
