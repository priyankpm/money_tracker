import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:money_tracker/app/modules/home/views/home_view.dart';
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
    Center(child: Text("Chart")),
    Center(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        top: false,
        child: Scaffold(
          body: pages[controller.selectedIndex.value],
          bottomNavigationBar: Container(
            height: 80.h,
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(icons.length, (index) {
                final isSelected = index == controller.selectedIndex.value;
                return GestureDetector(
                  onTap: () => controller.changeTab(index),
                  child: SvgPicture.asset(
                    isSelected ? icons1[index] : icons[index],
                    height:  index == 1 ? 34.h :30.h,
                    width:  index == 1 ? 34.h :30.h,
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
