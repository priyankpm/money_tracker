import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:money_tracker/app/models/transaction_model.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/extenstion.dart';
import 'package:money_tracker/utils/no_data_widgets.dart';
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
                surfaceTintColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                centerTitle: true,
                title: AppText.transactionsHistory.styleSemiBold(
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
              Padding(padding: EdgeInsets.only(bottom: 5.h)),
              Obx(() {
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 22.w),
                  child: Column(
                    children: [
                      ListTile(
                        splashColor: Colors.transparent,
                        title: Row(
                          children: [
                            Icon(
                              Icons.filter_list,
                              color: AppColors.primaryColor,
                            ),
                            10.w.addWSpace(),
                            "Filter: ${controller.selectedFilter.value}"
                                .styleSemiBold(),
                          ],
                        ),
                        trailing: Icon(
                          controller.isExpanded.value
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                        ),
                        onTap: () {
                          controller.isExpanded.value =
                              !controller.isExpanded.value;
                        },
                      ),

                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child:
                            controller.isExpanded.value
                                ? Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: RadioGroup<String>(
                                    groupValue: controller.selectedFilter.value,
                                    onChanged: (String? v) {
                                      if (v == null) return;
                                      controller.selectedFilter.value = v;
                                      controller.isExpanded.value = false;
                                    },
                                    child: Column(
                                      children:
                                          controller.filters.map((filter) {
                                            return RadioListTile<String>(
                                              value: filter,
                                              title: filter.styleMedium(
                                                color: AppColors.primaryColor,
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                )
                                : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
              }),
              Padding(padding: EdgeInsets.only(bottom: 5.h)),
              GetBuilder<HistoryController>(
                initState: (state) {
                  controller.getIncomes();
                  controller.getExpense();
                },
                builder: (controller) {
                  return Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 22.w,
                          vertical: 10.h,
                        ),
                        child: Obx(() {
                          return controller.isLoading.value
                              ? Padding(
                                padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * 0.26,
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              )
                              : buildListView(
                                controller,
                                controller.type.value == "Income"
                                    ? controller.incomeTransaction
                                    : controller.expenseTransaction,
                                context,
                              );
                        }),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListView(
    HistoryController controller,
    List<TransactionModel> data1,
    BuildContext context,
  ) {
    return data1.isEmpty
        ? Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * 0.2,
          ),
          child: NoDataWidget(
            msg:
                controller.type.value == "Income"
                    ? AppText.noIncomeTransaction
                    : AppText.noExpenseTransaction,
          ),
        )
        : ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) => Divider(height: 30.h),
          padding: EdgeInsets.only(bottom: 20.h),
          itemCount: data1.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final data = data1[index];
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getDayAndDate(data.date)["date"]!.styleBold(
                          size: 20.sp,
                          color: AppColors.primaryColor,
                        ),
                        getDayAndDate(data.date)["day"]!.styleSemiBold(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      data.category.styleSemiBold(
                        size: 15.sp,
                        color: AppColors.blackColor,
                      ),
                      data.note.styleRegular(
                        size: 13.sp,
                        color: AppColors.greyColor,
                      ),
                    ],
                  ),
                ),
                Spacer(),
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
        );
  }
}
