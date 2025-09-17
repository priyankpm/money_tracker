import 'package:get/get.dart';

class HistoryController extends GetxController {
  RxString type = "Income".obs;
  List<String> types = ["Income", "Expense"];

  updateType(value) => type.value = value;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
