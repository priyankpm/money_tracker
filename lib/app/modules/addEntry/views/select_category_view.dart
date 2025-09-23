import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/config/app_images.dart';
import 'package:money_tracker/config/app_loader.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/buttons.dart';
import 'package:money_tracker/utils/extenstion.dart';
import 'package:money_tracker/utils/no_data_widgets.dart';
import 'package:money_tracker/utils/snackbar.dart';
import 'package:money_tracker/utils/textfield.dart';

import '../controllers/add_entry_controller.dart';

class SelectCategoryView extends GetView<AddEntryController> {
  const SelectCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
                        actions: [
                          Padding(
                            padding: EdgeInsets.only(right: 10.w),
                            child: IconButton(
                              onPressed: () {
                                addCategory(context);
                              },
                              icon: Icon(
                                Icons.add_box_outlined,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ),
                        ],
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
                        title: AppText.selectCategory.styleSemiBold(
                          size: 20.sp,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20.w,
                    left: 20.w,
                    top: 110.h,
                    bottom: 100.h,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(20.r),
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
                        padding: EdgeInsets.symmetric(horizontal: 15.h),
                        child: Obx(() {
                          return controller.getCategoryLoading.value
                              ? Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primaryColor,
                                ),
                              )
                              : controller.categoryModel.isEmpty
                              ? NoDataWidget(msg: "Not any category added!")
                              : ListView.separated(
                                separatorBuilder:
                                    (context, index) => 15.h.addHSpace(),
                                padding: EdgeInsets.symmetric(vertical: 15.h),
                                itemCount: controller.categoryModel.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  final data = controller.categoryModel[index];
                                  return GestureDetector(
                                    onTap:
                                        () => controller.updateSelectedCategory(
                                          data,
                                        ),
                                    child: Container(
                                      height: 55.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(11.r),
                                        border: Border.all(
                                          color: AppColors.primaryColor,
                                        ),
                                        color: AppColors.whiteColor,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryColor,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10.r),
                                                bottomLeft: Radius.circular(
                                                  10.r,
                                                ),
                                              ),
                                            ),
                                            width: 55.h,
                                            child: Center(
                                              child: data.icon.styleSemiBold(
                                                size: 22.sp,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                            ),
                                            child: data.title.styleMedium(
                                              color: AppColors.primaryColor,
                                            ),
                                          ),
                                          Spacer(),
                                          Obx(
                                            () =>
                                                controller
                                                            .tempSelectedCategory
                                                            .value
                                                            ?.id ==
                                                        data.id
                                                    ? Icon(
                                                      Icons
                                                          .radio_button_checked_sharp,
                                                    )
                                                    : SizedBox(),
                                          ),
                                          15.w.addWSpace(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                        }),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20.w,
                    left: 20.w,
                    bottom: 5.h,
                    child: Obx(
                      () => AppButton(
                        onTap: () {
                          if (controller.tempSelectedCategory.value != null) {
                            controller.selectedCategory.value =
                                controller.tempSelectedCategory.value;
                            Get.back();
                          } else {
                            CommonSnackbar.showSnackbar(
                              message: AppText.pleaseSelectCategory,
                              type: SnackbarType.error,
                            );
                          }
                        },
                        buttonColor:
                            controller.tempSelectedCategory.value != null
                                ? AppColors.primaryColor
                                : AppColors.greyColor.withValues(alpha: 0.6),
                        borderColor: Colors.transparent,
                        child: Center(
                          child: (controller.tempSelectedCategory.value != null
                                  ? "Select"
                                  : "Select Category")
                              .styleMedium(
                                size: 18.sp,
                                color:
                                    controller.tempSelectedCategory.value !=
                                            null
                                        ? AppColors.whiteColor
                                        : AppColors.whiteColor.withValues(
                                          alpha: 0.5,
                                        ),
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<dynamic> addCategory(BuildContext context) {
    final textController = TextEditingController();
    controller.updateSelectedIcon("");
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return GetBuilder<AddEntryController>(
          builder: (con) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20.h),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: AppText.addCategory.styleSemiBold(
                          color: AppColors.primaryColor,
                          size: 20.w,
                        ),
                      ),
                      10.h.addHSpace(),
                      AppText.selectIcon.styleSemiBold(
                        size: 16.sp,
                        color: AppColors.primaryColor,
                      ),
                      5.h.addHSpace(),
                      Flexible(
                        child: GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 6,
                              ),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: controller.categoryIcons.length,
                          itemBuilder:
                              (context, index) => Obx(
                                () => GestureDetector(
                                  onTap: () {
                                    con.updateSelectedIcon(
                                      controller.categoryIcons[index],
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color:
                                          controller.categoryIcons[index] ==
                                                  controller.selectedIcon.value
                                              ? AppColors.primaryColor
                                              : AppColors.whiteColor,
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                    child: Center(
                                      child: controller.categoryIcons[index]
                                          .styleSemiBold(size: 22.sp),
                                    ),
                                  ),
                                ),
                              ),
                        ),
                      ),

                      10.h.addHSpace(),
                      AppText.title.styleSemiBold(
                        size: 16.sp,
                        color: AppColors.primaryColor,
                      ),
                      5.h.addHSpace(),

                      AppTextField(
                        textInputType: TextInputType.text,
                        controller: textController,
                        labelText: AppText.enterTitle,
                        textInputAction: TextInputAction.done,
                      ),
                      40.h.addHSpace(),
                      Obx(() {
                        return AppButton(
                          onTap: () async {
                            if (con.selectedIcon.value.isEmpty) {
                              return CommonSnackbar.showSnackbar(
                                message: AppText.pleaseSelectIcon,
                                type: SnackbarType.error,
                              );
                            }
                            if (textController.text.isEmpty) {
                              return CommonSnackbar.showSnackbar(
                                message: AppText.pleaseEnterTitle,
                                type: SnackbarType.error,
                              );
                            }
                            hideKeyboard(context);
                            await con
                                .addCategory(
                                  textController.text,
                                  controller.selectedIcon.value,
                                )
                                .then((value) => Navigator.pop(context));
                          },
                          child: Center(
                            child:
                                con.categoryLoading.value
                                    ? AppLoader.buttonLoader
                                    : AppText.save.styleMedium(
                                      size: 18.sp,
                                      color: AppColors.whiteColor,
                                    ),
                          ),
                        );
                      }),
                      10.h.addHSpace(),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
