import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedding/feature/home/presentation/wedding/gallery_view.dart';
import 'package:wedding/feature/home/presentation/wedding/guest_book_view.dart';
import 'package:wedding/feature/home/presentation/wedding/intro_ourselves_view.dart';
import 'package:wedding/feature/home/presentation/wedding/main_intro_view.dart';
import 'package:wedding/feature/home/presentation/wedding/time_line_view.dart';
import 'package:wedding/feature/home/presentation/wedding/wedding_presenter.dart';
import 'package:wedding/feature/home/presentation/widget/scroll_fade_in.dart';

/// 청첩장 메인 페이지 (MVP 적용)
class WeddingAnnouncementPage extends ConsumerStatefulWidget {
  const WeddingAnnouncementPage({super.key});

  static const String defaultWeddingId = 'default';

  @override
  ConsumerState<WeddingAnnouncementPage> createState() =>
      _WeddingAnnouncementPageState();
}

class _WeddingAnnouncementPageState
    extends ConsumerState<WeddingAnnouncementPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(weddingPresenterProvider.notifier)
          .loadGuestBooks(WeddingAnnouncementPage.defaultWeddingId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainIntroView(
      children: [
        SizedBox(height: 20.h),
        ScrollFadeIn(
          child: Center(
            child: Text(
              "가족들과 함께하는 작은 예식을 올립니다\n\n",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ScrollFadeIn(
          delay: const Duration(milliseconds: 150),
          child: Center(
            child: Text(
              "저희 두 사람이 부부로서 첫걸음을 떼는 소중한 날\n"
              "가장 가까운 가족들과 오붓한 시간을 보내기로 했습니다.\n\n"
              "가장 멋지고 아름다울 우리 부모님의 모습,"
              "\n그리고 서로의 눈빛을 오롯이 눈에 담고 싶어서 입니다.\n\n"
              "가족 간의 깊은 대화와 따뜻한 눈맞춤에 집중하고 싶어 내린 \n결정이니"
              "너그러운 마음으로 이해해 주시기를 부탁드립니다.\n\n"
              "직접 모시지 못하는 죄송한 마음은"
              "훗날 더 반가운 모습으로 \n찾아뵙고 전하겠습니다.\n\n"
              "멀리서 보내주시는 축복만으로도 저희에겐 큰 힘이 됩니다.\n"
              "예쁘게 잘 살겠습니다.\n\n"
              "김수길 · 유연정 올림",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15.sp, height: 1.7),
            ),
          ),
        ),
        SizedBox(height: 80.h),
        const IntroOurselvesView(),
        SizedBox(height: 80.h),
        const TimeLineView(),
        SizedBox(height: 80.h),
        const GalleryView(),
        SizedBox(height: 80.h),
        GuestBookView(weddingId: WeddingAnnouncementPage.defaultWeddingId),
        SizedBox(height: 80.h),
      ],
    );
  }
}
