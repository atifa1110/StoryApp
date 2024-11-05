import '../model/story.dart';

class StoriesResponse{
  bool? error;
  String? message;
  List<Story>? listStory;

  StoriesResponse({this.error, this.message, this.listStory});

  StoriesResponse.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    if (json['listStory'] != null) {
      listStory = <Story>[];
      json['listStory'].forEach((v) {
        listStory!.add(Story.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    if (listStory != null) {
      data['listStory'] = listStory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}