import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wedding/feature/home/data/repositories/wedding_repository_impl.dart';
import 'package:wedding/feature/home/domain/repositories/wedding_repository.dart';
import 'package:wedding/feature/home/domain/usecase/save_guest_book_usecase.dart';
import 'package:wedding/feature/home/presentation/wedding/wedding_contract.dart';

part 'wedding_presenter_impl.g.dart';

/// Wedding Presenter 구현체 (Command-driven MVP)
class WeddingPresenterImpl implements WeddingPresenter {
  final WeddingRepository _repository;
  final SaveGuestBookUseCase _saveGuestBookUseCase;

  WeddingView? _view;
  StreamSubscription? _guestBookSubscription;

  WeddingPresenterImpl({
    required WeddingRepository repository,
    required SaveGuestBookUseCase saveGuestBookUseCase,
  })  : _repository = repository,
        _saveGuestBookUseCase = saveGuestBookUseCase;

  @override
  void setView(WeddingView view) => _view = view;

  @override
  void loadGuestBooks(String weddingId) {
    _view?.showLoading();
    _subscribeToGuestBooks(weddingId);
  }

  void _subscribeToGuestBooks(String weddingId) {
    _guestBookSubscription?.cancel();

    _guestBookSubscription = _repository.watchGuestBooks(weddingId).listen(
      (guestBooks) {
        _view?.hideLoading();
        _view?.showGuestBooks(guestBooks);
      },
      onError: (error) {
        _view?.hideLoading();
        _view?.showErrorMessage(error.toString());
      },
    );
  }

  @override
  Future<void> submitGuestBook({
    required String weddingId,
    required String name,
    required String message,
  }) async {
    // 유효성 검사
    if (name.trim().isEmpty || message.trim().isEmpty) {
      _view?.showErrorMessage('이름과 메시지를 입력해주세요.');
      return;
    }

    _view?.showSubmitLoading();

    try {
      await _saveGuestBookUseCase(
        weddingId: weddingId,
        name: name,
        message: message,
      );

      _view?.hideSubmitLoading();
      _view?.clearInputFields();
      _view?.dismissDialog();
      _view?.showSuccessMessage('방명록이 등록되었습니다.');
    } catch (e) {
      _view?.hideSubmitLoading();
      _view?.showErrorMessage('등록 실패: $e');
    }
  }

  @override
  void dispose() {
    _guestBookSubscription?.cancel();
    _view = null;
  }
}

@riverpod
WeddingPresenter weddingPresenter(Ref ref) {
  final repository = ref.watch(weddingRepositoryProvider);
  final saveGuestBookUseCase = ref.watch(saveGuestBookUseCaseProvider);

  final presenter = WeddingPresenterImpl(
    repository: repository,
    saveGuestBookUseCase: saveGuestBookUseCase,
  );

  ref.onDispose(presenter.dispose);

  return presenter;
}
