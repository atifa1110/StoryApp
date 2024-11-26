import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_submission_2/data/preferences/preferences_helper.dart';

import '../common/app_theme.dart';
import '../provider/splash_provider.dart';

class SplashScreen extends StatelessWidget {

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider<SplashProvider>(
        create: (ctx) => SplashProvider(preferencesHelper: PreferencesHelper(SharedPreferences.getInstance()),
            context: context),
        child: Consumer<SplashProvider>(
          builder: (context, value, child) {
            return Center(
              child: Text(
                "Story App",
                style: AppThemes.headline2,
              ),
            );
          },
        ),
      ),
    );
  }
}