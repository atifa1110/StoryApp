import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_submission_2/data/preferences/preferences_helper.dart';
import 'package:story_submission_2/provider/add_location_provider.dart';
import 'package:story_submission_2/provider/login_provider.dart';
import 'package:story_submission_2/provider/register_provider.dart';
import 'package:story_submission_2/provider/splash_provider.dart';
import 'package:story_submission_2/provider/story_detail_provider.dart';
import 'package:story_submission_2/provider/story_list_provider.dart';
import 'package:story_submission_2/routing/app_routes.dart';

import 'data/api/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StoryListProvider>(
            create: (context) => StoryListProvider(ApiService(),
                PreferencesHelper(SharedPreferences.getInstance())
            )
        ),
        ChangeNotifierProvider<AddLocationProvider>(
            create: (context) => AddLocationProvider()
        ),
        ChangeNotifierProvider<LoginProvider>(
            create: (context) => LoginProvider(
                ApiService(), PreferencesHelper(SharedPreferences.getInstance())
            )
        ),
        ChangeNotifierProvider<RegisterProvider>(
            create: (context) => RegisterProvider(ApiService())
        ),
        ChangeNotifierProvider<SplashProvider>(
            create: (context) => SplashProvider(preferencesHelper: PreferencesHelper(SharedPreferences.getInstance()), context: context)
        ),
      ],
      child: MaterialApp.router(
        title: 'Story',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        routeInformationParser: goRouter.routeInformationParser,
        routeInformationProvider: goRouter.routeInformationProvider,
        routerDelegate: goRouter.routerDelegate,
      ),
    );
  }
}

