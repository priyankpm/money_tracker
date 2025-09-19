import 'dart:io';

import 'package:advanced_salomon_bottom_bar/advanced_salomon_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:money_tracker/app/modules/historypage/views/history_view.dart';
import 'package:money_tracker/app/modules/home/views/home_view.dart';
import 'package:money_tracker/app/modules/profile/views/profile_view.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/config/app_images.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/extenstion.dart';

import '../controllers/bottombar_controller.dart';

class BottombarView extends GetView<BottombarController> {
  const BottombarView({super.key});

  final List<String> icons1 = const [
    AppImages.home1,
    AppImages.history1,
    AppImages.profile1,
  ];

  final List<Widget> pages = const [
    HomeView(),
    HistoryView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: Obx(
        () => SafeArea(
          top: false,
          bottom: Platform.isIOS ? false : true,
          child: Scaffold(
            backgroundColor: AppColors.whiteColor,
            body: pages[controller.selectedIndex.value],
            bottomNavigationBar: Container(
              color: AppColors.primaryColor,
              padding: EdgeInsets.only(top: 15.h, bottom: 15.h),
              child: AdvancedSalomonBottomBar(
                decoration: BoxDecoration(color: AppColors.primaryColor),
                margin: EdgeInsets.symmetric(horizontal: 28.w),
                currentIndex: controller.selectedIndex.value,
                onTap: (i) => controller.changeTab(i),
                items: [
                  /// Home
                  AdvancedSalomonBottomBarItem(
                    icon: SvgPicture.asset(
                      icons1[0],
                      height: 22.h,
                      width: 22.h,
                      color: AppColors.whiteColor,
                    ),
                    title: AppText.dashboard.styleSemiBold(
                      color: AppColors.whiteColor,
                      size: 14.sp,
                    ),
                    selectedColor: AppColors.whiteColor,
                  ),

                  /// Likes
                  AdvancedSalomonBottomBarItem(
                    icon: SvgPicture.asset(
                      icons1[1],
                      height: 22.h,
                      width: 22.h,
                      color: AppColors.whiteColor,
                    ),
                    title: AppText.history.styleSemiBold(
                      color: AppColors.whiteColor,
                      size: 14.sp,
                    ),
                    selectedColor: AppColors.whiteColor,
                  ),

                  /// Profile
                  AdvancedSalomonBottomBarItem(
                    icon: SvgPicture.asset(
                      icons1[2],
                      height: 22.h,
                      width: 22.h,
                      color: AppColors.whiteColor,
                    ),
                    title: AppText.profile.styleSemiBold(
                      color: AppColors.whiteColor,
                      size: 14.sp,
                    ),
                    selectedColor: AppColors.whiteColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
