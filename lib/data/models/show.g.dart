// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'show.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Show _$$_ShowFromJson(Map<String, dynamic> json) => _$_Show(
      id: json['id'] as int,
      url: json['url'] as String,
      name: json['name'] as String,
      genres:
          (json['genres'] as List<dynamic>).map((e) => e as String).toList(),
      schedule: Schedule.fromJson(json['schedule'] as Map<String, dynamic>),
      summary: json['summary'] as String?,
      image: json['image'] == null
          ? null
          : Poster.fromJson(json['image'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_ShowToJson(_$_Show instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'name': instance.name,
      'genres': instance.genres,
      'schedule': instance.schedule,
      'summary': instance.summary,
      'image': instance.image,
    };
