import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedding/core/util/bgm_player.dart';


class SplashScreen extends StatefulWidget {
  final Widget child;

  const SplashScreen({super.key, required this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  bool _isInitialized = false;
  late AnimationController _fadeController;

  // 인트로 화면에 필요한 필수 이미지만 프리로드
  static const List<String> _criticalAssets = [
    'assets/hero2.jpg', // 인트로 배경 이미지
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // didChangeDependencies는 여러 번 호출될 수 있으므로 한 번만 실행
    if (!_isInitialized) {
      _isInitialized = true;
      _initializeApp();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _initializeApp() async {
    try {
      // 오디오 초기화 (백그라운드)
      AudioManager().init().catchError((e) {
        debugPrint('AudioManager init error: $e');
      });

      // 이미지 프리캐시 (백그라운드)
      _precacheCriticalImages();

      // 스플래시 화면 최소 표시 시간 (로딩 인디케이터가 보이도록)
      await Future.delayed(const Duration(milliseconds: 1500));
    } catch (e) {
      debugPrint('SplashScreen init error: $e');
    }

    // 에러가 발생해도 반드시 메인 화면으로 전환
    if (mounted) {
      try {
        await _fadeController.forward();
      } catch (e) {
        debugPrint('Animation error: $e');
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _precacheCriticalImages() async {
    for (final asset in _criticalAssets) {
      try {
        await precacheImage(AssetImage(asset), context);
      } catch (e) {
        debugPrint('Failed to precache $asset: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoading) {
      return widget.child;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF6F2EA),
      body: Center(
        child: AnimatedBuilder(
          animation: _fadeController,
          builder: (context, child) {
            return Opacity(
              opacity: 1.0 - _fadeController.value,
              child: child,
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 하트 아이콘
              Icon(
                Icons.favorite,
                size: 60.sp,
                color: Colors.pink[300],
              ),
              SizedBox(height: 24.h),
              // 타이틀
              Text(
                '김수길 ❤️ 유연정',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'We Are Getting Married',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  fontFamily: 'IndieFlower',
                ),
              ),
              SizedBox(height: 48.h),
              SizedBox(
                width: 36,
                height: 36,
                child: CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.pink[300]!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
