import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:wedding/core/router/app_pages.dart';
import 'package:wedding/core/util/bgm_player.dart';

/// 스플래시 스크린 (HookWidget 적용)
class SplashScreen extends HookWidget {
  const SplashScreen({super.key});

  static const List<String> _criticalAssets = [
    'assets/hero2.jpg', // 인트로 배경 이미지
  ];

  @override
  Widget build(BuildContext context) {
    final fadeController = useAnimationController(
      duration: const Duration(milliseconds: 500),
    );

    final isInitialized = useState(false);

    useEffect(() {
      if (isInitialized.value) return null;
      isInitialized.value = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          AudioManager().init().catchError((e) {
            debugPrint('AudioManager init error: $e');
          });

          for (final asset in _criticalAssets) {
            try {
              await precacheImage(AssetImage(asset), context);
            } catch (e) {
              debugPrint('Failed to precache $asset: $e');
            }
          }
        } catch (e) {
          debugPrint('SplashScreen init error: $e');
        }

        try {
          await fadeController.forward();
        } catch (e) {
          debugPrint('Animation error: $e');
        }

        if (context.mounted) {
          context.go(AppPage.weddingAnnounce.path);
        }
      });
      return null;
    }, const []);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F2EA),
      body: Center(
        child: AnimatedBuilder(
          animation: fadeController,
          builder: (context, child) {
            return Opacity(
              opacity: 1.0 - fadeController.value,
              child: child,
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                size: 60.sp,
                color: Colors.pink[300],
              ),
              SizedBox(height: 24.h),
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
                '모바일 알림장',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
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
