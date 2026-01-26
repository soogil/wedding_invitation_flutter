// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wedding_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WeddingState {
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is WeddingState);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'WeddingState()';
  }
}

/// @nodoc
class $WeddingStateCopyWith<$Res> {
  $WeddingStateCopyWith(WeddingState _, $Res Function(WeddingState) __);
}

/// @nodoc

class WeddingInitial implements WeddingState {
  const WeddingInitial();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is WeddingInitial);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'WeddingState.initial()';
  }
}

/// @nodoc

class WeddingLoading implements WeddingState {
  const WeddingLoading();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is WeddingLoading);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  String toString() {
    return 'WeddingState.loading()';
  }
}

/// @nodoc

class WeddingLoaded implements WeddingState {
  const WeddingLoaded(
      {final List<GuestBook> guestBooks = const [],
      this.isSubmittingGuestBook = false})
      : _guestBooks = guestBooks;

  final List<GuestBook> _guestBooks;
  @JsonKey()
  List<GuestBook> get guestBooks {
    if (_guestBooks is EqualUnmodifiableListView) return _guestBooks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_guestBooks);
  }

  @JsonKey()
  final bool isSubmittingGuestBook;

  /// Create a copy of WeddingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WeddingLoadedCopyWith<WeddingLoaded> get copyWith =>
      _$WeddingLoadedCopyWithImpl<WeddingLoaded>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WeddingLoaded &&
            const DeepCollectionEquality()
                .equals(other._guestBooks, _guestBooks) &&
            (identical(other.isSubmittingGuestBook, isSubmittingGuestBook) ||
                other.isSubmittingGuestBook == isSubmittingGuestBook));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_guestBooks), isSubmittingGuestBook);

  @override
  String toString() {
    return 'WeddingState.loaded(guestBooks: $guestBooks, isSubmittingGuestBook: $isSubmittingGuestBook)';
  }
}

/// @nodoc
abstract mixin class $WeddingLoadedCopyWith<$Res>
    implements $WeddingStateCopyWith<$Res> {
  factory $WeddingLoadedCopyWith(
          WeddingLoaded value, $Res Function(WeddingLoaded) _then) =
      _$WeddingLoadedCopyWithImpl;
  @useResult
  $Res call({List<GuestBook> guestBooks, bool isSubmittingGuestBook});
}

/// @nodoc
class _$WeddingLoadedCopyWithImpl<$Res>
    implements $WeddingLoadedCopyWith<$Res> {
  _$WeddingLoadedCopyWithImpl(this._self, this._then);

  final WeddingLoaded _self;
  final $Res Function(WeddingLoaded) _then;

  /// Create a copy of WeddingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? guestBooks = null,
    Object? isSubmittingGuestBook = null,
  }) {
    return _then(WeddingLoaded(
      guestBooks: null == guestBooks
          ? _self._guestBooks
          : guestBooks // ignore: cast_nullable_to_non_nullable
              as List<GuestBook>,
      isSubmittingGuestBook: null == isSubmittingGuestBook
          ? _self.isSubmittingGuestBook
          : isSubmittingGuestBook // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class WeddingError implements WeddingState {
  const WeddingError(this.message);

  final String message;

  /// Create a copy of WeddingState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $WeddingErrorCopyWith<WeddingError> get copyWith =>
      _$WeddingErrorCopyWithImpl<WeddingError>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is WeddingError &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() {
    return 'WeddingState.error(message: $message)';
  }
}

/// @nodoc
abstract mixin class $WeddingErrorCopyWith<$Res>
    implements $WeddingStateCopyWith<$Res> {
  factory $WeddingErrorCopyWith(
          WeddingError value, $Res Function(WeddingError) _then) =
      _$WeddingErrorCopyWithImpl;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$WeddingErrorCopyWithImpl<$Res> implements $WeddingErrorCopyWith<$Res> {
  _$WeddingErrorCopyWithImpl(this._self, this._then);

  final WeddingError _self;
  final $Res Function(WeddingError) _then;

  /// Create a copy of WeddingState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  $Res call({
    Object? message = null,
  }) {
    return _then(WeddingError(
      null == message
          ? _self.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

// dart format on
