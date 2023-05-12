import 'package:flutter/services.dart';
import 'package:jose/jose.dart';

import '../data/const_myinfo.dart';

class DecryptHelper {
  Future<String> decryptPayload(
    String encoded,
  ) async {
    try {
      var jweData = JsonWebEncryption.fromCompactSerialization(encoded);
      var publicKey = await _getKey(false);
      var jwk = JsonWebKey.fromPem(
        publicKey,
        keyId: jweData.commonHeader.keyId,
      );
      var keyStore = JsonWebKeyStore()..addKey(jwk);
      List<String>? algorithms = [
        if (jweData.commonProtectedHeader.algorithm != null)
          jweData.commonProtectedHeader.algorithm!,
        if (jweData.commonProtectedHeader.encryptionAlgorithm != null)
          jweData.commonProtectedHeader.encryptionAlgorithm!,
        if (jweData.commonProtectedHeader.compressionAlgorithm != null)
          jweData.commonProtectedHeader.compressionAlgorithm!,
      ];
      var payload = await jweData.getPayload(
        keyStore,
        allowedAlgorithms: algorithms,
      );
      var content = payload.jsonContent;
      return _verifyPayload(
        content,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<String> _verifyPayload(
    String data,
  ) async {
    try {
      var jwsData = JsonWebSignature.fromCompactSerialization(data);
      var publicKey = await _getKey(true);
      var jwk = JsonWebKey.fromPem(
        publicKey,
        keyId: jwsData.commonHeader.keyId,
      );
      var keyStore = JsonWebKeyStore()..addKey(jwk);
      var verify = await _verifyJWS(
        keyStore,
        ["RS256"],
        jwsData,
      );
      var payload = jwsData.unverifiedPayload.stringContent;
      if (verify) {
        return payload;
      }
      return "Invalid data";
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> _verifyJWS(
    JsonWebKeyStore keyStore,
    List<String> algos,
    JsonWebSignature jwsData,
  ) async {
    try {
      await jwsData.getPayload(
        keyStore,
        allowedAlgorithms: algos,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  _getKey(bool isPublic) async {
    String source =
        isPublic ? MyInfoConsts.publicCert : MyInfoConsts.privateCert;
    var res = await rootBundle.loadString(source);
    // res = res
    //     .replaceAll("-----BEGIN PRIVATE KEY-----", "")
    //     .replaceAll("-----END PRIVATE KEY-----", "")
    //     .replaceAll("\n", "");
    return res;
  }
}
