import 'package:json_annotation/json_annotation.dart';

part 'login.g.dart';

@JsonSerializable()
class Login {
  String? userId;
  String? name;
  String? token;

  Login({this.userId, this.name, this.token});

  // Login.fromJson(Map<String, dynamic> json) {
  //   userId = json['userId'];
  //   name = json['name'];
  //   token = json['token'];
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = <String, dynamic>{};
  //   data['userId'] = userId;
  //   data['name'] = name;
  //   data['token'] = token;
  //   return data;
  // }

  factory Login.fromJson(Map<String, dynamic> json) => _$LoginFromJson(json);

  Map<String, dynamic> toJson() => _$LoginToJson(this);
}