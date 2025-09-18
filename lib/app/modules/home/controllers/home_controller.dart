import 'package:get/get.dart';
import 'package:money_tracker/app/models/transaction_model.dart';
import 'package:money_tracker/app/models/user_model.dart';
import 'package:money_tracker/utils/firestore_utils.dart';

class HomeController extends GetxController {
  RxList<TransactionModel> recentTransaction = <TransactionModel>[].obs;
  var isLoading = false.obs;
  Rx<UserModel?> userModel = Rx<UserModel?>(null);

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
    userModel.value = (await FireStoreUtils.getUserProfile());
    recentTransaction.value = (await FireStoreUtils.getTodayTransaction() ?? []);
    isLoading.value = false;
  }
}
