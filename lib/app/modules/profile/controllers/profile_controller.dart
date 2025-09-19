import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _uploadedImageUrl;
  final String cloudName = 'dqpbmpg4d';
  final String uploadPreset = 'ml_default';

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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      _uploadedImageUrl = null;
      update();
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    final url = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
    );

    final request =
        http.MultipartRequest('POST', url)
          ..fields['upload_preset'] = uploadPreset
          ..files.add(
            await http.MultipartFile.fromPath('file', _imageFile!.path),
          );

    final response = await request.send();

     if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = json.decode(respStr);

      _uploadedImageUrl = responseData['secure_url'];
      update();
    } else {
      print('Upload failed with status: ${response.statusCode}');

      _uploadedImageUrl = null;
      update();
    }
  }
}
