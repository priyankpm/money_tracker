import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:money_tracker/app/models/user_model.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/firestore_utils.dart';
import 'package:money_tracker/utils/snackbar.dart';

class ProfileController extends GetxController {
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  var isLoading = false.obs;

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  initData() async {
    userModel = (await FireStoreUtils.getUserProfile()).obs;
    fNameController.text = userModel.value?.firstname ?? "";
    lNameController.text = userModel.value?.lastname ?? "";
    mobileController.text = userModel.value?.phoneNumber ?? "";
    emailController.text = userModel.value?.email ?? "";
    update();
  }

  Future<void> updateProfile() async {
    try {
      if (fNameController.text.isEmpty) {
        CommonSnackbar.showSnackbar(
          message: AppText.pleaseAddFName,
          type: SnackbarType.error,
        );
        return;
      }
      if (fNameController.text.isEmpty) {
        CommonSnackbar.showSnackbar(
          message: AppText.pleaseAddLName,
          type: SnackbarType.error,
        );
        return;
      }

      isLoading.value = true;
      bool isUpdated = await FireStoreUtils.updateUser({
        'firstname': fNameController.text,
        'lastname': lNameController.text,
        'email': emailController.text,
        'phoneNumber': mobileController.text,
      });

      if (isUpdated) {
        CommonSnackbar.showSnackbar(
          message: AppText.updateSuccess,
          type: SnackbarType.success,
        );



      } else {
        CommonSnackbar.showSnackbar(
          message: AppText.updateFailed,
          type: SnackbarType.error,
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
