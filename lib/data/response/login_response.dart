import '../model/login.dart';

class LoginResponse {
  bool? error;
  String? message;
  Login? loginResult;

  LoginResponse({this.error, this.message, this.loginResult});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    loginResult = json['loginResult'] != null
        ? Login.fromJson(json['loginResult'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    if (loginResult != null) {
      data['loginResult'] = loginResult!.toJson();
    }
    return data;
  }
}
