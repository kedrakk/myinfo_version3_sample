import 'package:flutter/material.dart';

import '../controller/myinfo_controller.dart';
import '../di/di_helper.dart';
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
      bToken = res;
      setState(() {});
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
            if (widget.state.isNotEmpty && widget.code.isNotEmpty)
              Text(
                "State: ${widget.state}, Code: ${widget.code}",
              ),
            const SizedBox(
              height: 15,
            ),
            if (bToken.isNotEmpty)
              Text(
                "Bearer Token: $bToken",
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
