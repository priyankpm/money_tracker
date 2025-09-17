import 'package:get/get.dart';

import '../controllers/historypage_controller.dart';

class HistorypageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistorypageController>(
      () => HistorypageController(),
    );
  }
}
