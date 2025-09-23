import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:money_tracker/app/modules/bottombar/controllers/bottombar_controller.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/extenstion.dart';

import '../controllers/charts_controller.dart';

class ChartsView extends GetView<ChartsController> {
  const ChartsView({super.key});
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
              AppBar(
                surfaceTintColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                leading: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: IconButton(
                    onPressed: () {
                      Get.find<BottombarController>().changeTab(0);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.primaryColor,
                      size: 18.h,
                    ),
                  ),
                ),
                title: AppText.summary.styleSemiBold(
                  size: 20.sp,
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
