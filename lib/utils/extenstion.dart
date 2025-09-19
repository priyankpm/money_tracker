import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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

  Text styleRegular({
    Color? color,
    double? size,
    TextAlign? align,
    TextOverflow? overflow,
  }) => fontStyle(
    color: color,
    size: size,
    weight: FontWeight.w400,
    align: align,
    overflow: overflow,
  );

  Text styleMedium({
    Color? color,
    double? size,
    TextAlign? align,
    TextOverflow? overflow,
  }) => fontStyle(
    color: color,
    size: size,
    weight: FontWeight.w500,
    align: align,
    overflow: overflow,
  );

  Text styleSemiBold({
    Color? color,
    double? size,
    TextAlign? align,
    TextOverflow? overflow,
  }) => fontStyle(
    color: color,
    size: size,
    weight: FontWeight.w600,
    align: align,
    overflow: overflow,
  );

  Text styleBold({
    Color? color,
    double? size,
    TextAlign? align,
    TextOverflow? overflow,
  }) => fontStyle(
    color: color,
    size: size,
    weight: FontWeight.w700,
    align: align,
    overflow: overflow,
  );
}

hideKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

String mapAppleErrorToMessage(dynamic error) {
  // if (error is SignInWithAppleAuthorizationException) {
  //   switch (error.code) {
  //     case AuthorizationErrorCode.canceled:
  //       return 'You canceled Apple sign-in.';
  //     case AuthorizationErrorCode.failed:
  //       return 'Apple sign-in failed. Please try again.';
  //     case AuthorizationErrorCode.invalidResponse:
  //       return 'Apple returned an invalid response. Try again later.';
  //     case AuthorizationErrorCode.notHandled:
  //       return 'Apple sign-in could not be handled.';
  //     case AuthorizationErrorCode.unknown:
  //       return 'An unknown error occurred with Apple sign-in.';
  //     default:
  //       return 'Something went wrong. Please try again.';
  //   }
  // } else
  if (error is FirebaseAuthException) {
    return mapFirebaseErrorToMessage(error.code);
  } else {
    return 'Unexpected error. Please try again.';
  }
}

String mapFirebaseErrorToMessage(String code) {
  switch (code) {
    case 'account-exists-with-different-credential':
      return 'An account already exists with a different sign-in method.';
    case 'invalid-credential':
      return 'Your login session expired. Please try again.';
    case 'user-disabled':
      return 'This account has been disabled. Contact support.';
    case 'operation-not-allowed':
      return 'Google sign-in is not enabled. Please try another method.';
    case 'network-request-failed':
      return 'Network error. Please check your internet connection.';
    case 'user-not-found':
      return 'No account found with these details.';
    default:
      return 'Something went wrong. Please try again.';
  }
}


String getTimeBasedGreeting() {
  final now = DateTime.now();
  final hour = now.hour;
  if (hour >= 5 && hour < 12) {
    return 'Good Morning,';
  } else if (hour >= 12 && hour < 17) {
    return 'Good Afternoon,';
  } else if (hour >= 17 && hour < 21) {
    return 'Good Evening,';
  } else {
    return 'Good Night,';
  }
}


Map<String, String> getDayAndDate(DateTime date) => {
  'day': ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1],
  'date': date.day.toString().padLeft(2, '0'),
};