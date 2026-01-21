import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedding/core/util/bgm_player.dart';

class MainIntroView extends StatefulWidget {
  const MainIntroView({super.key, required this.children});

  final List<Widget> children;

  @override
  State<MainIntroView> createState() => _MainIntroViewState();
}

class _MainIntroViewState extends State<MainIntroView>
    with SingleTickerProviderStateMixin {
  final AudioManager _audioManager = AudioManager();
  late final AnimationController _c;
  late final Animation<double> _introOpacity;
  late final Animation<double> _mainOpacity;
  late final Animation<double> _introScale;
  late final Animation<double> _introBlur;       // 블러 애니메이션
  late final Animation<double> _textIntroOpacity; // 텍스트 등장 애니메이션 (새로 추가)

  bool _showIntro = true;
  bool _isEntering = false;

  final ImageProvider heroImage1 = const AssetImage('assets/hero1.jpg');
  final ImageProvider heroImage2 = const AssetImage('assets/hero2.jpg');

  @override
  void initState() {
    super.initState();

    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000), // 블러 효과를 즐기기 위해 시간을 조금 늘림 (2.5초 -> 3초)
    );

    // 1. 인트로 전체 투명도 (입장 시작되면 사라짐)
    _introOpacity = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(
        parent: _c, curve: const Interval(0.0, 0.8, curve: Curves.easeOut)));

    // 2. 메인 화면 투명도
    _mainOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _c, curve: const Interval(0.4, 1.0, curve: Curves.easeOut)));

    // 3. 배경 이미지 확대 효과
    _introScale = Tween<double>(begin: 1.05, end: 1.0).animate(CurvedAnimation(
        parent: _c, curve: const Interval(0.0, 1.0, curve: Curves.easeOut)));

    // ✅ 4. 블러 효과 (처음엔 10.0으로 흐리게 -> 0.0으로 선명하게)
    // 0.0 ~ 0.6 구간 동안 진행됩니다. (약 1.8초 동안 선명해짐)
    _introBlur = Tween<double>(begin: 10.0, end: 0.0).animate(CurvedAnimation(
        parent: _c, curve: const Interval(0.0, 0.6, curve: Curves.easeOut)));

    // ✅ 5. 텍스트 등장 (블러가 거의 끝날 때쯤 나타남)
    // 0.6 ~ 1.0 구간 동안 나타납니다.
    _textIntroOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _c, curve: const Interval(0.6, 1.0, curve: Curves.easeIn)));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await precacheImage(heroImage1, context);
      } catch (e) {
        debugPrint("$e");
      }
      // 인트로 애니메이션 자동 시작
      if (mounted) _c.forward();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _enter() {
    if (_c.value < 0.6) return;

    if (_isEntering) return;

    setState(() {
      _isEntering = true;
    });

    _audioManager.toggleMusic();

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _showIntro = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // ✅ 1. 메인 스크롤뷰 (뒤에 숨어있음)
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _ResponsiveWrapper(
                  child: AspectRatio(
                    aspectRatio: 9 / 16,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image(image: heroImage1, fit: BoxFit.contain),
                        Container(color: Colors.black.withValues(alpha: 0.18)),
                        Positioned(
                          left: 20, right: 20, bottom: 24,
                          child: _MainHeroText(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _ResponsiveWrapper(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.children),
                  ),
                ),
              ),
            ],
          ),

          if (_showIntro)
            Positioned.fill(
              child: GestureDetector(
                onTap: _enter,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: _isEntering ? 0.0 : 1.0,
                  child: AnimatedBuilder(
                    animation: _c,
                    builder: (context, _) {
                      return _ResponsiveWrapper(
                        isOverlay: true,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Transform.scale(
                              scale: _introScale.value,
                              child: Image(image: heroImage2, fit: BoxFit.cover),
                            ),

                            Container(color: Colors.black.withValues(alpha: 0.3)),

                            if (_introBlur.value > 0.01)
                              BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: _introBlur.value,
                                  sigmaY: _introBlur.value,
                                ),
                                child: Container(color: Colors.transparent),
                              ),
                            Positioned(
                                left: 0,
                                right: 0,
                                bottom: 150.h,
                                child: _IntroTitle()
                            ),
                            Positioned(
                              bottom: 50.h,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Opacity(
                                  opacity: _textIntroOpacity.value, // 블러가 끝나갈 때쯤 0 -> 1
                                  child: Column(
                                    children: [
                                      Text(
                                        '화면을 터치하여 입장하기',
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.9),
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      SizedBox(height: 8.h),
                                      Icon(
                                        Icons.touch_app,
                                        color: Colors.white.withValues(alpha: 0.7),
                                        size: 20.sp,
                                      )
                                    ],
                                  ),
                                ),
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
                fontSize: 50.sp,
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("김수길 ❤️ 유연정",
            style: TextStyle(
                fontSize: 28.sp, height: 1.1, color: Colors.white)),
        SizedBox(height: 8.h),
        Text("We Are Getting Married",
            style: TextStyle(
                fontSize: 18.sp, color: Colors.white.withValues(alpha: 0.9))),
        SizedBox(height: 10.h),
        Container(
            height: 1,
            width: 140.w,
            color: Colors.white.withValues(alpha: 0.45)),
        SizedBox(height: 10.h),
        Text("2026. 06. 14",
            style: TextStyle(
                fontSize: 11.sp,
                color: Colors.white.withValues(alpha: 0.75))),
      ],
    );
  }
}