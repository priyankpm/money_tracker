import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_tracker/config/app_color.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final Color? buttonColor;
  const AppButton({super.key, required this.child,  this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 67.h,
      margin: EdgeInsets.symmetric(horizontal: 28.w),
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
        color: buttonColor ?? AppColors.primaryColor,
        borderRadius: BorderRadius.circular(100.r),
      ),
      child: child,
    );
  }
}
