import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_submission_1/common/app_theme.dart';
import 'package:story_submission_1/data/preferences/preferences_helper.dart';
import 'package:story_submission_1/page/login_screen.dart';
import 'package:story_submission_1/provider/story_list_provider.dart';
import 'package:story_submission_1/routing/app_routes.dart';

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
      create: (context) => StoryListProvider(ApiService(), PreferencesHelper(SharedPreferences.getInstance())),
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
          builder: (context, value, child) {
            if (value.state == ResultState.loading) {
              return const Padding(
                padding: EdgeInsets.only(top: 20),
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (value.state == ResultState.hasData) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Stack(
                  children: [
                    ListView.separated(
                      controller: value.scrollController,
                      separatorBuilder: (context, index) =>
                      const SizedBox(height: 30),
                      itemCount: value.stories.length,
                      itemBuilder: (context, index) {
                        final data = value.stories[index];
                        return Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(10.0),
                          shadowColor: Colors.black12,
                          child: Ink(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                context.pushNamed(
                                  Routes.detailStory.name,
                                  extra: Extras(
                                    extras: {
                                      Keys.storyId: data.id,
                                    },
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10.0),
                                      topRight: Radius.circular(10.0),
                                    ),
                                    child: Image.network(
                                      data.photoUrl??"",
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width,
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.2,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }

                                        return Image.asset(
                                          "assets/images/placeholder.png",
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Center(
                                          child: Icon(Icons.error),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data.name??"",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge,
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          data.description??"",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    if (value.isScrollLoading)
                      const Align(
                        alignment: Alignment.bottomCenter,
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              );
            } else if (value.state == ResultState.noData) {
              return LottieWidget(
                assets: Resources.lottieEmpty,
                description: 'No Result',
                subtitle: value.message,
              );
            } else if (value.state == ResultState.error) {
              return LottieWidget(
                assets: Resources.lottieEmpty,
                description: 'No Result',
                subtitle: value.message,
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