import 'package:get/get.dart';
import 'package:money_tracker/app/routes/app_pages.dart';
import 'package:money_tracker/utils/shared_prefs.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    navigateToOnboard();
    super.onInit();
  }

  Future<void> navigateToOnboard() async {
    await Future.delayed(const Duration(seconds: 2)).then((value) async {
      final bool isLoggedIn =
          SharedPreference().getBool(SharedPreference.IS_LOGGED_IN) ?? false;
      if (isLoggedIn) {
        return Get.offAllNamed(Routes.BOTTOMBAR);
      } else {
        return Get.toNamed(Routes.INTRO);
      }
    });
  }
}
