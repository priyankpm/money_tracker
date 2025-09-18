import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:money_tracker/app/modules/bottombar/controllers/bottombar_controller.dart';
import 'package:money_tracker/app/routes/app_pages.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/config/app_images.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/extenstion.dart';
import 'package:money_tracker/utils/no_data_widgets.dart';
import 'package:money_tracker/utils/shared_prefs.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          floatingActionButton: GestureDetector(
            onTap: () async {
              await Get.toNamed(Routes.ADD_ENTRY)?.then((value) async {
                await controller.getTodayTransaction();
              });
            },
            child: Container(
              height: 60.h,
              width: 60.h,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: AppColors.whiteColor, size: 35.h),
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 255.h,
                    width: 414.w,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.profileBanner),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 60.h, left: 20.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  getTimeBasedGreeting().styleMedium(
                                    size: 16.sp,
                                    color: AppColors.whiteColor,
                                  ),
                                  5.w.addWSpace(),
                                  Image.asset(AppImages.hello, height: 26.h),
                                ],
                              ),
                              Builder(
                                builder: (context) {
                                  String? name = preferences.getString(
                                    SharedPreference.USER_NAME,
                                  );

                                  return (name ?? "").styleSemiBold(
                                    size: 20.sp,
                                    color: AppColors.whiteColor,
                                  );
                                },
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
                        image: DecorationImage(
                          image: AssetImage(AppImages.homeBanner),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 10,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(15.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 25.h,
                                      width: 25.h,
                                      margin: EdgeInsets.only(right: 8.w),
                                      child: SvgPicture.asset(
                                        AppImages.upArrowIcon,
                                      ),
                                    ),

                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        AppText.income.styleSemiBold(
                                          size: 14.sp,
                                          color: AppColors.greenColor,
                                        ),
                                        2.h.addHSpace(),
                                        '\$ ${controller.userModel.value?.totalIncome ?? 0.0}'.styleBold(
                                          size: 16.sp,
                                          color: AppColors.whiteColor,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        AppText.expense.styleSemiBold(
                                          size: 14.sp,
                                          color: AppColors.redColor,
                                        ),
                                        2.h.addHSpace(),
                                        '\$ ${controller.userModel.value?.totalExpense ?? 0.0}'.styleBold(
                                          size: 16.sp,
                                          color: AppColors.whiteColor,
                                        ),
                                      ],
                                    ),
                                    Container(
                                      height: 25.h,
                                      width: 25.h,
                                      margin: EdgeInsets.only(left: 8.w),
                                      child: SvgPicture.asset(
                                        AppImages.downArrowIcon,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                            Spacer(),

                            Obx(() => Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AppText.totalBalance.styleSemiBold(
                                    size: 16.sp,
                                    color: AppColors.whiteColor,
                                  ),
                                  5.h.addHSpace(),
                                  '\$ ${(controller.userModel.value?.totalIncome ?? 0.0) - (controller.userModel.value?.totalExpense ?? 0.0)}'.styleBold(
                                    size: 25.sp,
                                    color: AppColors.whiteColor,
                                  ),
                                ],
                              ),
                            ))
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
                  bottom: 20.h,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppText.recentHistory.styleSemiBold(
                      color: AppColors.blackColor,
                    ),
                    controller.recentTransaction.length == 10
                        ? GestureDetector(
                          onTap: () {
                            Get.find<BottombarController>().changeTab(1);
                          },
                          child: AppText.seeAll.styleRegular(
                            size: 14.sp,
                            color: AppColors.greyColor,
                          ),
                        )
                        : SizedBox(),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Obx(
                    () => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w),
                      child:
                          controller.isLoading.value
                              ? Padding(
                                padding: EdgeInsets.only(top: 160.h),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              )
                              : controller.recentTransaction.isEmpty
                              ? Padding(
                                padding: EdgeInsets.only(top: 100.h),
                                child: NoDataWidget(
                                  msg: AppText.noRecentTransaction,
                                ),
                              )
                              : ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                separatorBuilder:
                                    (context, index) => Divider(height: 30.h),
                                padding: EdgeInsets.only(bottom: 70.h),
                                itemCount: controller.recentTransaction.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final data =
                                      controller.recentTransaction[index];
                                  return Row(
                                    children: [
                                      Container(
                                        height: 55.h,
                                        width: 55.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.lightColor,
                                          borderRadius: BorderRadius.circular(
                                            10.r,
                                          ),
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              getDayAndDate(
                                                data.date,
                                              )["date"]!.styleBold(
                                                size: 20.sp,
                                                color: AppColors.primaryColor,
                                              ),
                                              getDayAndDate(
                                                data.date,
                                              )["day"]!.styleSemiBold(
                                                size: 10.sp,
                                                color: AppColors.primaryColor,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      10.w.addWSpace(),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            data.category.styleSemiBold(
                                              size: 15.sp,
                                              color: AppColors.blackColor,
                                            ),
                                            data.note.isEmpty ? SizedBox() : data.note.styleRegular(
                                              size: 13.sp,
                                              color: AppColors.greyColor,
                                            ),
                                          ],
                                        ),
                                      ),

                                      "${data.type == AppText.incomeText ? "+" : "-"} \$ ${data.amount}"
                                          .styleSemiBold(
                                            align: TextAlign.end,
                                            size: 14.sp,
                                            color:
                                                data.type == AppText.incomeText
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
