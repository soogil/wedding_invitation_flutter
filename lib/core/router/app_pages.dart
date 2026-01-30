enum AppPage {
  splash,
  weddingAnnounce,
  photo,
  gallery;

  String get path {
    switch (this) {
      case AppPage.splash:
        return '/';
      case AppPage.weddingAnnounce:
        return '/weddingAnnounce';
      case AppPage.photo:
        return '/photo';
      case AppPage.gallery:
        return '/gallery';
    }
  }

  String get name => toString().split('.').last;
}