import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wedding/feature/home/domain/entities/guest_book.dart';
import 'package:wedding/feature/home/presentation/widget/scroll_fade_in.dart';

const _postItColors = [
  Color(0xFFFFF8C4), // 연노랑
  Color(0xFFE2F0CB), // 연두
  Color(0xFFFFE0E0), // 연분홍
  Color(0xFFE0F7FA), // 하늘
  Color(0xFFFFF0F5), // 코튼 캔디
  Color(0xFFFFF9E5), // 바닐라 크림
  Color(0xFFE8F5E9), // 세이지 그린
  Color(0xFFE3F2FD), // 미스티 블루
  Color(0xFFFDF5E6), // 샌드 베이지
];

/// 방명록 뷰 (Passive View - 판단 로직 없음)
class GuestBookView extends StatelessWidget {
  final String weddingId;
  final List<GuestBook> guestBooks;
  final bool isSubmitting;
  final TextEditingController nameController;
  final TextEditingController messageController;
  final VoidCallback onSubmit;

  const GuestBookView({
    super.key,
    required this.weddingId,
    required this.guestBooks,
    required this.isSubmitting,
    required this.nameController,
    required this.messageController,
    required this.onSubmit,
  });

  void _showWriteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return _GuestBookDialog(
          nameController: nameController,
          messageController: messageController,
          isSubmitting: isSubmitting,
          onSubmit: onSubmit,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () => _showWriteDialog(context),
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
                child: _GuestBookCard(
                  guestBook: guestBook,
                  backgroundColor: _postItColors[colorIndex],
                ),
              );
            },
          ),
      ],
    );
  }
}

/// 방명록 카드 위젯
class _GuestBookCard extends StatelessWidget {
  final GuestBook guestBook;
  final Color backgroundColor;

  const _GuestBookCard({
    required this.guestBook,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(2, 2),
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
    );
  }
}

/// 방명록 작성 다이얼로그
class _GuestBookDialog extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController messageController;
  final bool isSubmitting;
  final VoidCallback onSubmit;

  const _GuestBookDialog({
    required this.nameController,
    required this.messageController,
    required this.isSubmitting,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
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
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "이름",
                hintText: "누구신가요?",
              ),
              style: TextStyle(fontSize: 14.sp),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: messageController,
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
          onPressed: isSubmitting ? null : onSubmit,
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
  }
}
