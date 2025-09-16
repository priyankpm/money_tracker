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
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 287.h,
                    width: 414.w,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.headerImage),
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
                    bottom: -65.h,
                    child: Container(
                      height: 150.h,
                      width: 150.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppImages.avtar),
                          fit: BoxFit.fill,
                        ),
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
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 22.w,
                    right: 22.w,
                    top: 100.h,
                    bottom: 10.h,
                  ),
                  child: Column(
                    children: [
                      AppTextField(
                        controller: controller.emailController,
                        labelText: "Email",
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 30.h),
                        child: AppTextField(
                          controller: controller.nameController,
                          labelText: "Name",
                        ),
                      ),
                      AppTextField(
                        textInputType: TextInputType.number,
                        controller: controller.mobileController,
                        labelText: "Mobile number",
                      ),
                      Spacer(),
                      AppButton(
                        zeroPadding: true,
                        child: Center(
                          child: AppText.updateProfile.styleMedium(
                            color: AppColors.whiteColor,
                          ),
                        ),
                      ),
                      30.h.addHSpace(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
