import 'package:wedding/feature/home/domain/entities/guest_book.dart';

/// Wedding Repository 인터페이스 (Domain Layer)
abstract class WeddingRepository {
  /// 방명록 저장
  Future<void> saveGuestBook(String weddingId, GuestBook guestBook);

  /// 방명록 목록 조회
  Future<List<GuestBook>> getGuestBooks(String weddingId);

  /// 방명록 실시간 구독
  Stream<List<GuestBook>> watchGuestBooks(String weddingId);
}
