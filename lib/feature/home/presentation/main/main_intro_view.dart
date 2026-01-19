import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MainIntroView extends StatefulWidget {
  const MainIntroView({super.key, required this.children});

  final List<Widget> children;

  @override
  State<MainIntroView> createState() =>
      _MainIntroViewState();
}

class _MainIntroViewState extends State<MainIntroView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _introOpacity;
  late final Animation<double> _mainOpacity;
  late final Animation<double> _introScale;
  late final Animation<double> _introBlur;

  bool _showIntro = true;
  final ImageProvider heroImage1 = const AssetImage('assets/hero1.jpg');
  final ImageProvider heroImage2 = const AssetImage('assets/hero2.jpg');

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5500),
    );

    _introOpacity = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(parent: _c, curve: const Interval(0.45, 1.0, curve: Curves.easeOut)));
    _mainOpacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _c, curve: const Interval(0.10, 0.65, curve: Curves.easeOut)));
    _introScale = Tween<double>(begin: 1.05, end: 1.0).animate(CurvedAnimation(parent: _c, curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic)));
    _introBlur = Tween<double>(begin: 6.0, end: 0.0).animate(CurvedAnimation(parent: _c, curve: const Interval(0.0, 0.55, curve: Curves.easeOut)));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try { await precacheImage(heroImage1, context); } catch (e) { debugPrint("$e"); }
      if (mounted) {
        _c.forward().whenComplete(() => setState(() => _showIntro = false));
      }
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 배경색: 웹이면 회색(여백), 앱이면 베이지
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          // ✅ 1. 메인 스크롤뷰 (화면 전체를 차지함 -> 스크롤바가 우측 끝에 붙음)
          AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              return Opacity(
                opacity: _mainOpacity.value,
                child: CustomScrollView(
                  slivers: [
                    // 히어로 이미지
                    SliverToBoxAdapter(
                      child: _ResponsiveWrapper(
                        child: AspectRatio(
                          aspectRatio: 9 / 16,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image(image: heroImage1, fit: BoxFit.contain),
                              Container(
                                  color: Colors.black.withValues(alpha: 0.18)),
                              const Positioned(
                                left: 20, right: 20, bottom: 24,
                                child: _MainHeroText(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // 텍스트 내용
                    SliverToBoxAdapter(
                      child: _ResponsiveWrapper(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: widget.children
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // ✅ 2. 인트로 오버레이
          if (_showIntro)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: AnimatedBuilder(
                  animation: _c,
                  builder: (context, _) {
                    return Opacity(
                      opacity: _introOpacity.value,
                      child: _ResponsiveWrapper(
                        isOverlay: true, // 오버레이용 설정
                        child: Transform.scale(
                          scale: _introScale.value,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image(image: heroImage2, fit: BoxFit.cover),
                              Container(color: Colors.black.withValues(alpha: 0.25)),
                              if (_introBlur.value > 0.1)
                                BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: _introBlur.value,
                                    sigmaY: _introBlur.value,
                                  ),
                                  child: Container(color: Colors.transparent),
                                ),
                              Center(
                                child: _IntroTitle(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// ✅ 핵심: 화면 중앙에 480px 너비로 컨텐츠를 가둬주는 래퍼 위젯
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
          const SizedBox(height: 450),
          Transform.rotate(
            angle: -0.15,
              child: Text("We Are\nGetting Married", style: GoogleFonts.indieFlower(
                fontSize: 55,
            ),),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _MainHeroText extends StatelessWidget {
  const _MainHeroText();

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("김수길 ❤️ 유연정", style: TextStyle(fontSize: 28, height: 1.1)),
          const SizedBox(height: 8),
          Text("We Are Getting Married", style: TextStyle(fontSize: 18, color: Colors.white.withValues(alpha: 0.9))),
          const SizedBox(height: 10),
          Container(height: 1, width: 140, color: Colors.white.withValues(alpha: 0.45)),
          const SizedBox(height: 10),
          Text("2026. 06. 14", style: TextStyle(color: Colors.white.withValues(alpha: 0.75))),
        ],
      ),
    );
  }
}