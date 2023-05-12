import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myinfo_v3_sample_webapp/route/routes.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 100.0,
                width: 100.0,
                child: Icon(
                  Icons.error_outline,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Seems the route you\'ve navigated to doesn\'t exist!!',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  context.pushReplacementNamed(
                    Routes.home,
                  );
                },
                child: const Text(
                  "Back To Home",
                ),
              ),
              const SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
