import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_submission_1/page/detail_story_screen.dart';
import 'package:story_submission_1/page/login_screen.dart';
import 'package:story_submission_1/page/story_list_screen.dart';
import '../page/register_screen.dart';
import '../page/splash_screen.dart';
import 'error_page.dart';
import 'extras.dart';
import 'key.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

enum Routes {
  splash,
  home,
  login,
  register,
  detailStory,
  addStory
}

final goRouter = GoRouter(
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: '/splash',
    errorPageBuilder: (context, state) => _navigate(
      context,
      state,
      ErrorPage(
        error: state.error,
      ),
    ),
    routes: [
      GoRoute(
        path: '/splash',
        parentNavigatorKey: _rootNavigatorKey,
        name: Routes.splash.name,
        pageBuilder: (context, state) =>
            _navigate(context, state, const SplashScreen()),
      ),

      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        name: Routes.login.name,
        pageBuilder: (context, state) =>
            _navigate(context, state, const LoginScreen()),
      ),

      GoRoute(
        path: '/register',
        parentNavigatorKey: _rootNavigatorKey,
        name: Routes.register.name,
        pageBuilder: (context, state) =>
            _navigate(context, state, const RegisterScreen()),
      ),
      // ShellRoute for bottom navigation pages (Home, Favorite, Setting)

      GoRoute(
          path: '/home',
          parentNavigatorKey: _rootNavigatorKey,
          name: Routes.home.name,
          pageBuilder: (context, state) =>
              _navigate(context, state, const StoryListScreen()),
          routes: [
            GoRoute(
              path: 'detailStory',
              parentNavigatorKey: _rootNavigatorKey,
              name: Routes.detailStory.name,
              pageBuilder: (context, state) {
                final extras = (state.extra as Extras).extras;
                final storyId = extras[Keys.storyId] as String;
                return _navigate(
                  context,
                  state,
                  DetailStoryScreen(
                    storyId: storyId, isBackButtonShow: true
                  )
                );
              },
            ),
          ]
      ),
    ]
);

// Helper function to navigate
Page<void> _navigate(BuildContext context, GoRouterState state, Widget screen) {
  return MaterialPage<void>(
    key: state.pageKey,
    restorationId: state.pageKey.value,
    child: screen,
  );
}
