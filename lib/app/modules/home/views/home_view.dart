import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/config/app_images.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/extenstion.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        floatingActionButton: Container(
          height: 60.h,
          width: 60.h,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.add, color: AppColors.whiteColor, size: 35.h),
        ),
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
                  child: Padding(
                    padding: EdgeInsets.only(top: 80.h, left: 20.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                AppText.goodAfternoon.styleMedium(
                                  size: 16.sp,
                                  color: AppColors.whiteColor,
                                ),
                                5.w.addWSpace(),
                                Image.asset(AppImages.hello, height: 26.h),
                              ],
                            ),
                            AppText.name.styleSemiBold(
                              size: 20.sp,
                              color: AppColors.whiteColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 20.w,
                  left: 20.w,
                  bottom: -75.h,
                  child: Container(
                    height: 201.h,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: Offset(0, 6),
                        ),
                      ],
                      color: AppColors.secondaryColor,
                      borderRadius: BorderRadius.all(Radius.circular(20.r)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.totalBalance.styleSemiBold(
                            size: 16.sp,
                            color: AppColors.whiteColor,
                          ),
                          AppText.amount.styleBold(
                            size: 30.sp,
                            color: AppColors.whiteColor,
                          ),
                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 26.h,
                                        width: 26.h,
                                        margin: EdgeInsets.only(right: 8.w),
                                        child: Image.asset(AppImages.downArrow),
                                      ),
                                      AppText.expense.styleSemiBold(
                                        size: 16.sp,
                                        color: AppColors.whiteColor,
                                      ),
                                    ],
                                  ),
                                  6.h.addHSpace(),
                                  AppText.amount1.styleBold(
                                    size: 20.sp,
                                    color: AppColors.whiteColor,
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 26.h,
                                        width: 26.h,
                                        margin: EdgeInsets.only(right: 8.w),

                                        child: Image.asset(AppImages.upArrow),
                                      ),
                                      AppText.expense.styleSemiBold(
                                        size: 16.sp,
                                        color: AppColors.whiteColor,
                                      ),
                                    ],
                                  ),
                                  6.h.addHSpace(),
                                  AppText.amount2.styleBold(
                                    size: 20.sp,
                                    color: AppColors.whiteColor,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 22.w,
                right: 22.w,
                top: 100.h,
                bottom: 10.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppText.transactionsHistory.styleSemiBold(
                    color: AppColors.blackColor,
                  ),
                  AppText.seeAll.styleRegular(
                    size: 14.sp,
                    color: AppColors.greyColor,
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22.w),
                  child: ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => 16.h.addHSpace(),
                    padding: EdgeInsets.only(bottom: 30.h),
                    itemCount: 10,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Container(
                            height: 55.h,
                            width: 55.h,
                            decoration: BoxDecoration(
                              color: AppColors.lightColor,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: "U".styleBold(
                                size: 26.sp,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                          10.w.addWSpace(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "Upwork".styleSemiBold(
                                color: AppColors.blackColor,
                              ),
                              "Today".styleRegular(
                                size: 14.sp,
                                color: AppColors.greyColor,
                              ),
                            ],
                          ),
                          Spacer(),
                          "+ \$ 850.00".styleSemiBold(
                            color:
                                index % 2 == 0
                                    ? AppColors.greenColor
                                    : AppColors.redColor,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
