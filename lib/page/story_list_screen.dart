import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_submission_2/common/app_theme.dart';
import 'package:story_submission_2/component/list_card.dart';
import 'package:story_submission_2/data/preferences/preferences_helper.dart';
import 'package:story_submission_2/page/login_screen.dart';
import 'package:story_submission_2/provider/story_list_provider.dart';
import 'package:story_submission_2/routing/app_routes.dart';

import '../component/lottie_widget.dart';
import '../data/api/api_service.dart';
import '../data/enum/state.dart';
import '../routing/extras.dart';
import '../routing/key.dart';
import '../theme/resources.dart';

class StoryListScreen extends StatelessWidget {

  const StoryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<StoryListProvider>(
      create: (context) => StoryListProvider(ApiService(),
          PreferencesHelper(SharedPreferences.getInstance())
      )..setControllerListener(),
      child: Scaffold(
        backgroundColor: AppThemes.white,
        appBar: AppBar(
          backgroundColor: AppThemes.white,
          automaticallyImplyLeading: false,
          title: const Text("Story App"),
          actions: [
            Consumer<StoryListProvider>(
                builder: (context, provider, child) {
                  return PopupMenuButton<String>(
                    onSelected: (value) {
                      // Handle menu selection
                      if (value == 'Profile') {
                        // Navigate to profile page or perform action
                      } else if (value == 'Settings') {
                        // Navigate to settings page or perform action
                      } else if (value == 'Logout') {
                        provider.logout(context);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return {'Profile', 'Settings', 'Logout'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      }).toList();
                    },
                  );
                }
            )
          ],
        ),
        floatingActionButton: Consumer<StoryListProvider>(
          builder: (context, value, child) {
            return FloatingActionButton(
              onPressed: () async {
                await context.pushNamed(Routes.addStory.name);
                value.refreshData();
              },
              child: const Icon(
                Icons.add,
              ),
            );
          },
        ),
        body: Consumer<StoryListProvider>(
          builder: (context, provider, child) {
            if (provider.state == ResultState.loading) {
              return const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (provider.state == ResultState.hasData) {
              return RefreshIndicator(
                onRefresh: () async {
                  await provider.refreshData();
                },
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Stack(
                    children: [
                      ListView.builder(
                        controller: provider.scrollController,
                        itemCount: provider.stories.length +
                            (provider.isScrollLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index < provider.stories.length) {
                            final story = provider.stories[index];
                            return ListCard(data: story);
                          } else if (provider.isScrollLoading) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      if (provider.isScrollLoading)
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: CircularProgressIndicator(),
                        ),
                    ],
                  ),
                ),
              );
            } else if (provider.state == ResultState.noData) {
              return LottieWidget(
                assets: Resources.lottieEmpty,
                description: 'No Result',
                subtitle: provider.message,
              );
            } else if (provider.state == ResultState.error) {
              return LottieWidget(
                assets: Resources.lottieEmpty,
                description: 'No Result',
                subtitle: provider.message,
              );
            } else {
              return const Center(
                child: Material(
                  child: Text('Unexpected Error'),
                ),
              );
            }
          }
        ),
      ),
    );
  }
}