import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:wedding/feature/home/domain/entities/guest_book.dart';
import 'package:wedding/feature/home/domain/repositories/wedding_repository.dart';
import 'package:wedding/feature/home/domain/usecase/save_guest_book_usecase.dart';
import 'package:wedding/feature/home/presentation/wedding/wedding_contract.dart';
import 'package:wedding/feature/home/presentation/wedding/wedding_presenter_impl.dart';

/// Fake Repository for testing WeddingPresenter
class FakeWeddingRepository implements WeddingRepository {
  final List<GuestBook> _guestBooks = [];
  final StreamController<List<GuestBook>> _guestBooksController =
      StreamController<List<GuestBook>>.broadcast();

  bool shouldThrowOnSave = false;

  void emitGuestBooks(List<GuestBook> books) {
    _guestBooksController.add(books);
  }

  void emitError(Object error) {
    _guestBooksController.addError(error);
  }

  @override
  Future<void> saveGuestBook(String weddingId, GuestBook guestBook) async {
    if (shouldThrowOnSave) {
      throw Exception('Failed to save guest book');
    }
    final newGuestBook = GuestBook(
      id: 'generated-${_guestBooks.length}',
      name: guestBook.name,
      message: guestBook.message,
      createdAt: guestBook.createdAt,
    );
    _guestBooks.add(newGuestBook);
    _guestBooksController.add(_guestBooks);
  }

  @override
  Future<List<GuestBook>> getGuestBooks(String weddingId) async {
    return _guestBooks;
  }

  @override
  Stream<List<GuestBook>> watchGuestBooks(String weddingId) {
    return _guestBooksController.stream;
  }

  void dispose() {
    _guestBooksController.close();
  }
}

/// Mock View for testing WeddingPresenter
class MockWeddingView implements WeddingView {
  final List<String> callLog = [];
  List<GuestBook>? lastGuestBooks;
  String? lastMessage;

  @override
  void showLoading() {
    callLog.add('showLoading');
  }

  @override
  void hideLoading() {
    callLog.add('hideLoading');
  }

  @override
  void showGuestBooks(List<GuestBook> guestBooks) {
    callLog.add('showGuestBooks');
    lastGuestBooks = guestBooks;
  }

  @override
  void showSubmitLoading() {
    callLog.add('showSubmitLoading');
  }

  @override
  void hideSubmitLoading() {
    callLog.add('hideSubmitLoading');
  }

  @override
  void showSuccessMessage(String message) {
    callLog.add('showSuccessMessage');
    lastMessage = message;
  }

  @override
  void showErrorMessage(String message) {
    callLog.add('showErrorMessage');
    lastMessage = message;
  }

  @override
  void dismissDialog() {
    callLog.add('dismissDialog');
  }

  @override
  void clearInputFields() {
    callLog.add('clearInputFields');
  }

  void reset() {
    callLog.clear();
    lastGuestBooks = null;
    lastMessage = null;
  }
}

void main() {
  late FakeWeddingRepository fakeRepository;
  late SaveGuestBookUseCase saveGuestBookUseCase;
  late WeddingPresenterImpl presenter;
  late MockWeddingView mockView;

  setUp(() {
    fakeRepository = FakeWeddingRepository();
    saveGuestBookUseCase = SaveGuestBookUseCase(fakeRepository);
    presenter = WeddingPresenterImpl(
      repository: fakeRepository,
      saveGuestBookUseCase: saveGuestBookUseCase,
    );
    mockView = MockWeddingView();
    presenter.setView(mockView);
  });

  tearDown(() {
    presenter.dispose();
    fakeRepository.dispose();
  });

  group('WeddingPresenter', () {
    group('loadGuestBooks', () {
      test('should call showLoading when loading starts', () {
        presenter.loadGuestBooks('default');

        expect(mockView.callLog, contains('showLoading'));
      });

      test('should call hideLoading and showGuestBooks when data arrives', () async {
        presenter.loadGuestBooks('default');

        final testGuestBooks = [
          GuestBook(
            id: '1',
            name: '홍길동',
            message: '축하합니다!',
            createdAt: DateTime.now(),
          ),
        ];

        fakeRepository.emitGuestBooks(testGuestBooks);

        // Stream 이벤트 처리 대기
        await Future.delayed(Duration.zero);

        expect(mockView.callLog, contains('hideLoading'));
        expect(mockView.callLog, contains('showGuestBooks'));
        expect(mockView.lastGuestBooks, equals(testGuestBooks));
      });

      test('should call showErrorMessage when stream emits error', () async {
        presenter.loadGuestBooks('default');

        fakeRepository.emitError(Exception('Network error'));

        // Stream 이벤트 처리 대기
        await Future.delayed(Duration.zero);

        expect(mockView.callLog, contains('hideLoading'));
        expect(mockView.callLog, contains('showErrorMessage'));
      });
    });

    group('submitGuestBook', () {
      test('should show error when name is empty', () async {
        await presenter.submitGuestBook(
          weddingId: 'default',
          name: '',
          message: '축하합니다!',
        );

        expect(mockView.callLog, contains('showErrorMessage'));
        expect(mockView.lastMessage, contains('이름과 메시지를 입력해주세요'));
      });

      test('should show error when message is empty', () async {
        await presenter.submitGuestBook(
          weddingId: 'default',
          name: '홍길동',
          message: '',
        );

        expect(mockView.callLog, contains('showErrorMessage'));
        expect(mockView.lastMessage, contains('이름과 메시지를 입력해주세요'));
      });

      test('should call correct sequence on successful submit', () async {
        await presenter.submitGuestBook(
          weddingId: 'default',
          name: '홍길동',
          message: '축하합니다!',
        );

        expect(mockView.callLog, containsAllInOrder([
          'showSubmitLoading',
          'hideSubmitLoading',
          'clearInputFields',
          'dismissDialog',
          'showSuccessMessage',
        ]));
        expect(mockView.lastMessage, contains('방명록이 등록되었습니다'));
      });

      test('should show error on submit failure', () async {
        fakeRepository.shouldThrowOnSave = true;

        await presenter.submitGuestBook(
          weddingId: 'default',
          name: '홍길동',
          message: '축하합니다!',
        );

        expect(mockView.callLog, contains('showSubmitLoading'));
        expect(mockView.callLog, contains('hideSubmitLoading'));
        expect(mockView.callLog, contains('showErrorMessage'));
        expect(mockView.lastMessage, contains('등록 실패'));
      });
    });

    group('dispose', () {
      test('should set view to null', () async {
        presenter.dispose();

        // dispose 후 메서드 호출해도 에러 없어야 함 (null-safe)
        presenter.loadGuestBooks('default');

        // 아무 콜도 추가되지 않아야 함
        expect(mockView.callLog, isEmpty);
      });
    });
  });
}
