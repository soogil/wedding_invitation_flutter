import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wedding/feature/home/presentation/main/wedding_announcement_page.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: '/weddingAnnounce',
    routes: [
      GoRoute(
        path: '/weddingAnnounce',
        name: 'weddingAnnounce',
        builder: (context, state) => const WeddingAnnouncementPage(),
      ),
      // GoRoute(
      //   path: '/home',
      //   name: 'home',
      //   builder: (context, state) => const HomePage(),
      // ),
    ],
    // 異뷀썑 redirect, home guard ??異붽? 媛??
  );
}
