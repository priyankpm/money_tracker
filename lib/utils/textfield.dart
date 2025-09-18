import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_tracker/config/app_color.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final int? minLines;
  final Widget? suffix;
  final bool? readonly;
  final void Function()? onTap;
  final int? maxLength;

  const AppTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.textInputType,
    this.textInputAction,
    this.maxLines,
    this.minLines,
    this.suffix,
    this.onTap,
    this.readonly,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readonly ?? false,
      onTap: onTap,
      minLines: minLines ?? 1,
      maxLines: maxLines,
      controller: controller,
      maxLength: maxLength,
      keyboardType: textInputType ?? TextInputType.name,
      textInputAction: textInputAction ?? TextInputAction.done,
      decoration: InputDecoration(
        counterText: '',
        suffixIcon: suffix,
        contentPadding: EdgeInsets.all(15.h),
        hint: Text(labelText),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.greyColor, width: 0.7),
          borderRadius: BorderRadius.circular(8.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.greyColor, width: 0.7),
          borderRadius: BorderRadius.circular(8.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.greyColor, width: 0.7),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}
