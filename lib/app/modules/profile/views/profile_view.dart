import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:money_tracker/app/modules/profile/controllers/profile_controller.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/config/app_images.dart';
import 'package:money_tracker/config/app_loader.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/buttons.dart';
import 'package:money_tracker/utils/extenstion.dart';
import 'package:money_tracker/utils/firestore_utils.dart';
import 'package:money_tracker/utils/textfield.dart';
import 'package:shimmer/shimmer.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      dispose: (state) {
        controller.clearValue();
      },
      builder: (controller) {
        return Container(
          color: AppColors.whiteColor,
          child: SafeArea(
            top: false,
            child: Scaffold(
              backgroundColor: AppColors.whiteColor,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SizedBox(
                          height: 325.h,
                          child: Column(
                            children: [
                              Container(
                                height: 255.h,
                                width: 414.w,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(AppImages.profileBanner),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: AppBar(
                                  actions: [
                                    PopupMenuButton(
                                      color: AppColors.whiteColor,
                                      icon: Icon(
                                        Icons.more_vert,
                                        color: AppColors.whiteColor,
                                      ),
                                      itemBuilder:
                                          (context) => [
                                            PopupMenuItem(
                                              onTap: () async {
                                                Future.delayed(
                                                  Duration(milliseconds: 100),
                                                ).then((value) {
                                                  if (context.mounted) {
                                                    showLogoutConfirmationDialog(
                                                      context,
                                                    );
                                                  }
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  right: 22.w,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.exit_to_app,
                                                      color:
                                                          AppColors
                                                              .primaryColor,
                                                    ),
                                                    10.w.addWSpace(),
                                                    AppText.logout.styleMedium(
                                                      color:
                                                          AppColors
                                                              .primaryColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              onTap: () async {
                                                Future.delayed(
                                                  Duration(milliseconds: 100),
                                                ).then((value) {
                                                  if (context.mounted) {
                                                    showDeleteUserDialog(
                                                      context,
                                                    );
                                                  }
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  right: 22.w,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.delete,
                                                      color:
                                                          AppColors
                                                              .primaryColor,
                                                    ),
                                                    10.w.addWSpace(),
                                                    AppText.deleteAccount
                                                        .styleMedium(
                                                          color:
                                                              AppColors
                                                                  .primaryColor,
                                                        ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              onTap: () async {
                                                Future.delayed(
                                                  Duration(milliseconds: 100),
                                                ).then((value) {
                                                  Get.back();
                                                });
                                              },
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  right: 22.w,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.close,
                                                      color:
                                                          AppColors
                                                              .primaryColor,
                                                    ),
                                                    10.w.addWSpace(),
                                                    AppText.close.styleMedium(
                                                      color:
                                                          AppColors
                                                              .primaryColor,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                    ),
                                  ],
                                  surfaceTintColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                  centerTitle: true,
                                  title: AppText.profile.styleSemiBold(
                                    size: 20.sp,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Positioned(
                          right: 132.w,
                          left: 132.w,
                          bottom: 20.h,
                          child: Center(
                            child: Container(
                              height: 120.h,
                              width: 120.h,
                              decoration: BoxDecoration(
                                color: AppColors.whiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryColor.withValues(
                                      alpha: 0.3,
                                    ),
                                    blurRadius: 10,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                                shape: BoxShape.circle,
                              ),
                              child:
                                  controller.imageFile.value != null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          200.r,
                                        ),
                                        child: Image.file(
                                          controller.imageFile.value!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                      : (controller.userModel.value?.photoURL ??
                                              "")
                                          .isEmpty
                                      ? capitalizeWord()
                                      : ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          200.r,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              controller
                                                  .userModel
                                                  .value
                                                  ?.photoURL ??
                                              "",
                                          fit: BoxFit.cover,
                                          placeholder:
                                              (context, url) =>
                                                  Shimmer.fromColors(
                                                    baseColor:
                                                        AppColors.primaryColor,
                                                    highlightColor: AppColors
                                                        .primaryColor
                                                        .withValues(alpha: 0.7),
                                                    child: Container(
                                                      width: double.infinity,
                                                      height: double.infinity,
                                                      color: AppColors
                                                          .primaryColor
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                    ),
                                                  ),
                                          errorWidget:
                                              (context, url, error) =>
                                                  capitalizeWord(),
                                        ),
                                      ),
                            ),
                          ),
                        ),

                        Positioned(
                          bottom: 5.h,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                showImagePickerSheet(context);
                              },
                              child: Container(
                                height: 35.h,
                                width: 35.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20.r),
                                  border: Border.all(
                                    color: AppColors.primaryColor,
                                  ),
                                  color: AppColors.primaryColor,
                                ),
                                child: Icon(
                                  Icons.camera,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.fName.styleMedium(size: 14.sp),
                          5.h.addHSpace(),
                          AppTextField(
                            controller: controller.fNameController,
                            labelText: AppText.enterHere,
                          ),
                          15.h.addHSpace(),
                          AppText.lName.styleMedium(size: 14.sp),
                          5.h.addHSpace(),
                          AppTextField(
                            controller: controller.lNameController,
                            labelText: AppText.enterHere,
                          ),
                          15.h.addHSpace(),
                          AppText.email.styleMedium(size: 14.sp),
                          5.h.addHSpace(),
                          AppTextField(
                            readonly: true,
                            suffix: Icon(
                              Icons.lock,
                              color: AppColors.primaryColor,
                            ),
                            controller: controller.emailController,
                            labelText: AppText.enterHere,
                          ),
                          15.h.addHSpace(),
                          AppText.phoneNumber.styleMedium(size: 14.sp),
                          5.h.addHSpace(),
                          AppTextField(
                            textInputType: TextInputType.number,
                            controller: controller.mobileController,
                            labelText: AppText.enterHere,
                          ),
                          30.h.addHSpace(),
                          Obx(() {
                            return AppButton(
                              onTap:
                                  controller.isLoading.value
                                      ? null
                                      : () async {
                                        await controller.updateProfile();
                                      },
                              child:
                                  controller.isLoading.value
                                      ? AppLoader.buttonLoader
                                      : Center(
                                        child: AppText.updateProfile
                                            .styleMedium(
                                              color: AppColors.whiteColor,
                                            ),
                                      ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Center capitalizeWord() => Center(
    child: Container(
      height: 110.h,
      width: 110.h,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primaryColor, width: 1.5),
        color: AppColors.whiteColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child:
            "${controller.userModel.value?.firstname[0] ?? controller.userModel.value?.lastname[0]}"
                .styleBold(size: 70.sp, color: AppColors.primaryColor),
      ),
    ),
  );

  Future<void> showLogoutConfirmationDialog(BuildContext context) async {
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: AppText.areYouSure.styleSemiBold(size: 20.sp)),
          content: AppText.logoutMsg.styleMedium(
            overflow: TextOverflow.clip,
            align: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(),
              child: AppText.cancel.styleMedium(color: AppColors.primaryColor),
            ),
            ElevatedButton(
              onPressed: () async {
                Get.back();
                await Future.delayed(Duration(milliseconds: 200)).then((value) {
                  FireStoreUtils.logout();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1B183E),
              ),
              child: AppText.logout.styleMedium(color: AppColors.whiteColor),
            ),
          ],
        );
      },
    );
  }

  Future<void> showDeleteUserDialog(BuildContext context) async {
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: AppText.areYouSure.styleSemiBold(size: 20.sp)),
          content: AppText.deleteUser.styleMedium(
            overflow: TextOverflow.clip,
            align: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(),
              child: AppText.cancel.styleMedium(color: AppColors.primaryColor),
            ),
            ElevatedButton(
              onPressed: () async {
                Get.back();
                await Future.delayed(Duration(milliseconds: 200)).then((value) {
                  FireStoreUtils.deleteUser();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1B183E),
              ),
              child: AppText.deleteAccount.styleMedium(
                color: AppColors.whiteColor,
              ),
            ),
          ],
        );
      },
    );
  }

  void showImagePickerSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: AppColors.primaryColor),
                title: AppText.camera.styleMedium(
                  color: AppColors.primaryColor,
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.photo_library,
                  color: AppColors.primaryColor,
                ),
                title: AppText.gallery.styleMedium(
                  color: AppColors.primaryColor,
                ),
                onTap: () {
                  Navigator.pop(context);
                  controller.pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
