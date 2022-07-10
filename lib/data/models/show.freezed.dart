// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'show.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Show _$ShowFromJson(Map<String, dynamic> json) {
  return _Show.fromJson(json);
}

/// @nodoc
mixin _$Show {
  int get id => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<String> get genres => throw _privateConstructorUsedError;
  Schedule get schedule => throw _privateConstructorUsedError;
  String? get summary => throw _privateConstructorUsedError;
  Poster? get image => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShowCopyWith<Show> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShowCopyWith<$Res> {
  factory $ShowCopyWith(Show value, $Res Function(Show) then) =
      _$ShowCopyWithImpl<$Res>;
  $Res call(
      {int id,
      String url,
      String name,
      List<String> genres,
      Schedule schedule,
      String? summary,
      Poster? image});

  $ScheduleCopyWith<$Res> get schedule;
  $PosterCopyWith<$Res>? get image;
}

/// @nodoc
class _$ShowCopyWithImpl<$Res> implements $ShowCopyWith<$Res> {
  _$ShowCopyWithImpl(this._value, this._then);

  final Show _value;
  // ignore: unused_field
  final $Res Function(Show) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? url = freezed,
    Object? name = freezed,
    Object? genres = freezed,
    Object? schedule = freezed,
    Object? summary = freezed,
    Object? image = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      genres: genres == freezed
          ? _value.genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>,
      schedule: schedule == freezed
          ? _value.schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as Schedule,
      summary: summary == freezed
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as Poster?,
    ));
  }

  @override
  $ScheduleCopyWith<$Res> get schedule {
    return $ScheduleCopyWith<$Res>(_value.schedule, (value) {
      return _then(_value.copyWith(schedule: value));
    });
  }

  @override
  $PosterCopyWith<$Res>? get image {
    if (_value.image == null) {
      return null;
    }

    return $PosterCopyWith<$Res>(_value.image!, (value) {
      return _then(_value.copyWith(image: value));
    });
  }
}

/// @nodoc
abstract class _$$_ShowCopyWith<$Res> implements $ShowCopyWith<$Res> {
  factory _$$_ShowCopyWith(_$_Show value, $Res Function(_$_Show) then) =
      __$$_ShowCopyWithImpl<$Res>;
  @override
  $Res call(
      {int id,
      String url,
      String name,
      List<String> genres,
      Schedule schedule,
      String? summary,
      Poster? image});

  @override
  $ScheduleCopyWith<$Res> get schedule;
  @override
  $PosterCopyWith<$Res>? get image;
}

/// @nodoc
class __$$_ShowCopyWithImpl<$Res> extends _$ShowCopyWithImpl<$Res>
    implements _$$_ShowCopyWith<$Res> {
  __$$_ShowCopyWithImpl(_$_Show _value, $Res Function(_$_Show) _then)
      : super(_value, (v) => _then(v as _$_Show));

  @override
  _$_Show get _value => super._value as _$_Show;

  @override
  $Res call({
    Object? id = freezed,
    Object? url = freezed,
    Object? name = freezed,
    Object? genres = freezed,
    Object? schedule = freezed,
    Object? summary = freezed,
    Object? image = freezed,
  }) {
    return _then(_$_Show(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      genres: genres == freezed
          ? _value._genres
          : genres // ignore: cast_nullable_to_non_nullable
              as List<String>,
      schedule: schedule == freezed
          ? _value.schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as Schedule,
      summary: summary == freezed
          ? _value.summary
          : summary // ignore: cast_nullable_to_non_nullable
              as String?,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as Poster?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Show implements _Show {
  const _$_Show(
      {required this.id,
      required this.url,
      required this.name,
      required final List<String> genres,
      required this.schedule,
      required this.summary,
      this.image})
      : _genres = genres;

  factory _$_Show.fromJson(Map<String, dynamic> json) => _$$_ShowFromJson(json);

  @override
  final int id;
  @override
  final String url;
  @override
  final String name;
  final List<String> _genres;
  @override
  List<String> get genres {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genres);
  }

  @override
  final Schedule schedule;
  @override
  final String? summary;
  @override
  final Poster? image;

  @override
  String toString() {
    return 'Show(id: $id, url: $url, name: $name, genres: $genres, schedule: $schedule, summary: $summary, image: $image)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Show &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.url, url) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other._genres, _genres) &&
            const DeepCollectionEquality().equals(other.schedule, schedule) &&
            const DeepCollectionEquality().equals(other.summary, summary) &&
            const DeepCollectionEquality().equals(other.image, image));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(url),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(_genres),
      const DeepCollectionEquality().hash(schedule),
      const DeepCollectionEquality().hash(summary),
      const DeepCollectionEquality().hash(image));

  @JsonKey(ignore: true)
  @override
  _$$_ShowCopyWith<_$_Show> get copyWith =>
      __$$_ShowCopyWithImpl<_$_Show>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_ShowToJson(this);
  }
}

abstract class _Show implements Show {
  const factory _Show(
      {required final int id,
      required final String url,
      required final String name,
      required final List<String> genres,
      required final Schedule schedule,
      required final String? summary,
      final Poster? image}) = _$_Show;

  factory _Show.fromJson(Map<String, dynamic> json) = _$_Show.fromJson;

  @override
  int get id;
  @override
  String get url;
  @override
  String get name;
  @override
  List<String> get genres;
  @override
  Schedule get schedule;
  @override
  String? get summary;
  @override
  Poster? get image;
  @override
  @JsonKey(ignore: true)
  _$$_ShowCopyWith<_$_Show> get copyWith => throw _privateConstructorUsedError;
}
