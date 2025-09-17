import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:money_tracker/app/routes/app_pages.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/config/app_images.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/buttons.dart';
import 'package:money_tracker/utils/extenstion.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  children: [
                    Platform.isAndroid
                        ? Container(
                          height: 40.h,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: AppColors.lightPrimaryColor,
                          ),
                        )
                        : SizedBox(),
                    Image.asset(AppImages.loginImage, fit: BoxFit.fill),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: Platform.isAndroid ? 185.h : 225.h,
                    padding: EdgeInsets.symmetric(
                      vertical: 20.h,
                      horizontal: 28.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(40.r),
                        topLeft: Radius.circular(40.r),
                      ),
                    ),
                    child: Column(
                      children: [
                        AppText.signInWithText.styleBold(
                          color: AppColors.whiteColor,
                          size: 22.sp,
                          align: TextAlign.center,
                        ),
                        Spacer(),

                        AppButton(
                          onTap: () {
                            Get.offAllNamed(Routes.BOTTOMBAR);
                          },
                          borderColor: AppColors.whiteColor,
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppImages.googleIcon,
                                  height: 30.h,
                                  width: 30.h,
                                ),
                                10.w.addWSpace(),
                                AppText.loginButtonText.styleMedium(
                                  color: AppColors.whiteColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (Platform.isIOS) ...[
                          15.h.addHSpace(),
                          AppButton(
                            onTap: () {
                              Get.offAllNamed(Routes.BOTTOMBAR);
                            },
                            buttonColor: AppColors.whiteColor,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 3.h),
                                    child: Image.asset(
                                      AppImages.iosIcon,
                                      height: 30.h,
                                      width: 30.h,
                                    ),
                                  ),
                                  10.w.addWSpace(),

                                  AppText.appleButtonText.styleMedium(
                                    color: AppColors.blackColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ] else
                          Spacer(),
                      ],
                    ),
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
