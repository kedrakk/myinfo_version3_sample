
import 'package:flutter/material.dart';
import 'package:myinfo_v3_sample_webapp/data/const_assets.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          AssetsConsts.retrieveImg,
        ),
      ),
    );
  }
}
