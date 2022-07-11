import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:jobsity_challenge/data/models/poster.dart';

part 'person.freezed.dart';
part 'person.g.dart';

@freezed
class Person with _$Person {
  const factory Person({
    required int id,
    required String name,
    Poster? image,
  }) = _Person;

  factory Person.fromJson(Map<String, Object?> json) => _$PersonFromJson(json);
}
