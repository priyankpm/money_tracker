import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizedExtension on double {
  Widget addHSpace() => SizedBox(height: this);
  Widget addWSpace() => SizedBox(width: this);
}

extension StringExtensions on String {
  String capitalize() =>
      isEmpty ? this : "${this[0].toUpperCase()}${substring(1)}";
  String toTitleCase() => split(' ')
      .map(
        (word) =>
            word.isNotEmpty
                ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                : "",
      )
      .join(' ');
}

extension FontStyle on String {
  Text fontStyle({
    Color? color,
    double? size,
    FontWeight? weight,
    TextDecoration? decoration,
    TextOverflow? overflow,
    TextAlign? align,
  }) {
    return Text(
      this,
      overflow: overflow ?? TextOverflow.ellipsis,
      textAlign: align,
      style: TextStyle(
        color: color ?? Colors.black,
        fontSize: size ?? 16.sp,
        fontWeight: weight ?? FontWeight.w400,
        decoration: decoration ?? TextDecoration.none,
        fontFamily: "Montserrat",
      ),
    );
  }

  Text styleRegular({Color? color, double? size, TextAlign? align}) =>
      fontStyle(
        color: color,
        size: size,
        weight: FontWeight.w400,
        align: align,
      );

  Text styleMedium({Color? color, double? size, TextAlign? align}) => fontStyle(
    color: color,
    size: size,
    weight: FontWeight.w500,
    align: align,
  );

  Text styleSemiBold({Color? color, double? size, TextAlign? align}) =>
      fontStyle(
        color: color,
        size: size,
        weight: FontWeight.w600,
        align: align,
      );

  Text styleBold({Color? color, double? size, TextAlign? align}) => fontStyle(
    color: color,
    size: size,
    weight: FontWeight.w700,
    align: align,
  );
}

hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}
