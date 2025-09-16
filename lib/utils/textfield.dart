import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_tracker/config/app_color.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;

  const AppTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.textInputType,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: textInputType ?? TextInputType.name,
      textInputAction: textInputAction ?? TextInputAction.done,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColors.lightColor,
        labelText: labelText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 0.7),
          borderRadius: BorderRadius.circular(100.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 0.7),
          borderRadius: BorderRadius.circular(100.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 0.7),
          borderRadius: BorderRadius.circular(100.r),
        ),
      ),
    );
  }
}
