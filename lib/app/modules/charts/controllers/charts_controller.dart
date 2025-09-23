import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_tracker/app/modules/charts/views/charts_view.dart';
import 'package:money_tracker/config/app_color.dart';

class ChartsController extends GetxController {
  Rx<DateTime> selectedDate = DateTime.now().obs;
  Rx<DateTime> selectedMonth = DateTime.now().obs;
  final filters = ["This Week", "This Month", "This Year", "Particular Month"];
  RxString selectedFilter = "This Week".obs;
  final chartData = <ChartData>[].obs;

  Future<void> pickDate(BuildContext context, Rx<DateTime> value) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: value.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Color(0xFF1B183E),
              onPrimary: AppColors.whiteColor,
              onSurface: AppColors.blackColor,
            ),
            dialogTheme: DialogThemeData(backgroundColor: AppColors.whiteColor),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      value.value = picked;
    }
  }

  updateDate(value) => selectedDate.value = value;
  updateMonth(value) => selectedMonth.value = value;

  void setFilter(String filter) {
    selectedFilter.value = filter;
    loadData(filter);
  }

  void loadData(String filter) {
    final weekData = [
      ChartData("Mon", 200, 150),
      ChartData("Tue", 300, 180),
      ChartData("Wed", 250, 220),
      ChartData("Thu", 400, 300),
      ChartData("Fri", 320, 280),
      ChartData("Sat", 180, 200),
      ChartData("Sun", 260, 230),
    ];

    final monthData = [
      ChartData("Week 1", 1200, 900),
      ChartData("Week 2", 1500, 1200),
      ChartData("Week 3", 1800, 1600),
      ChartData("Week 4", 1400, 1100),
    ];

    final yearData = [
      ChartData("Jan", 5000, 4500),
      ChartData("Feb", 4800, 4000),
      ChartData("Mar", 5200, 4700),
      ChartData("Apr", 6000, 5500),
      ChartData("May", 5800, 5000),
      ChartData("Jun", 6200, 5800),
    ];

    if (filter == "This Week") {
      chartData.assignAll(weekData);
    } else if (filter == "This Month") {
      chartData.assignAll(monthData);
    } else if (filter == "This Year") {
      chartData.assignAll(yearData);
    } else if (filter == "Particular Month") {
      chartData.assignAll(weekData);
    }
  }
}
