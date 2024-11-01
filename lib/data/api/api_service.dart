import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:story_submission_1/data/preferences/preferences_helper.dart';
import '../request/add_story_request.dart';
import '../request/login_request.dart';
import '../request/register_request.dart';
import '../response/base_response.dart';
import '../response/detail_response.dart';
import '../response/login_response.dart';
import '../response/stories_response.dart';

class ApiService {
  static const String _baseUrl = "https://story-api.dicoding.dev/v1";
  static const Duration timeout = Duration(seconds: 5);
  static final Uri _loginEndpoint = Uri.parse("$_baseUrl/login");
  static final Uri _registerEndpoint = Uri.parse("$_baseUrl/register");
  static final Uri _storiesEndpoint = Uri.parse("$_baseUrl/stories");
  Uri _detailStoryEndpoint(String id) => Uri.parse("$_baseUrl/stories/$id");

  Future<LoginResponse> login(LoginRequest request) async {
    final response = await http.post(
      _loginEndpoint,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(
        request.toJson(),
      ),
    ).timeout(timeout);

    switch (response.statusCode) {
      case 200:
        return LoginResponse.fromJson(json.decode(response.body));
      case 400:
        throw Exception('Bad Request: The server could not understand the request.');
      case 404:
        throw Exception('Not Found: login with the given ID was not found.');
      case 500:
        throw Exception('Internal Server Error: Something went wrong on the server.');
      default:
        throw Exception('Failed to login');
    }
  }

  Future<BaseResponse> register(RegisterRequest request) async {
    final response = await http.post(
      _registerEndpoint,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode(
        request.toJson(),
      ),
    ).timeout(timeout);

    switch (response.statusCode) {
      case 201:
        return BaseResponse.fromJson(json.decode(response.body));
      case 400:
        throw Exception('Bad Request: The server could not understand the request.');
      case 404:
        throw Exception('Not Found: register with the given ID was not found.');
      case 500:
        throw Exception('Internal Server Error: Something went wrong on the server.');
      default:
        throw Exception('Failed to register');
    }
  }

  Future<StoriesResponse> getStories(String token) async {
    // var tokenPref = Token();
    // var token = await tokenPref.getToken();

    final response = await http.get(
        _storiesEndpoint,
        headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
        }
    ).timeout(timeout);

   switch (response.statusCode) {
      case 200:
        return StoriesResponse.fromJson(json.decode(response.body));
      case 400:
        throw Exception('Bad Request: The server could not understand the request.');
      case 404:
        throw Exception('Not Found: stories with the given ID was not found.');
      case 500:
        throw Exception('Internal Server Error: Something went wrong on the server.');
      default:
        throw Exception('Failed to login');
    }
  }

  Future<DetailStoryResponse> getDetailStory(String id, String token) async {
    // var tokenPref = Token();
    // var token = await tokenPref.getToken();

    final response = await http.get(_detailStoryEndpoint(id), headers: {
      'Authorization': 'Bearer $token',
    }).timeout(timeout);

    var detailStory = DetailStoryResponse.fromJson(json.decode(response.body));

    switch (response.statusCode) {
      case 200:
        return detailStory;
      case 400:
        throw Exception('Bad Request: The server could not understand the request.');
      case 404:
        throw Exception('Not Found: detail with the given ID was not found.');
      case 500:
        throw Exception('Internal Server Error: Something went wrong on the server.');
      default:
        throw Exception('Failed to load detail data');
    }
  }

  Future<BaseResponse> addStory(AddStoryRequest story, String token) async {

    final request = http.MultipartRequest('POST', _storiesEndpoint);
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['description'] = story.description;
    request.files.add(http.MultipartFile(
      'photo',
      story.photo.readAsBytes().asStream(),
      story.photo.lengthSync(),
      filename: story.photo.path.split('/').last,
    ));
    if (story.lat != null) {
      request.fields['lat'] = story.lat.toString();
      request.fields['lon'] = story.lon.toString();
    }

    final response = await request.send().timeout(timeout);

    if (_isResponseSuccess(response.statusCode)) {
      String responseBody = await response.stream.bytesToString();
      return BaseResponse.fromJson(json.decode(responseBody));
    } else {
      throw Exception("${response.statusCode} - Error when upload story");
    }
  }

  _isResponseSuccess(int statusCode) => (statusCode >= 200 && statusCode < 300);
}