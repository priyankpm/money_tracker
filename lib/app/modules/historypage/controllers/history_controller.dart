import 'package:get/get.dart';
import 'package:money_tracker/app/models/transaction_model.dart';
import 'package:money_tracker/utils/firestore_utils.dart';

class HistoryController extends GetxController {
  RxString type = "Income".obs;
  List<String> types = ["Income", "Expense"];
  final count = 0.obs;
  var isLoading = false.obs;
  var isExpanded = false.obs;
  var selectedFilter = "All".obs;
  RxList<TransactionModel> incomeTransaction = <TransactionModel>[].obs;
  RxList<TransactionModel> expenseTransaction = <TransactionModel>[].obs;

  updateType(value) => type.value = value;
  final filters = [
    "All",
    "Today",
    "Yesterday",
    "This Week",
    "This Month",
    "This Year",
  ];

  @override
  void onInit() {
    getIncomes();
    getExpense();
    super.onInit();
  }

  Future<void> getIncomes() async {
    isLoading.value = true;
    incomeTransaction.value = (await FireStoreUtils.getAllIncomes() ?? []);
    isLoading.value = false;
  }

  Future<void> getExpense() async {
    isLoading.value = true;
    expenseTransaction.value =
        (await FireStoreUtils.getTodayTransaction() ?? []);
    isLoading.value = false;
  }
}
