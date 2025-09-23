import 'package:get/get.dart';
import 'package:money_tracker/app/modules/charts/controllers/charts_controller.dart';
import 'package:money_tracker/app/modules/historypage/bindings/history_binding.dart';
import 'package:money_tracker/app/modules/historypage/controllers/history_controller.dart';
import 'package:money_tracker/app/modules/home/controllers/home_controller.dart';
import 'package:money_tracker/app/modules/profile/controllers/profile_controller.dart';

import '../controllers/bottombar_controller.dart';

class BottombarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottombarController>(() => BottombarController());
    Get.put<ProfileController>(ProfileController());
    Get.put<ChartsController>(ChartsController());
    Get.put<HomeController>(HomeController());
    Get.lazyPut<HistoryController>(() => HistoryController());
  }
}
