import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:wedding/feature/home/domain/entities/guest_book.dart';

part 'wedding_state.freezed.dart';

@freezed
sealed class WeddingState with _$WeddingState {
  const factory WeddingState.initial() = WeddingInitial;

  const factory WeddingState.loading() = WeddingLoading;

  const factory WeddingState.loaded({
    @Default([]) List<GuestBook> guestBooks,
    @Default(false) bool isSubmittingGuestBook,
  }) = WeddingLoaded;

  const factory WeddingState.error(String message) = WeddingError;
}
