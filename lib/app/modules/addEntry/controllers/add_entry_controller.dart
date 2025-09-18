import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
  Rx<UserModel?> userModel = Rx<UserModel?>(null);

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  initData() async {
    userModel = (await FireStoreUtils.getUserProfile()).obs;
    update();
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

      bool isAdded = await FireStoreUtils.addTransaction({
        'type': type.value,
        'category': titleController.text,
        'note': descriptionController.text,
        'date': dateTimeWithCurrentTime,
        'amount': amountController.value.text,
        'uid': FireStoreUtils.getCurrentUid(),
      });

      if(type.value.toLowerCase() == 'income'){
        final totalBalance = (userModel.value?.totalIncome ?? 0.0) + double.parse(amountController.value.text);
        print('===totalBalance====${totalBalance}');
        await FireStoreUtils.updateUser({
          'totalIncome': totalBalance,
        });
      }else{
        final totalBalance = (userModel.value?.totalExpense ?? 0.0) + double.parse(amountController.value.text);
        await FireStoreUtils.updateUser({
          'totalExpense': totalBalance,
        });
      }

      if (isAdded) {
        CommonSnackbar.showSnackbar(
          message: AppText.addTransactionSuccess,
          type: SnackbarType.success,
        );

        Get.back();

        // titleController.clear();
        // descriptionController.clear();
        // amountController.clear();
        // dateController = TextEditingController(text: DateFormat('EEE, dd MMM yyyy').format(DateTime.now()),).obs;
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
}
