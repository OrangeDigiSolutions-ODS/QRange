import "package:share_plus/share_plus.dart";
import "package:url_launcher/url_launcher.dart";

class Menu {
  static void privacyPolicy() {
    launch("https://www.websitepolicies.com/policies/view/8OziI866");
  }

  static void rateus() {
    launch(
        "https://play.google.com/store/apps/details?id=com.orangedigi.qrcode");
  }

  static void aboutus() {
    launch("https://www.orangedigisolutions.com");
  }

  static void contactus() {
    launch("https://www.orangedigisolutions.com/contact-us");
  }

  static void share() {
    Share.share(
        "https://play.google.com/store/apps/details?id=com.orangedigi.qrcode");
  }
}
