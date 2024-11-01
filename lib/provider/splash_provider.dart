import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:story_submission_1/data/preferences/preferences_helper.dart';

import '../routing/app_routes.dart';

class SplashProvider extends ChangeNotifier {
  final PreferencesHelper preferencesHelper;
  final BuildContext context;

  SplashProvider({
    required this.preferencesHelper,
    required this.context,
  }) {
    _checkIsLogin();
  }

  Future<void> _checkIsLogin() async {
    final res = await preferencesHelper.isLogin;

    if (res) {
      if (context.mounted) {
        await Future.delayed(const Duration(seconds: 2), () {
          context.pushNamed(
            Routes.home.name,
          );
        });
      }
    } else {
      if (context.mounted) {
        await Future.delayed(const Duration(seconds: 2), () {
          //context.go("/login");
          context.pushNamed(
            Routes.login.name,
          );
        });
      }
    }
  }
}