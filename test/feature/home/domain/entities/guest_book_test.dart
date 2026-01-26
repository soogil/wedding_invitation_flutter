import 'package:flutter_test/flutter_test.dart';
import 'package:wedding/feature/home/domain/entities/guest_book.dart';

void main() {
  group('GuestBook Entity', () {
    test('should create GuestBook with required fields', () {
      final now = DateTime.now();
      final guestBook = GuestBook(
        id: 'test-id',
        name: '홍길동',
        message: '결혼 축하합니다!',
        createdAt: now,
      );

      expect(guestBook.id, 'test-id');
      expect(guestBook.name, '홍길동');
      expect(guestBook.message, '결혼 축하합니다!');
      expect(guestBook.createdAt, now);
    });

    test('toFirestore should return correct map without id', () {
      final now = DateTime(2026, 1, 26, 12, 0, 0);
      final guestBook = GuestBook(
        id: 'test-id',
        name: '김철수',
        message: '행복하세요!',
        createdAt: now,
      );

      final firestoreMap = guestBook.toFirestore();

      expect(firestoreMap['name'], '김철수');
      expect(firestoreMap['message'], '행복하세요!');
      expect(firestoreMap['createdAt'], now);
      expect(firestoreMap.containsKey('id'), false);
    });

    test('should handle empty id for new guest book', () {
      final guestBook = GuestBook(
        id: '',
        name: '이영희',
        message: '축하드려요!',
        createdAt: DateTime.now(),
      );

      expect(guestBook.id, '');
    });

    test('should handle long message', () {
      final longMessage = '축하합니다! ' * 100;
      final guestBook = GuestBook(
        id: 'test-id',
        name: '박민수',
        message: longMessage,
        createdAt: DateTime.now(),
      );

      expect(guestBook.message, longMessage);
    });

    test('should handle special characters in name and message', () {
      final guestBook = GuestBook(
        id: 'test-id',
        name: '김수길 ❤️ 유연정',
        message: '축하해요! 🎉🎊 Happy Wedding!',
        createdAt: DateTime.now(),
      );

      expect(guestBook.name, '김수길 ❤️ 유연정');
      expect(guestBook.message, '축하해요! 🎉🎊 Happy Wedding!');
    });
  });
}
