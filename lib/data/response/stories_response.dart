import '../model/story.dart';
import 'package:json_annotation/json_annotation.dart';
part 'stories_response.g.dart';

@JsonSerializable()
class StoriesResponse{
  bool? error;
  String? message;
  List<Story>? listStory;

  StoriesResponse({this.error, this.message, this.listStory});

  factory StoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$StoriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StoriesResponseToJson(this);
}