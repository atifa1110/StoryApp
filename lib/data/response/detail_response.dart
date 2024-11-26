import '../model/story.dart';
import 'package:json_annotation/json_annotation.dart';
part 'detail_response.g.dart';

@JsonSerializable()
class DetailStoryResponse {
  bool? error;
  String? message;
  Story? story;

  DetailStoryResponse({this.error, this.message, this.story});

  factory DetailStoryResponse.fromJson(Map<String, dynamic> json) =>
      _$DetailStoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DetailStoryResponseToJson(this);
}

