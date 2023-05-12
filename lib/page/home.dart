import 'package:flutter/material.dart';
import 'package:myinfo_v3_sample_webapp/data/const_assets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
