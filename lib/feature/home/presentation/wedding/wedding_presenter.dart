import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wedding/feature/home/data/repositories/wedding_repository_impl.dart';
import 'package:wedding/feature/home/domain/entities/guest_book.dart';
import 'package:wedding/feature/home/domain/usecase/save_guest_book_usecase.dart';
import 'package:wedding/feature/home/presentation/wedding/wedding_state.dart';

part 'wedding_presenter.g.dart';

@riverpod
class WeddingPresenter extends _$WeddingPresenter {
  StreamSubscription<List<GuestBook>>? _guestBookSubscription;

  @override
  WeddingState build() {
    ref.onDispose(() {
      _guestBookSubscription?.cancel();
    });
    return const WeddingState.initial();
  }

  /// 방명록 로드 및 구독 시작
  void loadGuestBooks(String weddingId) {
    state = const WeddingState.loading();
    _subscribeToGuestBooks(weddingId);
  }

  /// 방명록 실시간 구독
  void _subscribeToGuestBooks(String weddingId) {
    _guestBookSubscription?.cancel();

    final repository = ref.read(weddingRepositoryProvider);
    _guestBookSubscription = repository.watchGuestBooks(weddingId).listen(
      (guestBooks) {
        state = WeddingState.loaded(guestBooks: guestBooks);
      },
      onError: (error) {
        state = WeddingState.error(error.toString());
      },
    );
  }

  /// 방명록 제출
  Future<void> submitGuestBook({
    required String weddingId,
    required String name,
    required String message,
  }) async {
    final currentState = state;
    if (currentState is! WeddingLoaded) return;

    state = currentState.copyWith(isSubmittingGuestBook: true);

    try {
      final saveGuestBookUseCase = ref.read(saveGuestBookUseCaseProvider);
      await saveGuestBookUseCase(
        weddingId: weddingId,
        name: name,
        message: message,
      );

      final newState = state;
      if (newState is WeddingLoaded) {
        state = newState.copyWith(isSubmittingGuestBook: false);
      }
    } catch (e) {
      final newState = state;
      if (newState is WeddingLoaded) {
        state = newState.copyWith(isSubmittingGuestBook: false);
      }
      // 에러를 다시 throw하여 UI에서 처리할 수 있도록 함
      rethrow;
    }
  }
}
