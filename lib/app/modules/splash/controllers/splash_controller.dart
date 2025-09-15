import 'package:get/get.dart';
import 'package:money_tracker/app/routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    navigateToOnboard();
    super.onInit();
  }
  Future<void> navigateToOnboard() async {
    await Future.delayed(
      const Duration(seconds: 2),
    ).then((value) => Get.toNamed(Routes.LOGIN));
  }
}
