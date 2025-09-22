import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/app/models/transaction_model.dart';
import 'package:money_tracker/app/modules/addEntry/controllers/add_entry_controller.dart';
import 'package:money_tracker/app/routes/app_pages.dart';
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
    return GetBuilder<AddEntryController>(
      initState: (state) {
        controller.updateFields();
      },
      builder: (con) {
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
                              if (Get.arguments != null)
                                IconButton(
                                  onPressed: () {
                                    showLDeleteConfirmationDialog(
                                      context,
                                      controller.selectedModel.value?.id ?? "",
                                    );
                                  },
                                  icon: Image.asset(
                                    AppImages.deleteAccount,
                                    height: 32.h,
                                  ),
                                ),
                              10.w.addWSpace(),
                            ],
                            title: (Get.arguments != null
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
                                color: AppColors.primaryColor.withValues(
                                  alpha: 0.3,
                                ),
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
                                                            controller
                                                                .type
                                                                .value
                                                        ? AppColors.primaryColor
                                                        : Colors.transparent,
                                                border: Border.all(
                                                  color: AppColors.primaryColor,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                              ),
                                              child: Center(
                                                child: (index == 0
                                                        ? AppText.incomeText
                                                        : AppText.expenseText)
                                                    .styleSemiBold(
                                                      color:
                                                          controller.types[index] ==
                                                                  controller
                                                                      .type
                                                                      .value
                                                              ? AppColors
                                                                  .whiteColor
                                                              : AppColors
                                                                  .blackColor,
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
                                SizedBox(
                                  height: 55,
                                  child: Obx(
                                    () => Row(
                                      children: [
                                        Get.arguments != null &&
                                                !controller
                                                    .getCategoryLoading
                                                    .value &&
                                                controller
                                                    .categoryModel
                                                    .isNotEmpty
                                            ? Expanded(
                                              flex: 6,
                                              child: CustomDropdown<
                                                String
                                              >.search(
                                                decoration:
                                                    CustomDropdownDecoration(
                                                      expandedFillColor:
                                                          AppColors.whiteColor,
                                                      expandedBorder: Border.all(
                                                        color:
                                                            AppColors
                                                                .primaryColor,
                                                      ),
                                                      closedBorderRadius:
                                                          BorderRadius.circular(
                                                            8.r,
                                                          ),
                                                      closedBorder: Border.all(
                                                        color:
                                                            AppColors.greyColor,
                                                        width: 0.7,
                                                      ),
                                                    ),
                                                hintText: 'Select category',
                                                items:
                                                    controller.categoryModel
                                                        .map(
                                                          (category) =>
                                                              category.title,
                                                        )
                                                        .toList(),
                                                excludeSelected: false,
                                                initialItem:
                                                    controller
                                                        .titleController
                                                        .text,
                                                onChanged: (value) {
                                                  controller
                                                      .titleController
                                                      .text = value ?? "";
                                                },
                                              ),
                                            )
                                            : Expanded(
                                              flex: 6,
                                              child: CustomDropdown<
                                                String
                                              >.search(
                                                decoration:
                                                    CustomDropdownDecoration(
                                                      closedBorderRadius:
                                                          BorderRadius.circular(
                                                            8.r,
                                                          ),
                                                      closedBorder: Border.all(
                                                        color:
                                                            AppColors.greyColor,
                                                        width: 0.7,
                                                      ),
                                                    ),
                                                hintText: 'Select category',
                                                items:
                                                    controller.categoryModel
                                                        .map(
                                                          (category) =>
                                                              category.title,
                                                        )
                                                        .toList(),
                                                excludeSelected: false,

                                                onChanged: (value) {
                                                  controller
                                                      .titleController
                                                      .text = value ?? "";
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
                                    ),
                                  ),
                                ),
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
                                controller.file.value == null
                                    ? 20.h.addHSpace()
                                    : 10.h.addHSpace(),
                                AppText.attachment.styleMedium(size: 14.sp),
                                5.h.addHSpace(),
                                Obx(() {
                                  return controller.file.value != null ||
                                          (Get.arguments != null &&
                                              controller
                                                  .imageUrl
                                                  .value
                                                  .isNotEmpty)
                                      ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () {
                                                if (((controller.file.value?.path.toString().split(".").last) == "pdf" ||
                                                    controller.file.value?.path.toString().split(".").last == "doc" ||
                                                    controller.file.value?.path.toString().split(".").last == "docx") ||
                                                    (controller.imageUrl.value.toString().split(".").last) == "pdf" ||
                                                   controller.imageUrl.value.toString().split(".").last == "doc" ||
                                                   controller.imageUrl.value.toString().split(".").last == "docx") {

                                                  controller.openFileFromUrl(controller.imageUrl.value);

                                                } else {
                                                  Get.toNamed(
                                                    Routes.IMAGEPRIVEW, arguments: {"file": controller.file.value,
                                                    if (Get.arguments != null)
                                                      "imageUrl": controller.selectedModel.value!.attachment,
                                                    },
                                                  );
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.remove_red_eye,
                                                    size: 20.sp,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                  5.w.addWSpace(),
                                                  Expanded(
                                                    child: (controller
                                                                .file
                                                                .value
                                                                ?.path ??
                                                            controller
                                                                .imageUrl
                                                                .value)
                                                        .styleBold(
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                          color:
                                                              AppColors
                                                                  .primaryColor,
                                                          size: 14.sp,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              controller.file.value = null;
                                              controller.imageUrl.value = '';
                                            },
                                            icon: Image.asset(
                                              AppImages.deleteAccount,
                                              height: 28.h,
                                            ),
                                          ),
                                        ],
                                      )
                                      : GestureDetector(
                                        onTap: () {
                                          controller.pickFile();
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                          height: 50,
                                          child: DottedBorder(
                                            options:
                                                RoundedRectDottedBorderOptions(
                                                  dashPattern: [5, 3],
                                                  strokeWidth: 0.7,
                                                  radius: Radius.circular(8.r),
                                                ),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.add,
                                                    color:
                                                        AppColors.primaryColor,
                                                  ),
                                                  5.w.addWSpace(),
                                                  AppText.addAttachment
                                                      .styleMedium(
                                                        color:
                                                            AppColors
                                                                .primaryColor,
                                                        size: 16.sp,
                                                      ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                }),

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
            ),

            Obx(() {
              if (con.deleteLoading.value) {
                return Container(
                  color: AppColors.primaryColor.withValues(alpha: 0.2),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  ),
                );
              }
              return SizedBox();
            }),
          ],
        );
      },
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

  Future<void> showLDeleteConfirmationDialog(
    BuildContext context,
    String id,
  ) async {
    await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: AppText.areYouSure.styleSemiBold(size: 20.sp)),
          content: AppText.deleteTransactionMsg
              .styleMedium(overflow: TextOverflow.clip, align: TextAlign.center)
              .paddingOnly(top: 10.h),
          actions: <Widget>[
            TextButton(
              onPressed: () => Get.back(),
              child: AppText.cancel.styleMedium(color: AppColors.primaryColor),
            ),
            ElevatedButton(
              onPressed: () async {
                Get.back();
                await controller.deleteTransaction(id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1B183E),
              ),
              child: AppText.delete.styleMedium(color: AppColors.whiteColor),
            ),
          ],
        );
      },
    );
  }
}
