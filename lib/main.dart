import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wedding/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wedding/core/util/bgm_player.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AudioManager().init();

  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return ScreenUtilInit(
      designSize: const Size(480, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp.router(
            title: '김수길 ❤️ 유연정의 결혼 알림장',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
              fontFamily: 'Bareun'
            ),
            builder: (context, child) {
              final double actualWidth = MediaQuery.of(context).size.width;

              // PC 웹에서 화면을 늘려도 480px일 때의 글자 크기로 고정됩니다.
              final double scale = actualWidth > 480
                  ? (480 / actualWidth)
                  : 1.0;

              // 계산된 비율을 전체 앱에 적용
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaler: TextScaler.linear(scale),
                ),
                child: child!,
              );
            },
            routerConfig: router,
          );
      },
    );
    // return MaterialApp.router(
    //   title: 'Flutter Demo',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    //     useMaterial3: true,
    //   ),
    //   routerConfig: router,
    // );
  }
}
