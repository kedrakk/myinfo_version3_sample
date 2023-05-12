import 'package:flutter/material.dart';
import 'package:myinfo_v3_sample_webapp/controller/myinfo_controller.dart';
import 'package:myinfo_v3_sample_webapp/data/const_assets.dart';
import 'package:myinfo_v3_sample_webapp/data/const_myinfo.dart';
import 'package:myinfo_v3_sample_webapp/helper/myinfo_helper.dart';
import 'package:myinfo_v3_sample_webapp/util/dialog.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import '../di/di_helper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () => _retrieveData(context),
          child: Image.asset(
            AssetsConsts.retrieveImg,
          ),
        ),
      ),
    );
  }

  _retrieveData(
    BuildContext context,
  ) async {
    try {
      showLoadingDialog(context);
      var state = MyInfoHelper().generateState();
      var res = await MyInfoController(networkHelper: networkHelper).authorise(
        clientId: MyInfoConsts.clientId,
        purpose: MyInfoConsts.purpose,
        state: state,
        redirectURL: MyInfoConsts.redirectURL,
        attributes: MyInfoConsts.attributes,
      );
      if (context.mounted) {
        closeDialog(context);
      }
      _launchURL(res);
    } catch (e) {
      showErrorMessage(
        context: context,
        message: e.toString(),
      );
    }
  }

  _launchURL(String res) {
    html.window.location.assign(res);
  }
}
