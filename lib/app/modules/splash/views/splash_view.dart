import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/extenstion.dart';
import '../../../../utils/text_animatation.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      builder: (context) {
        return Container(
          color: AppColors.primaryColor,
          child: Scaffold(
            backgroundColor: AppColors.primaryColor,
            body: Center(
              child: ZoomText(text:  AppText.appName.styleBold(
                  size: 30.sp,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}
