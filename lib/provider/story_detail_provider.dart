import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_submission_1/data/model/story.dart';
import 'package:story_submission_1/data/preferences/preferences_helper.dart';

import '../data/api/api_service.dart';
import '../data/enum/state.dart';

class DetailStoryProvider extends ChangeNotifier {
  final ApiService apiService;
  final PreferencesHelper preferencesHelper;
  final String id;

  DetailStoryProvider(this.apiService, this.id, this.preferencesHelper) {
    getDetailStory(id);
  }

  ResultState? _state;
  ResultState? get state => _state;

  StoryResult _story = StoryResult();
  StoryResult get story => _story;

  String _message = "";
  String get message => _message;

  Future<dynamic> getDetailStory(String id) async {
    String token = await preferencesHelper.getToken;
    try {
      _state = ResultState.loading;
      notifyListeners();
      final detailStoryResult = await apiService.getDetailStory(id, token);
      if (detailStoryResult.story != null) {
        _state = ResultState.hasData;
        _story = detailStoryResult.story ?? StoryResult();
        _message = detailStoryResult.message ?? "Get Detail Story Success!";
      } else {
        _state = ResultState.noData;
        _message = detailStoryResult.message ?? "Get Detail Story Failed!";
      }
    } on SocketException {
      _state = ResultState.error;
      _message = "Error: No Internet Connection";
    } catch (e) {
      _state = ResultState.error;
      _message = "Error: $e";
    } finally {
      notifyListeners();
    }
  }
}