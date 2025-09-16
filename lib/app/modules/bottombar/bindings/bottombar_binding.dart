import 'package:get/get.dart';
import 'package:money_tracker/app/modules/home/controllers/home_controller.dart';
import 'package:money_tracker/app/modules/profile/controllers/profile_controller.dart';

import '../controllers/bottombar_controller.dart';

class BottombarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottombarController>(() => BottombarController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
