import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:wedding/core/router/app_pages.dart';
import 'package:wedding/feature/home/presentation/main/gallery_view.dart';
import 'package:wedding/feature/home/presentation/main/intro_ourselves_view.dart';
import 'package:wedding/feature/home/presentation/main/wedding_announcement_page.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: AppPage.weddingAnnounce.path,
    routes: [
      GoRoute(
        path: AppPage.weddingAnnounce.path,
        name: AppPage.weddingAnnounce.name,
        builder: (context, state) => const WeddingAnnouncementPage(),
      ),
      GoRoute(
        path: AppPage.photo.path,
        name: AppPage.photo.name,
        builder: (context, state) {
          final imagePath = state.uri.queryParameters['path'] ?? '';
          final heroTag = state.uri.queryParameters['tag'] ?? '';

          return SinglePhotoView(
              imagePath: imagePath,
              heroTag: heroTag
          );
        },
      ),
      GoRoute(
        path: AppPage.gallery.path,
        name: AppPage.gallery.name,
        builder: (context, state) {
          final indexStr = state.uri.queryParameters['index'] ?? '0';
          final index = int.parse(indexStr);

          final images = state.extra as List<String>;

          return GalleryPhotoView(
              imageUrls: images,
              initialIndex: index
          );
        },
      ),
      // GoRoute(
      //   path: '/home',
      //   name: 'home',
      //   builder: (context, state) => const HomePage(),
      // ),
    ],
  );
}
