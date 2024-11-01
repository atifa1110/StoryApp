import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_submission_1/data/model/story.dart';
import 'package:story_submission_1/data/preferences/preferences_helper.dart';

import '../data/api/api_service.dart';
import '../data/enum/state.dart';

class StoryListProvider extends ChangeNotifier {
  final ApiService apiService;
  final PreferencesHelper preferencesHelper;

  StoryListProvider(this.apiService, this.preferencesHelper){
    _getStories();
  }

  final ScrollController _scrollController = ScrollController();
  final int _currentSize = 10;
  int _currentPage = 1;
  bool _hasReachedMax = false;
  bool _isScrollLoading = false;

  ResultState? _state;
  ResultState? get state => _state;

  String _message = "";
  String get message => _message;

  final List<StoryResult> _stories = [];
  List<StoryResult> get stories => _stories;
  ScrollController get scrollController => _scrollController;
  bool get isScrollLoading => _isScrollLoading;

  Future<dynamic> _getStories() async {
    String token = await preferencesHelper.getToken;
    if (_stories.isEmpty) {
      _state = ResultState.loading;
    } else {
      _isScrollLoading = true;
    }

    try {
      _state = ResultState.loading;
      notifyListeners();

      final storiesResult = await apiService.getStories(token);

      if (storiesResult.listStory?.isNotEmpty == true) {
        _state = ResultState.hasData;
        _stories.clear();
        _stories.addAll(storiesResult.listStory ?? List.empty());
        _message = storiesResult.message ?? "Get Stories Success!";
      } else {
        if (_stories.isEmpty) {
          _state = ResultState.noData;
          _message = storiesResult.message ?? "Get Stories Failed";
        } else {
          _state = ResultState.hasData;
          _hasReachedMax = true;
        }
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

  Future<void> refreshData() async {
    _stories.clear();
    _currentPage = 1;
    _hasReachedMax = false;
    await _getStories();
  }

  void _setControllerListener() {
    _scrollController.addListener(() {
      if (_scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        if (!_hasReachedMax) {
          _currentPage++;
          _getStories();
        }
      }
    });
  }
}