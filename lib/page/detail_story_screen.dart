import 'package:flutter/material.dart';

class DetailStoryScreen extends StatefulWidget {
  static const routeName = '/detailStory';

  final String? storyId;
  final bool isBackButtonShow;

  const DetailStoryScreen({super.key, this.storyId, required this.isBackButtonShow});

  @override
  State<DetailStoryScreen> createState() => _StoryDetailPageState();

}

class _StoryDetailPageState extends State<DetailStoryScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}

