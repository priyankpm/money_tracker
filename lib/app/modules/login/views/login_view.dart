import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
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
    return SafeArea(
      top: false,
      child: Scaffold(
        body: Column(
          children: [
            Image.asset(AppImages.loginImage, height: 613.h, fit: BoxFit.fill),
            Spacer(),
            AppText.introText.styleBold(
              color: AppColors.primaryColor,
              size: 30.sp,
              align: TextAlign.center,
            ),
            Spacer(),
            AppButton(
              child: Center(
                child: Row(
                  children: [
                    Image.asset(
                      AppImages.googleImage,
                      height: 35.h,
                      width: 35.h,
                    ),
                    Spacer(),
                    AppText.loginButtonText.styleMedium(color: Colors.white),
                    22.h.addWSpace(),
                    Spacer(),
                  ],
                ),
              ),
            ),
            50.h.addHSpace(),
          ],
        ),
      ),
    );
  }
}
