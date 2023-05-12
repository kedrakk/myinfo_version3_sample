import 'package:go_router/go_router.dart';
import 'package:myinfo_v3_sample_webapp/page/callback.dart';
import 'package:myinfo_v3_sample_webapp/page/home.dart';

import '../page/error.dart';

mixin Routes {
  static String home = "/";
  static String callback = "/callback";
}

class RouteHelper {
  GoRouter goRouter() {
    return GoRouter(
      routes: [
        GoRoute(
          path: Routes.home,
          name: Routes.home,
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: Routes.callback,
          name: Routes.callback,
          builder: (context, state) {
            String code = state.queryParameters['code'] ?? "";
            String stateData = state.queryParameters['state'] ?? "";
            String error = state.queryParameters['error'] ?? "";
            String errorDesc = state.queryParameters['error_description'] ?? "";
            return CallBackPage(
              code: code,
              state: stateData,
              error: error,
              errorDesc: errorDesc,
            );
          },
        ),
      ],
      errorBuilder: (context, state) {
        return const ErrorPage();
      },
    );
  }
}
