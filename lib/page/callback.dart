import 'package:flutter/material.dart';

class CallBackPage extends StatelessWidget {
  const CallBackPage({
    super.key,
    required this.code,
    required this.state,
    this.error = "",
    this.errorDesc = "",
  });
  final String state, code, error, errorDesc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "State: $state, Code: $code",
        ),
      ),
    );
  }
}
