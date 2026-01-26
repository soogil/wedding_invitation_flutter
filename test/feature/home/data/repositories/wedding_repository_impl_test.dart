import 'package:flutter_test/flutter_test.dart';
import 'package:wedding/feature/home/data/datasource/firestore_datasource.dart';
import 'package:wedding/feature/home/data/models/guest_book_model.dart';
import 'package:wedding/feature/home/data/repositories/wedding_repository_impl.dart';
import 'package:wedding/feature/home/domain/entities/guest_book.dart';

/// Fake Firestore DataSource for testing
class FakeFirestoreDataSource implements FirestoreDataSource {
  final List<GuestBookModel> _guestBooks = [];
  bool shouldThrowError = false;

  void addGuestBook(GuestBookModel model) {
    _guestBooks.add(model);
  }

  @override
  Future<void> saveGuestBook(String weddingId, GuestBook guestBook) async {
    if (shouldThrowError) {
      throw Exception('Save failed');
    }
    _guestBooks.add(GuestBookModel(
      id: 'generated-id-${_guestBooks.length}',
      name: guestBook.name,
      message: guestBook.message,
      createdAt: guestBook.createdAt,
    ));
  }

  @override
  Future<List<GuestBookModel>> getGuestBooks(String weddingId) async {
    if (shouldThrowError) {
      throw Exception('Load failed');
    }
    return _guestBooks;
  }

  @override
  Stream<List<GuestBookModel>> watchGuestBooks(String weddingId) {
    if (shouldThrowError) {
      return Stream.error(Exception('Stream error'));
    }
    return Stream.value(_guestBooks);
  }
}

void main() {
  late WeddingRepositoryImpl repository;
  late FakeFirestoreDataSource fakeDataSource;

  setUp(() {
    fakeDataSource = FakeFirestoreDataSource();
    repository = WeddingRepositoryImpl(fakeDataSource);
  });

  group('WeddingRepositoryImpl', () {
    group('saveGuestBook', () {
      test('should save guest book through data source', () async {
        final guestBook = GuestBook(
          id: '',
          name: '홍길동',
          message: '축하합니다!',
          createdAt: DateTime.now(),
        );

        await repository.saveGuestBook('default', guestBook);

        final savedBooks = await fakeDataSource.getGuestBooks('default');
        expect(savedBooks.length, 1);
        expect(savedBooks.first.name, '홍길동');
      });

      test('should throw when save fails', () async {
        fakeDataSource.shouldThrowError = true;

        final guestBook = GuestBook(
          id: '',
          name: '홍길동',
          message: '축하합니다!',
          createdAt: DateTime.now(),
        );

        expect(
          () => repository.saveGuestBook('default', guestBook),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('getGuestBooks', () {
      test('should return empty list when no guest books', () async {
        final result = await repository.getGuestBooks('default');

        expect(result, isEmpty);
      });

      test('should return guest books as entities', () async {
        fakeDataSource.addGuestBook(GuestBookModel(
          id: 'id-1',
          name: '홍길동',
          message: '축하해요!',
          createdAt: DateTime.now(),
        ));
        fakeDataSource.addGuestBook(GuestBookModel(
          id: 'id-2',
          name: '김철수',
          message: '행복하세요!',
          createdAt: DateTime.now(),
        ));

        final result = await repository.getGuestBooks('default');

        expect(result.length, 2);
        expect(result[0].id, 'id-1');
        expect(result[0].name, '홍길동');
        expect(result[1].id, 'id-2');
        expect(result[1].name, '김철수');
      });

      test('should convert model to entity correctly', () async {
        final now = DateTime(2026, 1, 26, 12, 0, 0);
        fakeDataSource.addGuestBook(GuestBookModel(
          id: 'test-id',
          name: '이영희',
          message: '축하드립니다!',
          createdAt: now,
        ));

        final result = await repository.getGuestBooks('default');
        final entity = result.first;

        expect(entity, isA<GuestBook>());
        expect(entity.id, 'test-id');
        expect(entity.name, '이영희');
        expect(entity.message, '축하드립니다!');
        expect(entity.createdAt, now);
      });
    });

    group('watchGuestBooks', () {
      test('should return stream of guest books', () async {
        fakeDataSource.addGuestBook(GuestBookModel(
          id: 'id-1',
          name: '스트림테스트',
          message: '실시간!',
          createdAt: DateTime.now(),
        ));

        final stream = repository.watchGuestBooks('default');
        final result = await stream.first;

        expect(result.length, 1);
        expect(result.first.name, '스트림테스트');
      });

      test('should convert stream items to entities', () async {
        fakeDataSource.addGuestBook(GuestBookModel(
          id: 'stream-id',
          name: '변환테스트',
          message: '엔티티로!',
          createdAt: DateTime.now(),
        ));

        final stream = repository.watchGuestBooks('default');
        final result = await stream.first;

        expect(result.first, isA<GuestBook>());
      });
    });
  });
}
