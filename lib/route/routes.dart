import 'package:go_router/go_router.dart';
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
      ],
      errorBuilder: (context, state) {
        return const ErrorPage();
      },
    );
  }
}
