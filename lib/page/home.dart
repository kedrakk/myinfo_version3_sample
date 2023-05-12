import 'package:flutter/material.dart';
import 'package:myinfo_v3_sample_webapp/controller/myinfo_controller.dart';
import 'package:myinfo_v3_sample_webapp/data/const_assets.dart';
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
      var res = await MyInfoController(
        networkHelper: networkHelper,
      ).authorise();
      if (context.mounted) {
        closeDialog(context);
      }
      _launchURL(res);
    } catch (e) {
      if (context.mounted) {
        closeDialog(context);
      }
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
