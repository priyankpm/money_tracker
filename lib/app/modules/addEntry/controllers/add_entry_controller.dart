import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final amountController = TextEditingController();
  final descriptionController = TextEditingController();
  var dateController =
      TextEditingController(
        text: DateFormat('EEE, dd MMM yyyy').format(DateTime.now()),
      ).obs;
  RxString type = "Income".obs;
  RxString imageUrl = "".obs;
  List<String> types = ["Income", "Expense"];
  var isLoading = false.obs;
  var deleteLoading = false.obs;
  var categoryLoading = false.obs;
  var getCategoryLoading = false.obs;
  RxList<CategoryModel> categoryModel = <CategoryModel>[].obs;
  Rxn<TransactionModel> selectedModel = Rxn<TransactionModel>();
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  Rx<File?> file = Rx<File?>(null);
  RxString selectedIcon = "".obs;
  RxString icon = "".obs;

  Rxn<CategoryModel> selectedCategory = Rxn<CategoryModel>();
  Rxn<CategoryModel> tempSelectedCategory = Rxn<CategoryModel>();

  final categoryIcons = [
    "🍔",
    "🛒",
    "🚗",
    "⛽",
    "🎬",
    "🎮",
    "💡",
    "🏠",
    "📱",
    "💊",
    "🎓",
    "🛍️",
    "👕",
    "💆",
    "🏋️",
    "🎁",
    "✈️",
    "💼",
  ];

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  updateFields() {
    if (Get.arguments != null) {
      selectedModel.value = Get.arguments["selectedData"];
      type.value = Get.arguments["selectedData"].type ?? "Income";
      imageUrl.value = Get.arguments["selectedData"].attachment ?? "";
      amountController.text = Get.arguments["selectedData"].amount ?? "";
      // categoryController.text = Get.arguments["selectedData"].category ?? "";
      descriptionController.text = Get.arguments["selectedData"].note ?? "";
      dateController =
          TextEditingController(
            text: DateFormat(
              'EEE, dd MMM yyyy',
            ).format(Get.arguments["selectedData"].date ?? DateTime.now()),
          ).obs;
    }
  }

  initData() async {
    userModel = (await FireStoreUtils.getUserProfile()).obs;
    await getAllCategory();

    if (Get.arguments != null) {
      final selectedData = categoryModel.where(
        (element) => element.title == Get.arguments["selectedData"].category,
      );
      if (selectedData.isNotEmpty) {
        selectedCategory.value = selectedData.first;
      }
    }
  }

  Future<void> getAllCategory() async {
    getCategoryLoading.value = true;
    categoryModel.value = (await FireStoreUtils.getAllCategory() ?? []);
    getCategoryLoading.value = false;
  }

  updateType(value) => type.value = value;

  updateSelectedIcon(value) => selectedIcon.value = value;

  updateSelectedCategory(value) {
    return tempSelectedCategory.value = value;
  }

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

    if (selectedCategory.value == null) {
      CommonSnackbar.showSnackbar(
        message: AppText.pleaseAddCategory,
        type: SnackbarType.error,
      );
      return;
    }

    if (amountController.text.isEmpty) {
      CommonSnackbar.showSnackbar(
        message: AppText.pleaseAddAmount,
        type: SnackbarType.error,
      );
      return;
    }

    try {
      isLoading.value = true;

      String docId = await FireStoreUtils.createTransaction();

      String url = "";

      if (file.value != null) {
        url = await uploadFile(docId) ?? "";
      }

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
        'category': selectedCategory.value?.title,
        'note': descriptionController.text,
        'date': dateTimeWithCurrentTime,
        'amount': amountController.value.text,
        'uid': FireStoreUtils.getCurrentUid(),
        'attachment': url,
      }, docId);

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
      if (selectedCategory.value == null) {
        CommonSnackbar.showSnackbar(
          message: AppText.pleaseAddCategory,
          type: SnackbarType.error,
        );
        return;
      }

      isLoading.value = true;

      String url = imageUrl.value;

      if (file.value != null) {
        url = await uploadFile(selectedModel.value?.id ?? "") ?? "";
      }

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
        'category': selectedCategory.value?.title,
        'note': descriptionController.text,
        'date': dateTimeWithCurrentTime,
        'amount': amountController.value.text,
        'uid': FireStoreUtils.getCurrentUid(),
        'attachment': url,
      }, selectedModel.value?.id ?? "");

      if (isAdded) {
        if (type.value.toLowerCase() == 'income') {
          final totalBalance =
              (double.parse(userModel.value?.totalIncome.toString() ?? '0.0') -
                  double.parse(
                    selectedModel.value?.amount.toString() ?? '0.0',
                  )) +
              double.parse(amountController.value.text);
          await FireStoreUtils.updateUser({'totalIncome': totalBalance});
        } else {
          final totalBalance =
              (double.parse(userModel.value?.totalExpense.toString() ?? '0.0') -
                  double.parse(
                    selectedModel.value?.amount.toString() ?? '0.0',
                  )) +
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

  Future<void> addCategory(String title, String icon) async {
    try {
      categoryLoading.value = true;

      bool isAdded = await FireStoreUtils.addCategory({
        'title': title,
        'icon': icon,
        'date': DateTime.now(),
      });

      if (isAdded) {
        CommonSnackbar.showSnackbar(
          message: AppText.addCategorySuccess,
          type: SnackbarType.success,
        );
        categoryModel.value = (await FireStoreUtils.getAllCategory() ?? []);
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
              (double.parse(userModel.value?.totalIncome.toString() ?? '0.0') -
                  double.parse(
                    selectedModel.value?.amount.toString() ?? '0.0',
                  ));
          await FireStoreUtils.updateUser({'totalIncome': totalBalance});
        } else {
          final totalBalance =
              (double.parse(userModel.value?.totalExpense.toString() ?? '0.0') -
                  double.parse(
                    selectedModel.value?.amount.toString() ?? '0.0',
                  ));
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

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
    );
    if (result != null && result.files.single.path != null) {
      file.value = File(result.files.single.path!);
    }
  }

  Future<String?> uploadFile(String id) async {
    try {
      String userId = FireStoreUtils.getCurrentUid();
      final ref = _storage.ref().child(
        '$userId/${id}_attachment.${file.value!.path.split(".").last}',
      );
      await ref.putFile(file.value!);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}
