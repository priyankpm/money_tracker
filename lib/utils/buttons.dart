import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_tracker/config/app_color.dart';

class AppButton extends StatelessWidget {
  final Widget child;
  final Color? buttonColor;
  final Color? borderColor;
  final void Function()? onTap;
  const AppButton({
    super.key,
    required this.child,
    this.buttonColor,
    this.borderColor, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap,
      child: Container(
        height: 65.h,
        margin: EdgeInsets.symmetric(horizontal: 28.w),
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? AppColors.primaryColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
          color: buttonColor ?? AppColors.primaryColor,
          borderRadius: BorderRadius.circular(100.r),
        ),
        child: child,
      ),
    );
  }
}
