import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jobsity_challenge/data/models/poster.dart';
import 'package:jobsity_challenge/data/models/schedule.dart';

part 'show.freezed.dart';
part 'show.g.dart';

@freezed
class Show with _$Show {
  const factory Show({
    required int id,
    required String url,
    required String name,
    required List<String> genres,
    required Schedule schedule,
    required Poster image,
    required String summary,
  }) = _Show;

  factory Show.fromJson(Map<String, Object?> json) => _$ShowFromJson(json);
}
