import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/config/app_images.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/extenstion.dart';

import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});
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
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 22.w),
                    child: PopupMenuButton(
                      icon: Icon(
                        Icons.filter,
                        color: AppColors.primaryColor,
                      ),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(child: Text("data")),
                          PopupMenuItem(child: Text("data")),
                          PopupMenuItem(child: Text("data")),
                        ];
                      },
                    ),
                  ),
                ],
                surfaceTintColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: AppText.history.styleSemiBold(
                  size: 20.sp,
                  color: AppColors.primaryColor,
                ),
              ),
              Obx(
                () => Container(
                  height: 45.h,
                  margin: EdgeInsets.symmetric(
                    horizontal: 22.w,
                    vertical: 10.h,
                  ),
                  child: Row(
                    children: List.generate(
                      controller.types.length,
                      (index) => Expanded(
                        child: GestureDetector(
                          onTap: () {
                            controller.updateType(controller.types[index]);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              right: index == 0 ? 15.w : 0,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  controller.types[index] ==
                                          controller.type.value
                                      ? AppColors.primaryColor
                                      : Colors.transparent,
                              border: Border.all(color: AppColors.primaryColor),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Center(
                              child: (index == 0
                                      ? AppText.incomeText
                                      : AppText.expenseText)
                                  .styleSemiBold(
                                    color:
                                        controller.types[index] ==
                                                controller.type.value
                                            ? AppColors.whiteColor
                                            : AppColors.blackColor,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 22.w,
                      vertical: 20.h,
                    ),
                    child: ListView.separated(
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) => Divider(height: 30.h,),
                      padding: EdgeInsets.only(bottom: 10.h),
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
                              size: 14.sp,
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
      ),
    );
  }
}
