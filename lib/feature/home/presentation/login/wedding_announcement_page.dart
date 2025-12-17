import 'dart:ui';
import 'package:flutter/material.dart';


class WeddingAnnouncementPage extends StatefulWidget {
  const WeddingAnnouncementPage({super.key});

  @override
  State<WeddingAnnouncementPage> createState() =>
      _WeddingAnnouncementPageState();
}

class _WeddingAnnouncementPageState extends State<WeddingAnnouncementPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _introOpacity; // 인트로 사라짐
  late final Animation<double> _mainOpacity;  // 메인 등장
  late final Animation<double> _introScale;   // 인트로 살짝 줌아웃/줌인
  late final Animation<double> _introBlur;    // 인트로 블러 -> 0

  bool _showIntro = true;

  // ✅ 같은 이미지(같은 provider)를 두 레이어에서 공유해야 “이어지는” 느낌이 남
  final ImageProvider heroImage =
  const AssetImage('assets/hero.png');

  @override
  void initState() {
    super.initState();

    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _introOpacity = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _c, curve: const Interval(0.45, 1.0, curve: Curves.easeOut)),
    );

    _mainOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _c, curve: const Interval(0.10, 0.65, curve: Curves.easeOut)),
    );

    _introScale = Tween<double>(begin: 1.05, end: 1.0).animate(
      CurvedAnimation(parent: _c, curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic)),
    );

    _introBlur = Tween<double>(begin: 6.0, end: 0.0).animate(
      CurvedAnimation(parent: _c, curve: const Interval(0.0, 0.55, curve: Curves.easeOut)),
    );

    // ✅ 첫 프레임 전에 이미지 프리로드(깜빡임 방지)
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await precacheImage(heroImage, context);
      _c.forward().whenComplete(() {
        setState(() => _showIntro = false); // 애니 끝나면 인트로 레이어 제거
      });
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F2EA),
      body: Stack(
        children: [
          // ✅ 아래: 메인 컨텐츠
          AnimatedBuilder(
            animation: _c,
            builder: (context, _) {
              return Opacity(
                opacity: _mainOpacity.value,
                child: _MainContent(heroImage: heroImage),
              );
            },
          ),

          // ✅ 위: 인트로 오버레이(풀스크린)
          if (_showIntro)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: AnimatedBuilder(
                  animation: _c,
                  builder: (context, _) {
                    return Opacity(
                      opacity: _introOpacity.value,
                      child: Transform.scale(
                        scale: _introScale.value,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // 배경 이미지
                            Image(
                              image: heroImage,
                              fit: BoxFit.cover,
                            ),

                            // 살짝 어둡게(텍스트 가독성)
                            Container(
                              color: Colors.black.withValues(alpha: 0.25),
                            ),

                            // 블러(감성 + 전환 부드럽게)
                            if (_introBlur.value > 0.1)
                              BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: _introBlur.value,
                                  sigmaY: _introBlur.value,
                                ),
                                child: Container(color: Colors.transparent),
                              ),

                            // 타이틀
                            Center(
                              child: _IntroTitle(
                                line1: "OO & OO",
                                line2: "결혼합니다",
                                dateText: "2026. 06. XX",
                              ),
                            ),
                          ],
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

class _IntroTitle extends StatelessWidget {
  final String line1;
  final String line2;
  final String dateText;

  const _IntroTitle({
    required this.line1,
    required this.line2,
    required this.dateText,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(color: Colors.white),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(line1, style: const TextStyle(fontSize: 30, height: 1.1)),
          const SizedBox(height: 10),
          Text(line2, style: const TextStyle(fontSize: 22, height: 1.1)),
          const SizedBox(height: 16),
          Container(height: 1, width: 160, color: Colors.white.withValues(alpha: 0.5)),
          const SizedBox(height: 12),
          Text(dateText, style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
        ],
      ),
    );
  }
}

class _MainContent extends StatelessWidget {
  final ImageProvider heroImage;
  const _MainContent({required this.heroImage});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // ✅ 메인 첫 섹션: 히어로 이미지
        SliverToBoxAdapter(
          child: AspectRatio(
            aspectRatio: 9 / 16,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image(image: heroImage, fit: BoxFit.cover),
                Container(color: Colors.black.withValues(alpha: 0.18)),
                const Positioned(
                  left: 20,
                  right: 20,
                  bottom: 24,
                  child: _MainHeroText(),
                ),
              ],
            ),
          ),
        ),

        // ✅ 아래로 알림장 내용
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 18),
                Text(
                  "소중한 분들께 결혼 소식을 전합니다.\n"
                      "따뜻한 마음으로 축하해주시면 감사하겠습니다.",
                  style: TextStyle(fontSize: 16, height: 1.7),
                ),
                SizedBox(height: 28),
                // TODO: 갤러리/푸터/연락버튼 등 추가
                SizedBox(height: 500),
              ],
            ),
          ),
        ),
      ],
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
          const Text("OO & OO", style: TextStyle(fontSize: 28, height: 1.1)),
          const SizedBox(height: 8),
          Text("결혼합니다", style: TextStyle(fontSize: 18, color: Colors.white.withValues(alpha: 0.9))),
          const SizedBox(height: 10),
          Container(height: 1, width: 140, color: Colors.white.withValues(alpha: 0.45)),
          const SizedBox(height: 10),
          Text("2026. 06. XX", style: TextStyle(color: Colors.white.withValues(alpha: 0.75))),
        ],
      ),
    );
  }
}
