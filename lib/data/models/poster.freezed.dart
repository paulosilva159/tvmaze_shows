// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'poster.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Poster _$PosterFromJson(Map<String, dynamic> json) {
  return _Poster.fromJson(json);
}

/// @nodoc
mixin _$Poster {
  String? get medium => throw _privateConstructorUsedError;
  String? get original => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PosterCopyWith<Poster> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PosterCopyWith<$Res> {
  factory $PosterCopyWith(Poster value, $Res Function(Poster) then) =
      _$PosterCopyWithImpl<$Res>;
  $Res call({String? medium, String? original});
}

/// @nodoc
class _$PosterCopyWithImpl<$Res> implements $PosterCopyWith<$Res> {
  _$PosterCopyWithImpl(this._value, this._then);

  final Poster _value;
  // ignore: unused_field
  final $Res Function(Poster) _then;

  @override
  $Res call({
    Object? medium = freezed,
    Object? original = freezed,
  }) {
    return _then(_value.copyWith(
      medium: medium == freezed
          ? _value.medium
          : medium // ignore: cast_nullable_to_non_nullable
              as String?,
      original: original == freezed
          ? _value.original
          : original // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_PosterCopyWith<$Res> implements $PosterCopyWith<$Res> {
  factory _$$_PosterCopyWith(_$_Poster value, $Res Function(_$_Poster) then) =
      __$$_PosterCopyWithImpl<$Res>;
  @override
  $Res call({String? medium, String? original});
}

/// @nodoc
class __$$_PosterCopyWithImpl<$Res> extends _$PosterCopyWithImpl<$Res>
    implements _$$_PosterCopyWith<$Res> {
  __$$_PosterCopyWithImpl(_$_Poster _value, $Res Function(_$_Poster) _then)
      : super(_value, (v) => _then(v as _$_Poster));

  @override
  _$_Poster get _value => super._value as _$_Poster;

  @override
  $Res call({
    Object? medium = freezed,
    Object? original = freezed,
  }) {
    return _then(_$_Poster(
      medium: medium == freezed
          ? _value.medium
          : medium // ignore: cast_nullable_to_non_nullable
              as String?,
      original: original == freezed
          ? _value.original
          : original // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Poster implements _Poster {
  const _$_Poster({this.medium, this.original});

  factory _$_Poster.fromJson(Map<String, dynamic> json) =>
      _$$_PosterFromJson(json);

  @override
  final String? medium;
  @override
  final String? original;

  @override
  String toString() {
    return 'Poster(medium: $medium, original: $original)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Poster &&
            const DeepCollectionEquality().equals(other.medium, medium) &&
            const DeepCollectionEquality().equals(other.original, original));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(medium),
      const DeepCollectionEquality().hash(original));

  @JsonKey(ignore: true)
  @override
  _$$_PosterCopyWith<_$_Poster> get copyWith =>
      __$$_PosterCopyWithImpl<_$_Poster>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PosterToJson(this);
  }
}

abstract class _Poster implements Poster {
  const factory _Poster({final String? medium, final String? original}) =
      _$_Poster;

  factory _Poster.fromJson(Map<String, dynamic> json) = _$_Poster.fromJson;

  @override
  String? get medium;
  @override
  String? get original;
  @override
  @JsonKey(ignore: true)
  _$$_PosterCopyWith<_$_Poster> get copyWith =>
      throw _privateConstructorUsedError;
}
