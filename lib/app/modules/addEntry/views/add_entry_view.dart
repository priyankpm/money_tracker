import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:money_tracker/app/modules/addEntry/controllers/add_entry_controller.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/config/app_images.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/buttons.dart';
import 'package:money_tracker/utils/extenstion.dart';
import 'package:money_tracker/utils/textfield.dart';

class AddEntryView extends GetView<AddEntryController> {
  const AddEntryView({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteColor,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(height: MediaQuery.of(context).size.height),
              Positioned(
                child: Container(
                  height: 255.h,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.profileBanner),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: AppBar(
                    leading: Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: AppColors.whiteColor,
                          size: 18.h,
                        ),
                      ),
                    ),
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: Colors.transparent,
                    centerTitle: true,
                    title: AppText.addTransaction.styleSemiBold(
                      size: 20.sp,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 20.w,
                left: 20.w,
                top: 150.h,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => SizedBox(
                            height: 45.h,
                            child: Row(
                              children: List.generate(
                                controller.types.length,
                                (index) => Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.updateType(
                                        controller.types[index],
                                      );
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
                                        border: Border.all(
                                          color: AppColors.primaryColor,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          10.r,
                                        ),
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

                        15.h.addHSpace(),

                        AppText.title.styleMedium(size: 14.sp),
                        5.h.addHSpace(),
                        AppTextField(
                          controller: controller.titleController,
                          labelText: AppText.title,
                        ),
                        15.h.addHSpace(),
                        AppText.description.styleMedium(size: 14.sp),
                        5.h.addHSpace(),
                        AppTextField(
                          maxLines: 15,
                          minLines: 4,
                          controller: controller.descriptionController,
                          labelText: AppText.description,
                        ),
                        15.h.addHSpace(),
                        AppText.date.styleMedium(size: 14.sp),
                        5.h.addHSpace(),
                        AppTextField(
                          readonly: true,
                          onTap: () {
                            controller.pickDate(context);
                          },
                          suffix: Icon(
                            Icons.date_range,
                            color: AppColors.primaryColor,
                          ),
                          controller: controller.dateController.value,
                          labelText: AppText.date,
                        ),
                        30.h.addHSpace(),
                        AppButton(
                          child: Center(
                            child: AppText.save.styleMedium(
                              color: AppColors.whiteColor,
                              size: 18.sp,
                            ),
                          ),
                        ),
                        5.h.addHSpace(),
                      ],
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
