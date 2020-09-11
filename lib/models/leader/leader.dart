import 'package:json_annotation/json_annotation.dart';

part 'leader.g.dart';

@JsonSerializable()
class Leader {
  final String name;
  final int hours;
  final int score;
  final String country;
  final String badgeUrl;

  Leader({
    this.name,
    this.hours,
    this.score,
    this.country,
    this.badgeUrl,
  });

  factory Leader.fromJson(Map<String, dynamic> json) => _$LeaderFromJson(json);

  Map<String, dynamic> toJson() => _$LeaderToJson(this);
}
