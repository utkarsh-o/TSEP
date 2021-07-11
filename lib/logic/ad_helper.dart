import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // ca-app-pub-3940256099942544/6300978111 - test
      // ca-app-pub-2997176513757522/5644708490 - release
      return 'ca-app-pub-2997176513757522/5644708490';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    throw new UnsupportedError("Unsupported platform");
  }
}
