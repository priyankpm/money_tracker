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
    return Container(color: AppColors.whiteColor,
      child: SafeArea(
        top: false,
        child: Scaffold(backgroundColor: AppColors.whiteColor,
          body: Column(
            children: [
              Image.asset(AppImages.loginImage, height: 613.h, fit: BoxFit.fill),
              Spacer(),
              (Platform.isAndroid ? AppText.introTextAn : AppText.introText)
                  .styleBold(
                    color: AppColors.primaryColor,
                    size: Platform.isAndroid ? 30.sp : 20.sp,
                    align: TextAlign.center,
                  ),
              Spacer(),

              AppButton(
                onTap: () {
                  Get.offAllNamed(Routes.BOTTOMBAR);
                },
                child: Center(
                  child: Row(
                    children: [
                      Image.asset(
                        AppImages.googleImage,
                        height: 30.h,
                        width: 30.h,
                      ),
                      Spacer(),
                      AppText.loginButtonText.styleMedium(
                        color: AppColors.whiteColor,
                      ),
                      22.h.addWSpace(),
                      Spacer(),
                    ],
                  ),
                ),
              ),

              if (Platform.isIOS) ...[
                18.h.addHSpace(),
                AppButton(
                  onTap: () {
                    Get.offAllNamed(Routes.BOTTOMBAR);
                  },
                  buttonColor: AppColors.whiteColor,
                  child: Center(
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 3.h),
                          child: Image.asset(
                            AppImages.iosImage,
                            height: 30.h,
                            width: 30.h,
                          ),
                        ),
                        Spacer(),
                        AppText.appleButtonText.styleMedium(
                          color: AppColors.blackColor,
                        ),
                        22.h.addWSpace(),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
              20.h.addHSpace(),
            ],
          ),
        ),
      ),
    );
  }
}
