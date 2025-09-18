import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/utils/extenstion.dart';

enum SnackbarType { success, error }

class CommonSnackbar {
  static void showSnackbar({
    required String message,
    required SnackbarType type,
    Duration duration = const Duration(seconds: 2),
  }) {
    final overlay = Overlay.of(Get.overlayContext!);
    final overlayEntry = OverlayEntry(
      builder: (_) => _TopSnackbarWidget(message: message, type: type),
    );

    overlay.insert(overlayEntry);
    Future.delayed(duration, () => overlayEntry.remove());
  }
}

class _TopSnackbarWidget extends StatelessWidget {
  final String message;
  final SnackbarType type;

  const _TopSnackbarWidget({required this.message, required this.type});

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        type == SnackbarType.success ? Colors.green : Colors.red;

    return Positioned(
      top: MediaQuery.of(context).padding.top + 20.h,
      left: 22.w,
      right: 22.w,
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
          child: message.styleMedium(
            size: 16.sp,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
