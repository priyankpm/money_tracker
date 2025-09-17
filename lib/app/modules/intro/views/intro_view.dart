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

import '../controllers/intro_controller.dart';

class IntroView extends GetView<IntroController> {
  const IntroView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: Column(
            children: [
              Image.asset(
                AppImages.introImage,
                height: 613.h,
                fit: BoxFit.fill,
              ),
              Spacer(),
              AppText.introTextAn.styleBold(
                color: AppColors.primaryColor,
                size: 36.sp,
                align: TextAlign.center,
              ),
              Spacer(),

              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 28.w),
                child: AppButton(
                  onTap: () {
                    Get.offAllNamed(Routes.LOGIN);
                  },
                  child: Center(
                    child: AppText.getStarted.styleMedium(
                      color: AppColors.whiteColor,
                      size: 18.sp,
                    ),
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
