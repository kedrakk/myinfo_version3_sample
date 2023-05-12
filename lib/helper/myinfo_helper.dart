import 'dart:math';

class MyInfoHelper {
  String generateState() {
    var res = Random.secure().nextInt(999999) + 1000000;
    return res.toString();
  }
}
