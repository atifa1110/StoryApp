import 'dart:io';

import 'package:flutter/material.dart';

import '../data/api/api_service.dart';
import '../data/enum/state.dart';
import '../data/request/register_request.dart';

class RegisterProvider extends ChangeNotifier {
  final ApiService apiService;

  RegisterProvider(this.apiService);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isHide = true;

  bool get isHide => _isHide;
  TextEditingController get nameController => _nameController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get emailController => _emailController;

  ResultState? _registerState;
  ResultState? get registerState => _registerState;

  String _registerMessage = "";
  String get registerMessage => _registerMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void onChangeObscure() {
    _isHide = !_isHide;
    notifyListeners();
  }

  Future<dynamic> register() async {
    final request = RegisterRequest(
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    try {
      _registerState = ResultState.loading;
      notifyListeners();
      final registerResult = await apiService.register(request);
      print(registerResult);
      if (registerResult.error != true) {
        _registerState = ResultState.hasData;
        _registerMessage = registerResult.message ?? "Account Created!";
      } else {
        _registerState = ResultState.noData;
        _registerMessage = registerResult.message ?? "Register Failed";
      }
    } on SocketException {
      _registerState = ResultState.error;
      return _registerMessage = "Error: No Internet Connection!";
    } catch (e) {
      _registerState = ResultState.error;
      _registerMessage = "Error: $e";
    } finally {
      notifyListeners();
    }
  }
}