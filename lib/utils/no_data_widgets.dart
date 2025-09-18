import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/config/app_images.dart';
import 'package:money_tracker/utils/extenstion.dart';

class NoDataWidget extends StatelessWidget {
  final String msg;
  const NoDataWidget({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(AppImages.noData, height: 120.h),
            8.h.addHSpace(),
            msg.styleSemiBold(color: AppColors.greyColor),
          ],
        ),
      ),
    );
  }
}
