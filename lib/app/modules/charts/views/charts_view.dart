import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_tracker/app/modules/bottombar/controllers/bottombar_controller.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/extenstion.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../controllers/charts_controller.dart';

class ChartsView extends GetView<ChartsController> {
  const ChartsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChartsController>(
      initState: (state) {
        controller.selectedFilter.value = "This Week";
        controller.loadData(controller.selectedFilter.value);
        controller.updateDate(DateTime.now());
        controller.updateMonth(DateTime.now());
      },
      builder: (con) {
        return Container(
          color: AppColors.whiteColor,
          child: SafeArea(
            top: false,
            child: Scaffold(
              backgroundColor: AppColors.whiteColor,
              appBar: AppBar(
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
                title: AppText.summary.styleSemiBold(
                  size: 20.sp,
                  color: AppColors.primaryColor,
                ),
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(height: 0),
                            20.h.addHSpace(),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 11.w),
                              child: Row(
                                children: [
                                  "Income vs Expense"
                                      .styleSemiBold(size: 18.sp)
                                      .paddingSymmetric(horizontal: 11.w),
                                  Spacer(),
                                  _buildFilterDropdown(),
                                ],
                              ),
                            ),
                            5.h.addHSpace(),

                            Divider(height: 30.h),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 6.w),
                              height: 360.h,
                              child: SfCartesianChart(
                                primaryXAxis: CategoryAxis(),
                                legend: Legend(isVisible: true),
                                tooltipBehavior: TooltipBehavior(enable: true),
                                series: <CartesianSeries<ChartData, String>>[
                                  ColumnSeries<ChartData, String>(
                                    dataSource: controller.chartData,
                                    xValueMapper:
                                        (ChartData data, _) => data.label,
                                    yValueMapper:
                                        (ChartData data, _) => data.income,
                                    name: 'Income',
                                    color: AppColors.greenColor,
                                  ),
                                  ColumnSeries<ChartData, String>(
                                    dataSource: controller.chartData,
                                    xValueMapper:
                                        (ChartData data, _) => data.label,
                                    yValueMapper:
                                        (ChartData data, _) => data.expense,
                                    name: 'Expense',
                                    color: AppColors.redColor,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Divider(height: 50.h),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText.spendAnalytics
                              .styleSemiBold(size: 18.sp)
                              .paddingSymmetric(horizontal: 22.w),
                          20.h.addHSpace(),
                          _buildMonthSelector(context),
                          Divider(height: 50.h),
                          SizedBox(
                            height: 450.h,
                            child: _buildIncomePieChart(incomeData),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterDropdown() {
    return Align(
      alignment: AlignmentGeometry.centerRight,
      child: IntrinsicWidth(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: Colors.grey.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            menuPadding: EdgeInsets.zero,
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                controller.selectedFilter.value.styleSemiBold(),
                const Icon(Icons.keyboard_arrow_down),
              ],
            ),
            onSelected: (value) {
              if (value == "Particular Month") {}
              controller.setFilter(value);
            },
            itemBuilder: (context) {
              return [
                for (int i = 0; i < controller.filters.length; i++) ...[
                  PopupMenuItem<String>(
                    value: controller.filters[i],
                    child:
                        controller.filters[i] == controller.selectedFilter.value
                            ? Row(
                              children: [
                                controller.filters[i].styleMedium(
                                  color: AppColors.primaryColor,
                                ),
                                const Spacer(),
                                const Icon(Icons.check),
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
        ).paddingSymmetric(horizontal: 11.w),
      ),
    );
  }

  Widget _buildMonthSelector(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 22.w),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightPrimaryColor,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                controller.selectedDate.value = DateTime(
                  controller.selectedDate.value.year,
                  controller.selectedDate.value.month - 1,
                );
              },
              icon: Icon(Icons.arrow_back_ios_outlined, size: 18.sp),
            ),
            Spacer(),
            Obx(
              () => GestureDetector(
                onTap:
                    () => controller.pickDate(context, controller.selectedDate),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_month, color: AppColors.primaryColor),
                    5.w.addWSpace(),
                    DateFormat('MMM, yyyy')
                        .format(controller.selectedDate.value)
                        .styleSemiBold(color: AppColors.primaryColor),
                  ],
                ),
              ),
            ),
            Spacer(),
            Obx(() {
              final isLatestMonth =
                  controller.selectedDate.value.year == DateTime.now().year &&
                  controller.selectedDate.value.month == DateTime.now().month;
              return IconButton(
                onPressed:
                    isLatestMonth
                        ? null
                        : () =>
                            controller.selectedDate.value = DateTime(
                              controller.selectedDate.value.year,
                              controller.selectedDate.value.month + 1,
                            ),
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: isLatestMonth ? Colors.grey : AppColors.primaryColor,
                  size: 18.sp,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomePieChart(Map<String, double> incomeData) {
    final sortedEntries =
        incomeData.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final topCategories = sortedEntries.take(4).toList();
    final otherCategories = sortedEntries.skip(4).toList();
    double otherSum = otherCategories.fold(0, (sum, e) => sum + e.value);

    final chartData = <IncomeData>[
      ...topCategories.map((e) => IncomeData(e.key, e.value)),
      if (otherSum > 0) IncomeData("Other", otherSum),
    ];

    return SfCircularChart(
      legend: Legend(
        isVisible: true,
        overflowMode: LegendItemOverflowMode.wrap,
        position: LegendPosition.bottom,
        padding: 5.w,
        itemPadding: 10.w,
        iconHeight: 20.h,
      ),
      annotations: <CircularChartAnnotation>[
        CircularChartAnnotation(
          widget: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              5.h.addHSpace(),
              AppText.totalIncome.styleSemiBold(
                size: 12.sp,
                color: AppColors.primaryColor,
              ),
              '\$${(chartData.fold<double>(0, (sum, item) => sum + item.amount).toInt())}'
                  .styleBold(color: AppColors.primaryColor, size: 15.sp),
            ],
          ),
        ),
      ],
      series: <CircularSeries>[
        DoughnutSeries<IncomeData, String>(
          dataSource: chartData,
          xValueMapper: (IncomeData data, _) => data.category,
          yValueMapper: (IncomeData data, _) => data.amount,
          pointColorMapper: (IncomeData data, index) {
            if (data.category == "Other") {
              return Colors.grey;
            }
            return _getPrimaryShade(index);
          },
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            margin: const EdgeInsets.all(10),
            labelPosition: ChartDataLabelPosition.outside,
            textStyle: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          dataLabelMapper: (IncomeData data, _) {
            final total = chartData.fold<double>(
              0,
              (sum, item) => sum + item.amount,
            );
            final percent = (data.amount / total) * 100;
            return '${percent.toStringAsFixed(1)}%\n(\$${(data.amount.toInt())})';
          },
          radius: "72%",
          innerRadius: "40%",
        ),
      ],
    );
  }

  // Color Shades
  Color _getPrimaryShade(int index) {
    final base = AppColors.primaryColor;
    final strengths = <double>[0.1, 0.25, 0.4, 0.55, 0.7, 0.85];
    final shade = strengths[index % strengths.length];
    return Color.lerp(base, AppColors.whiteColor, shade)!;
  }
}

class ChartData {
  final String label;
  final double income;
  final double expense;

  ChartData(this.label, this.income, this.expense);
}

class IncomeData {
  final String category;
  final double amount;

  IncomeData(this.category, this.amount);
}

// Dummy data
final incomeData = {
  "Food": 1700.00,
  "Shopping": 2000.00,
  "Movie": 1000.00,
  "Medicine": 500.00,
  "Transport": 100.00,
  "Snack": 1000.00,
  "Snacks": 50.00,
  "Books": 70.00,
  "OtherSmall": 20.00,
};
