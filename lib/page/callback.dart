import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../controller/myinfo_controller.dart';
import '../di/di_helper.dart';
import '../route/routes.dart';
import '../util/dialog.dart';

class CallBackPage extends StatefulWidget {
  const CallBackPage({
    super.key,
    required this.code,
    required this.state,
    this.error = "",
    this.errorDesc = "",
  });
  final String state, code, error, errorDesc;

  @override
  State<CallBackPage> createState() => _CallBackPageState();
}

class _CallBackPageState extends State<CallBackPage> {
  String bToken = "";
  String personData = "";
  String decryptedPersonData = "";
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.state.isNotEmpty && widget.code.isNotEmpty) {
        _getData(context);
      }
    });
  }

  _getData(
    BuildContext context,
  ) async {
    try {
      showLoadingDialog(context);
      var res = await MyInfoController(
        networkHelper: networkHelper,
      ).getToken(
        code: widget.code,
        state: widget.state,
      );
      if (context.mounted) {
        closeDialog(context);
      }
      _getPersonData(res);
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

  _getPersonData(String token) async {
    setState(() {
      bToken = token;
    });
    try {
      showLoadingDialog(context);
      personData = await MyInfoController(
        networkHelper: networkHelper,
      ).getPersonData(
        code: widget.code,
        token: token,
      );
      setState(() {});
      if (context.mounted) {
        closeDialog(context);
      }
      _decryptData();
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

  _decryptData() async {
    try {
      showLoadingDialog(context);
      decryptedPersonData = await MyInfoController(
        networkHelper: networkHelper,
      ).decryptData(
        personData,
      );
      setState(() {});
      if (context.mounted) {
        closeDialog(context);
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
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
              height: 15,
            ),
            if (widget.error.isNotEmpty && widget.errorDesc.isNotEmpty)
              Text(
                "Error Code: ${widget.error}, Desc: ${widget.errorDesc}",
              ),
            const SizedBox(
              height: 15,
            ),
            if (decryptedPersonData.isNotEmpty)
              Text(
                "Person Data Decrypted: $decryptedPersonData",
              ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
