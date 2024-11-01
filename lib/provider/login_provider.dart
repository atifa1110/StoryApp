import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_submission_1/data/preferences/preferences_helper.dart';
import 'package:story_submission_1/page/login_screen.dart';
import 'package:story_submission_1/routing/app_routes.dart';
import '../data/api/api_service.dart';
import '../data/enum/state.dart';

import '../data/request/login_request.dart';

class LoginProvider extends ChangeNotifier {
  final ApiService apiService;
  final PreferencesHelper preferencesHelper;

  LoginProvider(this.apiService, this.preferencesHelper);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isHide = true;

  bool get isHide => _isHide;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get emailController => _emailController;

  ResultState? _loginState;
  ResultState? get loginState => _loginState;

  String _loginMessage = "";
  String get loginMessage => _loginMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void onChangeObscure() {
    _isHide = !_isHide;
    notifyListeners();
  }

  Future<dynamic> login(BuildContext context) async {
    final request = LoginRequest(
      email: _emailController.text,
      password: _passwordController.text,
    );

    try {
      _loginState = ResultState.loading;
      notifyListeners();
      final loginResult = await apiService.login(request);
      if (loginResult.error != true) {
        _loginState = ResultState.hasData;
        preferencesHelper.setToken(loginResult.loginResult?.token ?? "");
        preferencesHelper.setLogin(true);
        _loginMessage = loginResult.message ?? "Login Success!";
        if (context.mounted) {
          context.pushNamed(Routes.home.name);
        }
      } else {
        _loginState = ResultState.noData;
        _loginMessage = loginResult.message ?? "Login Failed!";
      }
    } on SocketException {
      _loginState = ResultState.error;
      _loginMessage = "Error: No Internet Connection";
    } catch (e) {
      _loginState = ResultState.error;
      _loginMessage = "Error: $e";
    } finally {
      notifyListeners();
    }
  }
}