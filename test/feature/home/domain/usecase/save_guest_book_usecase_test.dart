import 'package:flutter_test/flutter_test.dart';
import 'package:wedding/feature/home/domain/entities/guest_book.dart';
import 'package:wedding/feature/home/domain/repositories/wedding_repository.dart';
import 'package:wedding/feature/home/domain/usecase/save_guest_book_usecase.dart';

/// Fake Repository for testing
class FakeWeddingRepository implements WeddingRepository {
  final List<GuestBook> savedGuestBooks = [];
  bool shouldThrowError = false;
  String? errorMessage;

  @override
  Future<void> saveGuestBook(String weddingId, GuestBook guestBook) async {
    if (shouldThrowError) {
      throw Exception(errorMessage ?? 'Save failed');
    }
    savedGuestBooks.add(guestBook);
  }

  @override
  Future<List<GuestBook>> getGuestBooks(String weddingId) async {
    return savedGuestBooks;
  }

  @override
  Stream<List<GuestBook>> watchGuestBooks(String weddingId) {
    return Stream.value(savedGuestBooks);
  }
}

void main() {
  late SaveGuestBookUseCase useCase;
  late FakeWeddingRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeWeddingRepository();
    useCase = SaveGuestBookUseCase(fakeRepository);
  });

  group('SaveGuestBookUseCase', () {
    test('should save guest book with valid data', () async {
      await useCase(
        weddingId: 'default',
        name: '홍길동',
        message: '결혼 축하합니다!',
      );

      expect(fakeRepository.savedGuestBooks.length, 1);
      expect(fakeRepository.savedGuestBooks.first.name, '홍길동');
      expect(fakeRepository.savedGuestBooks.first.message, '결혼 축하합니다!');
    });

    test('should trim whitespace from name and message', () async {
      await useCase(
        weddingId: 'default',
        name: '  김철수  ',
        message: '  축하해요!  ',
      );

      expect(fakeRepository.savedGuestBooks.first.name, '김철수');
      expect(fakeRepository.savedGuestBooks.first.message, '축하해요!');
    });

    test('should throw ArgumentError when name is empty', () async {
      expect(
        () => useCase(
          weddingId: 'default',
          name: '',
          message: '축하합니다!',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw ArgumentError when name is only whitespace', () async {
      expect(
        () => useCase(
          weddingId: 'default',
          name: '   ',
          message: '축하합니다!',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw ArgumentError when message is empty', () async {
      expect(
        () => useCase(
          weddingId: 'default',
          name: '홍길동',
          message: '',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should throw ArgumentError when message is only whitespace', () async {
      expect(
        () => useCase(
          weddingId: 'default',
          name: '홍길동',
          message: '   ',
        ),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('should set empty id for new guest book', () async {
      await useCase(
        weddingId: 'default',
        name: '이영희',
        message: '행복하세요!',
      );

      expect(fakeRepository.savedGuestBooks.first.id, '');
    });

    test('should set createdAt to current time', () async {
      final beforeCall = DateTime.now();

      await useCase(
        weddingId: 'default',
        name: '박민수',
        message: '축하드립니다!',
      );

      final afterCall = DateTime.now();
      final createdAt = fakeRepository.savedGuestBooks.first.createdAt;

      expect(
        createdAt.isAfter(beforeCall.subtract(const Duration(seconds: 1))),
        true,
      );
      expect(
        createdAt.isBefore(afterCall.add(const Duration(seconds: 1))),
        true,
      );
    });

    test('should propagate repository errors', () async {
      fakeRepository.shouldThrowError = true;
      fakeRepository.errorMessage = 'Network error';

      expect(
        () => useCase(
          weddingId: 'default',
          name: '홍길동',
          message: '축하합니다!',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('should handle multiple submissions', () async {
      await useCase(
        weddingId: 'default',
        name: '첫번째',
        message: '첫번째 메시지',
      );
      await useCase(
        weddingId: 'default',
        name: '두번째',
        message: '두번째 메시지',
      );

      expect(fakeRepository.savedGuestBooks.length, 2);
    });

    test('should handle special characters', () async {
      await useCase(
        weddingId: 'default',
        name: '김수길 ❤️ 유연정',
        message: '행복하세요! 🎉🎊',
      );

      expect(fakeRepository.savedGuestBooks.first.name, '김수길 ❤️ 유연정');
      expect(fakeRepository.savedGuestBooks.first.message, '행복하세요! 🎉🎊');
    });
  });
}
