import '../model/story.dart';

class DetailStoryResponse {
  bool? error;
  String? message;
  Story? story;

  DetailStoryResponse({this.error, this.message, this.story});

  DetailStoryResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    story = json['story'] != null ? Story.fromJson(json['story']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    if (story != null) {
      data['story'] = story!.toJson();
    }
    return data;
  }
}

