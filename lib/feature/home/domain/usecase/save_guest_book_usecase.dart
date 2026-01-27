import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wedding/feature/home/data/repositories/wedding_repository_impl.dart';
import 'package:wedding/feature/home/domain/entities/guest_book.dart';
import 'package:wedding/feature/home/domain/repositories/wedding_repository.dart';

part 'save_guest_book_usecase.g.dart';

/// 방명록 저장 UseCase
class SaveGuestBookUseCase {
  final WeddingRepository _repository;

  SaveGuestBookUseCase(this._repository);

  /// 방명록 저장
  Future<void> call({
    required String weddingId,
    required String name,
    required String message,
  }) async {
    // 유효성 검사
    if (name.trim().isEmpty) {
      throw ArgumentError('이름을 입력해주세요.');
    }
    if (message.trim().isEmpty) {
      throw ArgumentError('메시지를 입력해주세요.');
    }

    final guestBook = GuestBook(
      id: weddingId,
      name: name.trim(),
      message: message.trim(),
      createdAt: DateTime.now(),
    );

    print(guestBook.toString());

    await _repository.saveGuestBook(weddingId, guestBook);
  }
}

@riverpod
SaveGuestBookUseCase saveGuestBookUseCase(Ref ref) {
  final repository = ref.watch(weddingRepositoryProvider);
  return SaveGuestBookUseCase(repository);
}
