import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:money_tracker/config/app_color.dart';
import 'package:money_tracker/utils/extenstion.dart';

class CommonSnackbar {
  void showSnackbar({required String message, required SnackbarType type, required BuildContext context}) {
    TopSnackbar.show(
      context,
      message: message,
      type: type,
    );
  }
}

enum SnackbarType { success, error }

class TopSnackbar {
  static void show(
      BuildContext context, {
        required String message,
        required SnackbarType type,
        Duration duration = const Duration(seconds: 2),
      }) {
    final overlay = Overlay.of(context);
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

  const _TopSnackbarWidget({
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = type == SnackbarType.success ? Colors.green : Colors.red;
    return Positioned(
      top: MediaQuery.of(context).padding.top + 20,
      left: 12,
      right: 12,
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.circular(8),
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
          child: message.styleSemiBold(
            size: 13.sp,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}