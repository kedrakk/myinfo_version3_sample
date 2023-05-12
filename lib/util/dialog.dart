import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

showErrorMessage({
  required BuildContext context,
  required String message,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(
        seconds: 3,
      ),
    ),
  );
}

showLoadingDialog(
  BuildContext context,
) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: const EdgeInsets.all(0),
        backgroundColor: Colors.black.withOpacity(.2),
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    },
  );
}

closeDialog(BuildContext context) {
  context.pop();
}
