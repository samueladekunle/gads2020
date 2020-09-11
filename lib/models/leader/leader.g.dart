// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leader.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Leader _$LeaderFromJson(Map<String, dynamic> json) {
  return Leader(
    name: json['name'] as String,
    hours: json['hours'] as int,
    score: json['score'] as int,
    country: json['country'] as String,
    badgeUrl: json['badgeUrl'] as String,
  );
}

Map<String, dynamic> _$LeaderToJson(Leader instance) => <String, dynamic>{
      'name': instance.name,
      'hours': instance.hours,
      'score': instance.score,
      'country': instance.country,
      'badgeUrl': instance.badgeUrl,
    };
