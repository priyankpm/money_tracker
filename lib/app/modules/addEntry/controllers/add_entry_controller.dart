import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/app/models/category_model.dart';
import 'package:money_tracker/app/models/transaction_model.dart';
import 'package:money_tracker/app/models/user_model.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/firestore_utils.dart';
import 'package:money_tracker/utils/snackbar.dart';

class AddEntryController extends GetxController {
  final amountController = TextEditingController();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  var dateController = TextEditingController(text: DateFormat('EEE, dd MMM yyyy').format(DateTime.now()),).obs;
  RxString type = "Income".obs;
  List<String> types = ["Income", "Expense"];
  var isLoading = false.obs;
  var deleteLoading = false.obs;
  var categoryLoading = false.obs;
  var getCategoryLoading = false.obs;
  RxList<CategoryModel> categoryModel = <CategoryModel>[].obs;
  Rxn<TransactionModel> selectedModel = Rxn<TransactionModel>();
  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  initData() async {
    userModel = (await FireStoreUtils.getUserProfile()).obs;
    getAllCategory();
  }

  Future<void> getAllCategory() async {
    getCategoryLoading.value = true;
    categoryModel.value = (await FireStoreUtils.getAllCategory() ?? []);
    getCategoryLoading.value = false;
  }

  updateType(value) => type.value = value;

  Future<void> pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateFormat(
        'EEE, dd MMM yyyy',
      ).parse(dateController.value.text),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF1B183E),
              onPrimary: AppColors.whiteColor,
              onSurface: AppColors.blackColor,
            ),
            dialogTheme: DialogThemeData(backgroundColor: AppColors.whiteColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      dateController.value.text = DateFormat('EEE, dd MMM yyyy').format(picked);
    }
  }

  Future<void> addTransaction() async {
    if (Get.arguments != null) {
      await updateTransaction();
      return;
    }

    if (amountController.text.isEmpty) {
      CommonSnackbar.showSnackbar(
        message: AppText.pleaseAddAmount,
        type: SnackbarType.error,
      );
      return;
    }
    if (titleController.text.isEmpty) {
      CommonSnackbar.showSnackbar(
        message: AppText.pleaseAddCategory,
        type: SnackbarType.error,
      );
      return;
    }

    try {
      isLoading.value = true;

      DateTime selectedDate = DateFormat(
        'EEE, dd MMM yyyy',
      ).parse(dateController.value.text);
      final now = DateTime.now();

      final dateTimeWithCurrentTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        now.hour,
        now.minute,
        now.second,
      );

      bool isAdded = await FireStoreUtils.addTransaction({
        'type': type.value,
        'category': titleController.text,
        'note': descriptionController.text,
        'date': dateTimeWithCurrentTime,
        'amount': amountController.value.text,
        'uid': FireStoreUtils.getCurrentUid(),
      });

      if (isAdded) {
        if (type.value.toLowerCase() == 'income') {
          final totalBalance =
              double.parse(userModel.value?.totalIncome.toString() ?? '0.0') +
                  double.parse(amountController.value.text);
          await FireStoreUtils.updateUser({'totalIncome': totalBalance});
        } else {
          final totalBalance =
              double.parse(userModel.value?.totalExpense.toString() ?? '0.0') +
                  double.parse(amountController.value.text);
          await FireStoreUtils.updateUser({'totalExpense': totalBalance});
        }

        CommonSnackbar.showSnackbar(
          message: AppText.addTransactionSuccess,
          type: SnackbarType.success,
        );

        Get.back(result: true);

      } else {
        CommonSnackbar.showSnackbar(
          message: AppText.addTransactionFailed,
          type: SnackbarType.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateTransaction() async {
    try {
      if (amountController.text.isEmpty) {
        CommonSnackbar.showSnackbar(
          message: AppText.pleaseAddAmount,
          type: SnackbarType.error,
        );
        return;
      }
      if (titleController.text.isEmpty) {
        CommonSnackbar.showSnackbar(
          message: AppText.pleaseAddCategory,
          type: SnackbarType.error,
        );
        return;
      }

      isLoading.value = true;

      DateTime selectedDate = DateFormat(
        'EEE, dd MMM yyyy',
      ).parse(dateController.value.text);
      final now = DateTime.now();

      final dateTimeWithCurrentTime = DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        now.hour,
        now.minute,
        now.second,
      );

      bool isAdded = await FireStoreUtils.updateTransaction({
        'type': type.value,
        'category': titleController.text,
        'note': descriptionController.text,
        'date': dateTimeWithCurrentTime,
        'amount': amountController.value.text,
        'uid': FireStoreUtils.getCurrentUid(),
      }, selectedModel.value?.id ?? "");

      if (isAdded) {
        if (type.value.toLowerCase() == 'income') {
          final totalBalance =
              (double.parse(userModel.value?.totalIncome.toString() ?? '0.0') - double.parse(selectedModel.value?.amount.toString() ?? '0.0')) +
                  double.parse(amountController.value.text);
          await FireStoreUtils.updateUser({'totalIncome': totalBalance});
        } else {
          final totalBalance =
              (double.parse(userModel.value?.totalExpense.toString() ?? '0.0') - double.parse(selectedModel.value?.amount.toString() ?? '0.0')) +
                  double.parse(amountController.value.text);

          await FireStoreUtils.updateUser({'totalExpense': totalBalance});
        }
        CommonSnackbar.showSnackbar(
          message: AppText.addTransactionSuccess,
          type: SnackbarType.success,
        );
        Get.back(result: true);
      } else {
        CommonSnackbar.showSnackbar(
          message: AppText.addTransactionFailed,
          type: SnackbarType.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addCategory(String title) async {
    try {
      categoryLoading.value = true;

      bool isAdded = await FireStoreUtils.addCategory({
        'title': title,
        'date': DateTime.now(),
      });

      if (isAdded) {
        CommonSnackbar.showSnackbar(
          message: AppText.addCategorySuccess,
          type: SnackbarType.success,
        );
        getAllCategory();
      } else {
        CommonSnackbar.showSnackbar(
          message: AppText.addCategoryFailed,
          type: SnackbarType.error,
        );
      }
    } finally {
      categoryLoading.value = false;
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      deleteLoading.value = true;

      bool isAdded = await FireStoreUtils.deleteTransaction(id);

      if (isAdded) {

        if (type.value.toLowerCase() == 'income') {
          final totalBalance =
              (double.parse(userModel.value?.totalIncome.toString() ?? '0.0') - double.parse(selectedModel.value?.amount.toString() ?? '0.0'));
          await FireStoreUtils.updateUser({'totalIncome': totalBalance});
        } else {
          final totalBalance =
              (double.parse(userModel.value?.totalExpense.toString() ?? '0.0') - double.parse(selectedModel.value?.amount.toString() ?? '0.0'));

          await FireStoreUtils.updateUser({'totalExpense': totalBalance});
        }

        Get.back(result: true);

        CommonSnackbar.showSnackbar(
          message: AppText.deleteTransactionSuccess,
          type: SnackbarType.success,
        );
        getAllCategory();
      } else {
        CommonSnackbar.showSnackbar(
          message: AppText.deleteTransactionFailed,
          type: SnackbarType.error,
        );
      }
    } finally {
      deleteLoading.value = false;
    }
  }
}
