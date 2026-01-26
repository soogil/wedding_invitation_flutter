// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'guest_book_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GuestBookModel {
  String get id;
  String get name;
  String get message;
  @TimestampConverter()
  DateTime get createdAt;

  /// Create a copy of GuestBookModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GuestBookModelCopyWith<GuestBookModel> get copyWith =>
      _$GuestBookModelCopyWithImpl<GuestBookModel>(
          this as GuestBookModel, _$identity);

  /// Serializes this GuestBookModel to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GuestBookModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, message, createdAt);

  @override
  String toString() {
    return 'GuestBookModel(id: $id, name: $name, message: $message, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $GuestBookModelCopyWith<$Res> {
  factory $GuestBookModelCopyWith(
          GuestBookModel value, $Res Function(GuestBookModel) _then) =
      _$GuestBookModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String message,
      @TimestampConverter() DateTime createdAt});
}

/// @nodoc
class _$GuestBookModelCopyWithImpl<$Res>
    implements $GuestBookModelCopyWith<$Res> {
  _$GuestBookModelCopyWithImpl(this._self, this._then);

  final GuestBookModel _self;
  final $Res Function(GuestBookModel) _then;

  /// Create a copy of GuestBookModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? message = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _GuestBookModel implements GuestBookModel {
  const _GuestBookModel(
      {required this.id,
      required this.name,
      required this.message,
      @TimestampConverter() required this.createdAt});
  factory _GuestBookModel.fromJson(Map<String, dynamic> json) =>
      _$GuestBookModelFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String message;
  @override
  @TimestampConverter()
  final DateTime createdAt;

  /// Create a copy of GuestBookModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GuestBookModelCopyWith<_GuestBookModel> get copyWith =>
      __$GuestBookModelCopyWithImpl<_GuestBookModel>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GuestBookModelToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GuestBookModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, message, createdAt);

  @override
  String toString() {
    return 'GuestBookModel(id: $id, name: $name, message: $message, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$GuestBookModelCopyWith<$Res>
    implements $GuestBookModelCopyWith<$Res> {
  factory _$GuestBookModelCopyWith(
          _GuestBookModel value, $Res Function(_GuestBookModel) _then) =
      __$GuestBookModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String message,
      @TimestampConverter() DateTime createdAt});
}

/// @nodoc
class __$GuestBookModelCopyWithImpl<$Res>
    implements _$GuestBookModelCopyWith<$Res> {
  __$GuestBookModelCopyWithImpl(this._self, this._then);

  final _GuestBookModel _self;
  final $Res Function(_GuestBookModel) _then;

  /// Create a copy of GuestBookModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? message = null,
    Object? createdAt = null,
  }) {
    return _then(_GuestBookModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
