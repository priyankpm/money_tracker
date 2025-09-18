import 'package:get/get.dart';
import 'package:money_tracker/app/models/transaction_model.dart';
import 'package:money_tracker/utils/firestore_utils.dart';

class HomeController extends GetxController {
  RxList<TransactionModel> recentTransaction = <TransactionModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    getTodayTransaction();
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

  Future<void> getTodayTransaction() async {
    isLoading.value = true;
    recentTransaction.value = (await FireStoreUtils.getTodayTransaction() ?? []);
    isLoading.value = false;
  }
}
