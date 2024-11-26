import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_submission_2/data/model/story.dart';
import 'package:story_submission_2/data/preferences/preferences_helper.dart';
import 'package:story_submission_2/page/login_screen.dart';

import '../data/api/api_service.dart';
import '../data/enum/state.dart';
import '../routing/app_routes.dart';

class StoryListProvider extends ChangeNotifier {
  final ApiService apiService;
  final PreferencesHelper preferencesHelper;

  StoryListProvider(this.apiService, this.preferencesHelper){
    _getStories();
  }

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 1;
  final int _itemsPerPage = 10;
  bool _hasReachedMax = false;
  bool _isScrollLoading = false;

  ResultState? _state;
  ResultState? get state => _state;

  String _message = "";
  String get message => _message;

  final List<Story> _stories = [];
  List<Story> get stories => _stories;
  ScrollController get scrollController => _scrollController;
  bool get isScrollLoading => _isScrollLoading;

  Future<void> logout(BuildContext context) async {
    // Set the token to an empty string and isLogin to false
    preferencesHelper.setToken("");
    preferencesHelper.setLogin(false);

    // Check the login status after updating preferences
    bool res = await preferencesHelper.isLogin;

    if (!res) { // If isLogin is false, logout was successful
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logout Success")),
        );
        // Navigate to the login screen and clear the navigation stack
        context.goNamed(Routes.login.name);
      }
    } else { // If isLogin is true, logout failed
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Logout Failed")),
        );
      }
    }
  }

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
        if (_currentPage == 1) {
          _stories.clear();
        }
        _state = ResultState.hasData;
        _stories.addAll(storiesResult.listStory ?? List.empty());
        _message = storiesResult.message ?? "Get Stories Success!";
        if (storiesResult.listStory!.length < _itemsPerPage) {
          _hasReachedMax = true;
        }
      } else {
        if (_currentPage == 1) {
          _state = ResultState.noData;
          _message = storiesResult.message ?? "Get Stories Failed";
        } else {
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

  void setControllerListener() {
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