enum AppPage {
  weddingAnnounce;
  //...;

  String get path {
    switch (this) {
      case AppPage.weddingAnnounce:
        return '/weddingAnnounce';
      // case AppPage.settings:
      //   return '/settings';
    }
  }

  String get name => toString().split('.').last;
}