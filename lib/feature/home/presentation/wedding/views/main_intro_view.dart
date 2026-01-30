import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedding/core/util/bgm_player.dart';

/// 메인 인트로 뷰 (HookWidget 적용)
class MainIntroView extends HookWidget {
  const MainIntroView({super.key, required this.children});

  final List<Widget> children;

  static const _heroImage1 = AssetImage('assets/hero1.jpg');
  static const _heroImage2 = AssetImage('assets/hero2.jpg');

  @override
  Widget build(BuildContext context) {
    final animationController = useAnimationController(
      duration: const Duration(milliseconds: 3000),
    );

    final introScale = useMemoized(
      () => Tween<double>(begin: 1.05, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
        ),
      ),
      [animationController],
    );

    final introBlur = useMemoized(
      () => Tween<double>(begin: 10.0, end: 0.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
        ),
      ),
      [animationController],
    );

    final textIntroOpacity = useMemoized(
      () => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
        ),
      ),
      [animationController],
    );

    final showIntro = useState(true);
    final isEntering = useState(false);
    final audioManager = useMemoized(() => AudioManager());

    // 초기화 및 애니메이션 시작
    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // heroImage1은 비동기로 백그라운드에서 로드
        precacheImage(_heroImage1, context).catchError((e) {
          debugPrint("Failed to precache heroImage1: $e");
        });

        animationController.forward();
      });
      return null;
    }, const []);

    void enter() {
      if (animationController.value < 0.6) return;
      if (isEntering.value) return;

      isEntering.value = true;
      audioManager.toggleMusic();

      Future.delayed(const Duration(milliseconds: 600), () {
        showIntro.value = false;
      });
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          ScrollNotificationObserver(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _ResponsiveWrapper(
                    child: Stack(
                      children: [
                        AspectRatio(
                          aspectRatio: 9 / 16,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              const Image(
                                image: _heroImage1,
                                fit: BoxFit.contain,
                              ),
                              Container(
                                  color: Colors.black.withValues(alpha: 0.18)),
                            ],
                          ),
                        ),
                        const Positioned.fill(
                          bottom: 20,
                          left: 20,
                          right: 20,
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: _MainHeroText(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _ResponsiveWrapper(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: children,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showIntro.value)
            Positioned.fill(
              child: GestureDetector(
                onTap: enter,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: isEntering.value ? 0.0 : 1.0,
                  child: AnimatedBuilder(
                    animation: animationController,
                    builder: (context, _) {
                      return _ResponsiveWrapper(
                        isOverlay: true,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Transform.scale(
                              scale: introScale.value,
                              child: const Image(
                                  image: _heroImage2, fit: BoxFit.cover),
                            ),
                            Container(
                                color: Colors.black.withValues(alpha: 0.3)),
                            if (introBlur.value > 0.01)
                              BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: introBlur.value,
                                  sigmaY: introBlur.value,
                                ),
                                child: Container(color: Colors.transparent),
                              ),
                            Positioned(
                              bottom: 50.h,
                              left: 0,
                              right: 0,
                              child: Column(
                                children: [
                                  const _IntroTitle(),
                                  SizedBox(height: 8.h),
                                  Center(
                                    child: Opacity(
                                      opacity: textIntroOpacity.value,
                                      child: Column(
                                        children: [
                                          Text(
                                            '화면을 터치하여 입장하기',
                                            style: TextStyle(
                                              color: Colors.white
                                                  .withValues(alpha: 0.9),
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                          SizedBox(height: 8.h),
                                          Icon(
                                            Icons.touch_app,
                                            color: Colors.white
                                                .withValues(alpha: 0.7),
                                            size: 32,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ResponsiveWrapper extends StatelessWidget {
  final Widget child;
  final bool isOverlay;

  const _ResponsiveWrapper({
    required this.child,
    this.isOverlay = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        color: isOverlay ? null : const Color(0xFFF6F2EA),
        width: double.infinity,
        child: child,
      ),
    );
  }
}

class _IntroTitle extends StatelessWidget {
  const _IntroTitle();

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.rotate(
            angle: -0.15,
            child: Text(
              "We Are\nGetting Married",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: 'IndieFlower',
                fontSize: 48.sp,
                height: 1.2,
              ),
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

class _MainHeroText extends StatelessWidget {
  const _MainHeroText();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "김수길 ❤️ 유연정",
          style: TextStyle(fontSize: 26.sp, height: 1.1, color: Colors.white),
        ),
        SizedBox(height: 8.h),
        Text(
          "We Are Getting Married",
          style: TextStyle(
              fontSize: 16.sp, color: Colors.white.withValues(alpha: 0.9)),
        ),
        SizedBox(height: 10.h),
        Container(
          height: 1,
          width: 140.w,
          color: Colors.white.withValues(alpha: 0.45),
        ),
        SizedBox(height: 10.h),
        Text(
          "2026. 06. 14",
          style: TextStyle(
              fontSize: 13.sp, color: Colors.white.withValues(alpha: 0.75)),
        ),
      ],
    );
  }
}
