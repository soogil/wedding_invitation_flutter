import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wedding/feature/home/domain/entities/guest_book.dart';
import 'package:wedding/feature/home/presentation/wedding/wedding_presenter.dart';
import 'package:wedding/feature/home/presentation/wedding/wedding_state.dart';
import 'package:wedding/feature/home/presentation/widget/scroll_fade_in.dart';

/// 방명록 뷰 (MVP 패턴 적용)
class GuestBookView extends ConsumerStatefulWidget {
  final String weddingId;

  const GuestBookView({
    super.key,
    required this.weddingId,
  });

  @override
  ConsumerState<GuestBookView> createState() => _GuestBookViewState();
}

class _GuestBookViewState extends ConsumerState<GuestBookView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _msgController = TextEditingController();

  final List<Color> _postItColors = [
    const Color(0xFFFFF8C4), // 연노랑 (기존)
    const Color(0xFFE2F0CB), // 연두 (기존)
    const Color(0xFFFFE0E0), // 연분홍 (기존)
    const Color(0xFFE0F7FA), // 하늘 (기존)

    // --- 추가 추천 컬러 ---
    const Color(0xFFFFF0F5), // 코튼 캔디
    const Color(0xFFFFF9E5), // 바닐라 크림
    const Color(0xFFE8F5E9), // 세이지 그린
    const Color(0xFFE3F2FD), // 미스티 블루
    const Color(0xFFFDF5E6), // 샌드 베이지
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _msgController.dispose();
    super.dispose();
  }

  /// 방명록 제출
  Future<void> _submitGuestBook() async {
    if (_nameController.text.isEmpty || _msgController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이름과 메시지를 입력해주세요.')),
      );
      return;
    }

    try {
      await ref.read(weddingPresenterProvider.notifier).submitGuestBook(
            weddingId: widget.weddingId,
            name: _nameController.text,
            message: _msgController.text,
          );

      _nameController.clear();
      _msgController.clear();
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('방명록이 등록되었습니다.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('등록 실패: $e')),
        );
      }
    }
  }

  void _showWriteDialog() {
    showDialog(
      context: context,
      builder: (context) {
        final state = ref.watch(weddingPresenterProvider);
        final isSubmitting = state is WeddingLoaded && state.isSubmittingGuestBook;

        return AlertDialog(
          title: Text(
            "축하 메시지 남기기",
            style: TextStyle(fontSize: 18.sp),
          ),
          content: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 350.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "이름",
                    hintText: "누구신가요?",
                  ),
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: _msgController,
                  decoration: const InputDecoration(
                    labelText: "메시지",
                    hintText: "축하의 한마디!",
                  ),
                  style: TextStyle(fontSize: 14.sp),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("취소"),
            ),
            ElevatedButton(
              onPressed: isSubmitting ? null : _submitGuestBook,
              child: isSubmitting
                  ? SizedBox(
                      width: 16.w,
                      height: 16.h,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("등록"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(weddingPresenterProvider);

    // 방명록 목록 추출
    final guestBooks = switch (state) {
      WeddingLoaded(:final guestBooks) => guestBooks,
      _ => <GuestBook>[],
    };

    return Column(
      children: [
        // 헤더
        ScrollFadeIn(
          child: Stack(
            children: [
              Center(
                child: Text(
                  '방명록',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w300),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                bottom: 0,
                child: TextButton(
                  onPressed: _showWriteDialog,
                  child: Text(
                    '글남기기',
                    style: TextStyle(fontSize: 14.sp, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 32.h),

        // 방명록 목록
        if (guestBooks.isEmpty)
          ScrollFadeIn(
            delay: const Duration(milliseconds: 150),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Text(
                '아직 작성된 방명록이 없습니다.\n첫 번째 축하 메시지를 남겨주세요!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.sp, color: Colors.grey),
              ),
            ),
          )
        else
          MasonryGridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            itemCount: guestBooks.length,
            itemBuilder: (context, index) {
              final guestBook = guestBooks[index];
              final colorIndex = guestBook.id.hashCode % _postItColors.length;
              final int row = index ~/ 2;
              final int col = index % 2;
              final int staggerDelay = 150 + (row * 100) + (col * 75);

              return ScrollFadeIn(
                delay: Duration(milliseconds: staggerDelay),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: _postItColors[colorIndex],
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 5,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guestBook.message,
                        style: TextStyle(height: 1.4, fontSize: 14.sp),
                      ),
                      SizedBox(height: 10.h),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "- ${guestBook.name} -",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12.sp,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}
