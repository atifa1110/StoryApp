import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_submission_1/data/preferences/preferences_helper.dart';

import '../data/api/api_service.dart';
import '../data/enum/state.dart';
import '../data/request/add_story_request.dart';

class AddStoryProvider extends ChangeNotifier {
  final ApiService apiService;
  final PreferencesHelper preferencesHelper;

  AddStoryProvider(this.apiService, this.preferencesHelper);

  ResultState? _state;
  ResultState? get state => _state;

  String _message = "";
  String get message => _message;

  Future<dynamic> addStory(AddStoryRequest story) async {
    String token = await preferencesHelper.getToken;
    try {
      _state = ResultState.loading;
      notifyListeners();

      final detailStoryResult = await apiService.addStory(story, token);

      if (detailStoryResult.error == true) {
        _state = ResultState.error;

        _message = detailStoryResult.message ?? "Error when uploading!";
      } else {
        _state = ResultState.hasData;

        _message = detailStoryResult.message ?? "Success upload story!";
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