import 'package:wedding/feature/home/domain/entities/guest_book.dart';

/// Wedding View 인터페이스 (Presenter → View 명령)
abstract interface class WeddingView {
  /// 로딩 표시
  void showLoading();

  /// 로딩 숨김
  void hideLoading();

  /// 방명록 목록 표시
  void showGuestBooks(List<GuestBook> guestBooks);

  /// 방명록 제출 로딩 표시
  void showSubmitLoading();

  /// 방명록 제출 로딩 숨김
  void hideSubmitLoading();

  /// 성공 메시지 표시
  void showSuccessMessage(String message);

  /// 에러 메시지 표시
  void showErrorMessage(String message);

  /// 다이얼로그 닫기
  void dismissDialog();

  /// 입력 필드 초기화
  void clearInputFields();
}

/// Wedding Presenter 인터페이스 (View → Presenter 요청)
abstract interface class WeddingPresenter {
  /// View 연결
  void setView(WeddingView view);

  /// 방명록 로드 및 구독 시작
  void loadGuestBooks(String weddingId);

  /// 방명록 제출
  Future<void> submitGuestBook({
    required String weddingId,
    required String name,
    required String message,
  });

  /// 리소스 정리
  void dispose();
}
