import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_submission_1/data/preferences/preferences_helper.dart';
import 'package:story_submission_1/page/login_screen.dart';
import 'package:story_submission_1/page/register_screen.dart';
import 'package:story_submission_1/provider/story_detail_provider.dart';
import 'package:story_submission_1/provider/story_list_provider.dart';
import 'package:story_submission_1/routing/app_routes.dart';

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

