import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/config/app_images.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/buttons.dart';
import 'package:money_tracker/utils/extenstion.dart';
import 'package:money_tracker/utils/textfield.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
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
                          Padding(
                            padding: EdgeInsets.only(right: 22.w),
                            child: Icon(
                              Icons.exit_to_app,
                              color: AppColors.whiteColor,
                            ),
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

                    Positioned(
                      right: 132.w,
                      left: 132.w,
                      bottom: -50.h,
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
                        child: Center(
                          child: Container(
                            height: 110.h,
                            width: 110.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.primaryColor,
                                width: 1.5,
                              ),
                              color: AppColors.whiteColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: "E".styleBold(
                                size: 70.sp,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 22.w, right: 22.w, top: 60.h),
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
                      AppButton(
                        child: Center(
                          child: AppText.updateProfile.styleMedium(
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
