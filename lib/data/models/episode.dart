import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jobsity_challenge/data/models/poster.dart';

part 'episode.freezed.dart';
part 'episode.g.dart';

@freezed
class Episode with _$Episode {
  const factory Episode({
    required int id,
    required String name,
    required int season,
    int? number,
    String? summary,
    Poster? image,
  }) = _Episode;

  factory Episode.fromJson(Map<String, Object?> json) =>
      _$EpisodeFromJson(json);
}
