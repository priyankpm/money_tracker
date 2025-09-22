import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_tracker/app/models/user_model.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/firestore_utils.dart';
import 'package:money_tracker/utils/snackbar.dart';

class ProfileController extends GetxController {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  Rx<UserModel?> userModel = Rx<UserModel?>(null);
  var isLoading = false.obs;
  final ImagePicker _picker = ImagePicker();
  Rx<File?> imageFile = Rx<File?>(null);

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

      String imageUrl = userModel.value?.photoURL ?? "";

      if (imageFile.value != null) {
        imageUrl = await uploadProfileImage() ?? "";
      }

      bool isUpdated = await FireStoreUtils.updateUser({
        'firstname': fNameController.text,
        'lastname': lNameController.text,
        'email': emailController.text,
        'phoneNumber': mobileController.text,
        'photoURL': imageUrl,
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

  clearValue() async {
    userModel = (await FireStoreUtils.getUserProfile()).obs;
    fNameController.text = userModel.value?.firstname ?? "";
    lNameController.text = userModel.value?.lastname ?? "";
    mobileController.text = userModel.value?.phoneNumber ?? "";
    emailController.text = userModel.value?.email ?? "";
    imageFile = Rx<File?>(null);
  }

  Future<void> pickImage(ImageSource type) async {
    final pickedFile = await _picker.pickImage(source: type, imageQuality: 50);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      update();
    }
  }

  Future<String?> uploadProfileImage() async {
    try {
      String userId = FireStoreUtils.getCurrentUid();
      final ref = _storage.ref().child('$userId/profile.jpg');
      await ref.putFile(imageFile.value!);
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }
}
