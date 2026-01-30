import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wedding/feature/home/domain/entities/guest_book.dart';
import 'package:wedding/feature/home/presentation/wedding/views/gallery_view.dart';
import 'package:wedding/feature/home/presentation/wedding/views/guest_book_view.dart';
import 'package:wedding/feature/home/presentation/wedding/views/intro_ourselves_view.dart';
import 'package:wedding/feature/home/presentation/wedding/views/main_intro_view.dart';
import 'package:wedding/feature/home/presentation/wedding/views/time_line_view.dart';
import 'package:wedding/feature/home/presentation/wedding/wedding_delegate.dart';
import 'package:wedding/feature/home/presentation/wedding/wedding_presenter_impl.dart';
import 'package:wedding/feature/home/presentation/widget/scroll_fade_in.dart';

/// 청첩장 메인 페이지 (MVP 적용)
class WeddingAnnouncementPage extends HookConsumerWidget {
  const WeddingAnnouncementPage({super.key});

  static const String defaultWeddingId = 'default';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presenter = ref.watch(weddingPresenterProvider);

    // Hooks 상태
    final isLoading = useState(false);
    final isSubmitting = useState(false);
    final guestBooks = useState<List<GuestBook>>([]);
    final nameController = useTextEditingController();
    final messageController = useTextEditingController();

    // Delegate 인스턴스 (박제)
    final delegate = useMemoized(
      () => WeddingDelegate(
        context: context,
        isLoadingState: isLoading,
        isSubmittingState: isSubmitting,
        guestBooksState: guestBooks,
        nameController: nameController,
        messageController: messageController,
      ),
      [context],
    );

    // 생명주기 연결
    useEffect(() {
      presenter.setView(delegate);
      presenter.loadGuestBooks(defaultWeddingId);
      return presenter.dispose;
    }, [presenter]);

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
              "가족 간의 깊은 대화와 따뜻한 눈맞춤에 집중하고 싶어 내린\n"
              "결정이니 너그러운 마음으로 이해해 주시기를 부탁드립니다.\n\n"
              "직접 모시지 못하는 죄송한 마음은 훗날 더 반가운 모습으로 \n"
              "찾아뵙고 전하겠습니다.\n\n"
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
        GuestBookView(
          weddingId: defaultWeddingId,
          guestBooks: guestBooks.value,
          isSubmitting: isSubmitting.value,
          nameController: nameController,
          messageController: messageController,
          onSubmit: () => presenter.submitGuestBook(
            weddingId: defaultWeddingId,
            name: nameController.text,
            message: messageController.text,
          ),
        ),
        SizedBox(height: 80.h),
      ],
    );
  }
}
