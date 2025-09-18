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
    expenseTransaction.value = (await FireStoreUtils.getAllExpense() ?? []);
    isLoading.value = false;
  }

  RxList<TransactionModel> get filteredTransactions {
    if (selectedFilter.value == "All") {
      if(type.value.toLowerCase() == 'income'){
        return incomeTransaction;
      }else{
        return expenseTransaction;
      }
    }

    final now = DateTime.now();
    RxList<TransactionModel> transactionList = <TransactionModel>[].obs;
    if(type.value.toLowerCase() == 'income'){
      transactionList = incomeTransaction;
    }else{
      transactionList = expenseTransaction;
    }

    return transactionList.where((transaction) {
      final txDate = transaction.date;

      switch (selectedFilter.value) {
        case "Today":
          return txDate.year == now.year &&
              txDate.month == now.month &&
              txDate.day == now.day;

        case "Yesterday":
          final yesterday = now.subtract(const Duration(days: 1));
          return txDate.year == yesterday.year &&
              txDate.month == yesterday.month &&
              txDate.day == yesterday.day;

        case "This Week":
          final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
          final endOfWeek = startOfWeek.add(const Duration(days: 6));
          return txDate.isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
              txDate.isBefore(endOfWeek.add(const Duration(days: 1)));

        case "This Month":
          return txDate.year == now.year && txDate.month == now.month;

        case "This Year":
          return txDate.year == now.year;

        default:
          return true;
      }
    }).toList().obs;
  }

}
