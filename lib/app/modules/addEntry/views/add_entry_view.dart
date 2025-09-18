import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:money_tracker/app/models/category_model.dart';
import 'package:money_tracker/app/modules/addEntry/controllers/add_entry_controller.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/config/app_images.dart';
import 'package:money_tracker/config/app_loader.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/buttons.dart';
import 'package:money_tracker/utils/extenstion.dart';
import 'package:money_tracker/utils/snackbar.dart';
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
                    actions: [
                      if (controller.isUpdate.value)
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.delete, color: AppColors.redColor),
                        ),
                      10.w.addWSpace(),
                    ],
                    title: (controller.isUpdate.value
                            ? AppText.updateTransaction
                            : AppText.addTransaction)
                        .styleSemiBold(
                          size: 20.sp,
                          color: AppColors.whiteColor,
                        ),
                  ),
                ),
              ),
              Positioned(
                right: 20.w,
                left: 20.w,
                top: 140.h,
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

                        10.h.addHSpace(),

                        AppText.category.styleMedium(size: 14.sp),
                        5.h.addHSpace(),
                        Obx(() => Row(
                            children: [
                              controller.isUpdate.value && !controller.setDataLoader.value
                                  ? Expanded(
                                    flex: 6,
                                    child: CustomDropdown<String>.search(
                                      decoration: CustomDropdownDecoration(
                                        closedBorderRadius:
                                            BorderRadius.circular(8.r),
                                        closedBorder: Border.all(
                                          color: AppColors.greyColor,
                                          width: 0.7,
                                        ),
                                      ),
                                      hintText: 'Select category',
                                      items:
                                          controller.categoryModel
                                              .map((category) => category.title)
                                              .toList(),
                                      excludeSelected: false,
                                      initialItem:
                                          controller.selectedModel.value?.category,
                                      onChanged: (value) {
                                        controller.titleController.text =
                                            value ?? "";
                                      },
                                    ),
                                  )
                                  : Expanded(
                                    flex: 6,
                                    child: CustomDropdown<String>.search(
                                      decoration: CustomDropdownDecoration(
                                        closedBorderRadius:
                                            BorderRadius.circular(8.r),
                                        closedBorder: Border.all(
                                          color: AppColors.greyColor,
                                          width: 0.7,
                                        ),
                                      ),
                                      hintText: 'Select category',
                                      items:
                                          controller.categoryModel
                                              .map((category) => category.title)
                                              .toList(),
                                      excludeSelected: false,

                                      onChanged: (value) {
                                        controller.titleController.text =
                                            value ?? "";
                                      },
                                    ),
                                  ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    showAddCategoryDialog(context);
                                  },
                                  child: Container(
                                    height: 45.h,
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),

                        10.h.addHSpace(),
                        AppText.amountText.styleMedium(size: 14.sp),
                        5.h.addHSpace(),
                        AppTextField(
                          maxLength: 7,
                          textInputType: TextInputType.number,
                          controller: controller.amountController,
                          labelText: AppText.amountText,
                          textInputAction: TextInputAction.next,
                        ),
                        10.h.addHSpace(),
                        AppText.note.styleMedium(size: 14.sp),
                        5.h.addHSpace(),
                        AppTextField(
                          maxLines: 3,
                          minLines: 3,
                          controller: controller.descriptionController,
                          labelText: AppText.noteOp,
                          textInputAction: TextInputAction.done,
                        ),
                        10.h.addHSpace(),
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
                        20.h.addHSpace(),
                        Obx(
                          () => AppButton(
                            onTap:
                                controller.isLoading.value
                                    ? null
                                    : () async {
                                      hideKeyboard(context);
                                      await controller.addTransaction();
                                    },
                            child:
                                controller.isLoading.value
                                    ? AppLoader.buttonLoader
                                    : Center(
                                      child: AppText.save.styleMedium(
                                        color: AppColors.whiteColor,
                                        size: 18.sp,
                                      ),
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

  Future<void> showAddCategoryDialog(BuildContext context) async {
    TextEditingController categoryController = TextEditingController();

    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: AppText.addCategory.styleSemiBold(size: 22.sp)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              10.h.addHSpace(),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: AppTextField(
                  controller: categoryController,
                  labelText: "Enter category name",
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(),
              child: AppText.cancel.styleMedium(color: AppColors.primaryColor),
            ),
            Obx(
              () => ElevatedButton(
                onPressed: () async {
                  final categoryName = categoryController.text.trim();
                  if (controller.categoryModel.any(
                    (element) =>
                        element.title.toLowerCase() ==
                        categoryName.toLowerCase(),
                  )) {
                    CommonSnackbar.showSnackbar(
                      message: AppText.categoryExist,
                      type: SnackbarType.error,
                    );
                  } else {
                    if (categoryName.isNotEmpty) {
                      await controller.addCategory(categoryName);
                      Get.back();
                    } else {
                      CommonSnackbar.showSnackbar(
                        message: AppText.pleaseEnterCategoryName,
                        type: SnackbarType.error,
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1B183E),
                ),
                child:
                    controller.categoryLoading.value
                        ? IntrinsicWidth(
                          child: SpinKitThreeBounce(
                            color: AppColors.whiteColor,
                            size: 15.h,
                          ),
                        )
                        : AppText.add.styleMedium(color: AppColors.whiteColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
