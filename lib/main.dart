import 'package:flutter/material.dart';
import 'package:myinfo_v3_sample_webapp/route/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Myinfo Version 3 Implementation',
      theme: ThemeData(
        primarySwatch: Colors.amber,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routerConfig: RouteHelper().goRouter(),
    );
  }
}
