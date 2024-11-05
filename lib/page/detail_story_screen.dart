import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_submission_1/component/lottie_widget.dart';
import 'package:story_submission_1/data/preferences/preferences_helper.dart';

import '../data/api/api_service.dart';
import '../data/enum/state.dart';
import '../provider/story_detail_provider.dart';
import '../theme/resources.dart';

class DetailStoryScreen extends StatefulWidget {
  static const routeName = '/detailStory';

  final String storyId;
  final bool isBackButtonShow;

  const DetailStoryScreen({super.key, required this.isBackButtonShow, required this.storyId});

  @override
  State<DetailStoryScreen> createState() => _StoryDetailPageState();

}

class _StoryDetailPageState extends State<DetailStoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Story")),
      body: SafeArea(
        child: ChangeNotifierProvider<DetailStoryProvider>(
          create: (context) => DetailStoryProvider(
              ApiService(), widget.storyId, PreferencesHelper(SharedPreferences.getInstance())
          ),
          builder: (context, child) => Consumer<DetailStoryProvider>(
            builder: (context, provider, _) {
              switch (provider.state) {
                case ResultState.loading:
                  return const Center(child: CircularProgressIndicator());
                case ResultState.hasData:
                  var story = provider.story;
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 400,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(story.photoUrl??""),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          story.name??"",
                                          style: Theme.of(context).textTheme.headlineSmall,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              const SizedBox(height: 24),
                              Text(
                                'Description :',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                story.description??"",
                                textAlign: TextAlign.justify,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                case ResultState.error:
                  return LottieWidget(
                    assets: Resources.lottieEmpty,
                    description: 'No Result',
                    subtitle: provider.message,
                    onRefresh: (){
                      // Call the refresh method on RestaurantProvider
                      context.read<DetailStoryProvider>().refresh(widget.storyId);
                    },
                  );
                case ResultState.noData:
                  return LottieWidget(
                    assets: Resources.lottieEmpty,
                    description: 'No Result',
                    subtitle: provider.message,
                    onRefresh: (){
                      // Call the refresh method on RestaurantProvider
                      context.read<DetailStoryProvider>().refresh(widget.storyId);
                    },
                  );
                default:
                  return Container();
              }
            },
          ),
        ),
      ),
    );
  }
}

