import 'package:freezed_annotation/freezed_annotation.dart';

part 'poster.freezed.dart';
part 'poster.g.dart';

@freezed
class Poster with _$Poster {
  const factory Poster({
    String? medium,
    String? original,
  }) = _Poster;

  factory Poster.fromJson(Map<String, Object?> json) => _$PosterFromJson(json);
}
