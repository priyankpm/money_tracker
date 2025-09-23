import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:money_tracker/app/models/transaction_model.dart';
import 'package:money_tracker/app/modules/bottombar/controllers/bottombar_controller.dart';
import 'package:money_tracker/app/modules/home/controllers/home_controller.dart';
import 'package:money_tracker/app/routes/app_pages.dart';
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
                leading: Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: IconButton(
                    onPressed: () {
                      Get.find<BottombarController>().changeTab(0);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.primaryColor,
                      size: 18.h,
                    ),
                  ),
                ),
                title: AppText.transactionsHistory.styleSemiBold(
                  size: 20.sp,
                  color: AppColors.primaryColor,
                ),
              ),

              /// TAB BAR(EXPENSE - INCOME)
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

              GetBuilder<HistoryController>(
                initState: (state) {
                  controller.getIncomes();
                  controller.getExpense();
                },
                builder: (controller1) {
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
                                  top: MediaQuery.of(context).size.height * 0.3,
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
            top: MediaQuery.of(context).size.height * 0.26,
          ),
          child: NoDataWidget(
            msg:
                controller.type.value == "Income"
                    ? AppText.noIncomeTransaction
                    : AppText.noExpenseTransaction,
          ),
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            data1.isEmpty
                ? SizedBox()
                : Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.4),
                          width: 1,
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 10,
                        top: 5,
                        bottom: 5,
                      ),
                      child: Obx(
                        () => PopupMenuButton<String>(
                          padding: EdgeInsets.zero,
                          menuPadding: EdgeInsets.zero,
                          color: AppColors.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          // Using Row inside `child` instead of `icon` for text + icon
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              controller.selectedFilter.value.styleSemiBold(),
                              const Icon(Icons.keyboard_arrow_down),
                            ],
                          ),
                          onSelected: (String value) {
                            controller.selectedFilter.value = value;
                          },
                          itemBuilder: (context) {
                            return [
                              for (
                                int i = 0;
                                i < controller.filters.length;
                                i++
                              ) ...[
                                PopupMenuItem<String>(
                                  value: controller.filters[i],
                                  // Highlight if selected
                                  child:
                                      controller.filters[i] ==
                                              controller.selectedFilter.value
                                          ? Row(
                                            children: [
                                              controller.filters[i].styleMedium(
                                                color: AppColors.primaryColor,
                                                // optional: bold for emphasis
                                              ),
                                              Spacer(),
                                              Icon(Icons.check),
                                            ],
                                          )
                                          : controller.filters[i].styleMedium(
                                            color: Colors.black,
                                          ),
                                ),
                                if (i != controller.filters.length - 1)
                                  const PopupMenuDivider(height: 1),
                              ],
                            ];
                          },
                        ),
                      ),
                    ),
                  ],
                ),

            controller.filteredTransactions.isEmpty
                ? Center(
                  heightFactor: 3.5,
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
                  itemCount: controller.filteredTransactions.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final data = controller.filteredTransactions[index];
                    return GestureDetector(
                      onTap: () async {
                        await Get.toNamed(
                          Routes.ADD_ENTRY,
                          arguments: {"selectedData": data},
                        )?.then((value) async {
                          if (value == true) {
                            controller.getIncomes();
                            controller.getExpense();
                            Get.find<HomeController>().getTodayTransaction();
                          }
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  data.category.styleSemiBold(
                                    size: 15.sp,
                                    color: AppColors.blackColor,
                                  ),
                                  data.note.isEmpty
                                      ? SizedBox()
                                      : data.note.styleRegular(
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
                        ),
                      ),
                    );
                  },
                ),
          ],
        );
  }
}
