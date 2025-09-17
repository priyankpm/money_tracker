import 'dart:io';

import 'package:advanced_salomon_bottom_bar/advanced_salomon_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:money_tracker/app/modules/home/views/home_view.dart';
import 'package:money_tracker/app/modules/profile/views/profile_view.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/config/app_images.dart';

import '../controllers/bottombar_controller.dart';

class BottombarView extends GetView<BottombarController> {
  const BottombarView({super.key});

  final List<String> icons = const [
    AppImages.home,
    AppImages.history,
    AppImages.chart,
    AppImages.profile,
  ];

  final List<String> icons1 = const [
    AppImages.home1,
    AppImages.history1,
    AppImages.chart1,
    AppImages.profile1,
  ];

  final List<Widget> pages = const [
    HomeView(),
    Center(child: Text("History")),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      child: Obx(
        () => SafeArea(
          top: false,
          bottom: Platform.isIOS ? false : true,
          child: Scaffold(
            backgroundColor: AppColors.whiteColor,
            body: pages[controller.selectedIndex.value],
            bottomNavigationBar: AdvancedSalomonBottomBar(
              currentIndex: controller.selectedIndex.value,
              onTap: (i) => controller.changeTab(i),
              items: [
                /// Home
                AdvancedSalomonBottomBarItem(
                  icon: Icon(Icons.home),
                  title: Text("Home"),
                  selectedColor: Colors.purple,
                ),

                /// Likes
                AdvancedSalomonBottomBarItem(
                  icon: Icon(Icons.favorite_border),
                  title: Text("Likes"),
                  selectedColor: Colors.pink,
                ),

                /// Profile
                AdvancedSalomonBottomBarItem(
                  icon: Icon(Icons.person),
                  title: Text("Profile"),
                  selectedColor: Colors.teal,
                ),
              ],
            ),
            // bottomNavigationBar: Padding(
            //   padding: EdgeInsets.only(bottom: Platform.isIOS ? 15.h : 0),
            //   child: Container(
            //     height: 60.h,
            //     padding: EdgeInsets.symmetric(horizontal: 35.w),
            //     decoration: BoxDecoration(
            //       color: Colors.white,
            //       boxShadow: [
            //         BoxShadow(
            //           color: Colors.black12.withValues(alpha: 0.05),
            //           blurRadius: 6,
            //           offset: const Offset(0, -5),
            //         ),
            //       ],
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: List.generate(icons.length, (index) {
            //         final isSelected = index == controller.selectedIndex.value;
            //         return GestureDetector(
            //           onTap: () => controller.changeTab(index),
            //           child: SvgPicture.asset(
            //             isSelected ? icons1[index] : icons[index],
            //             height: index == 1 ? 34.h : 30.h,
            //             width: index == 1 ? 34.h : 30.h,
            //           ),
            //         );
            //       }),
            //     ),
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}
