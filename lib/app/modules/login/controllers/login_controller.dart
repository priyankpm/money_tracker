import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_tracker/app/routes/app_pages.dart';
import 'package:money_tracker/utils/extenstion.dart';
import 'package:money_tracker/utils/shared_prefs.dart';
import 'package:money_tracker/utils/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future loginWithGoogle({required BuildContext context}) async {
    try {
      isLoading.value = true;

      final GoogleSignIn googleSignIn = GoogleSignIn.instance;

      // Must initialize before authenticating
      await googleSignIn.initialize();

      final GoogleSignInAccount user = await googleSignIn.authenticate(scopeHint: ['email']);

      // Get Google tokens (no longer Future, directly available)
      final GoogleSignInAuthentication googleAuth = user.authentication;

      // Create Firebase credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        isLoading.value = false;

        /// Success Store the values
        Get.offAllNamed(Routes.BOTTOMBAR);
        SharedPreference().putString(SharedPreference.USER_UID, firebaseUser.uid);
        SharedPreference().putBool(SharedPreference.IS_LOGGED_IN, true);
        return CommonSnackbar().showSnackbar(message: 'Google Login Successfully', type: SnackbarType.success, context: context);

        // return Right(
        //   UserEntity(uid: firebaseUser.uid, email: firebaseUser.email ?? ''),
        // );
      } else {
        isLoading.value = false;

        /// google_login_failed

        return CommonSnackbar().showSnackbar(message: 'Google Login Failed', type: SnackbarType.error, context: context);

        // return Left(
        //   ServerFailure(AppConstants.globalCtx.loc.google_login_failed),
        // );
      }
    } on GoogleSignInException catch (e) {
      print('=e===$e');
      isLoading.value = false;
      String msg = switch (e.code) {
        GoogleSignInExceptionCode.canceled => 'Cancel User',
        _ => e.description ?? 'Google Login Failed',
      };
      return CommonSnackbar().showSnackbar(message: msg, type: SnackbarType.error, context: context);
    } catch (e) {
      print('=e==1=$e');

      isLoading.value = false;
      return CommonSnackbar().showSnackbar(message: mapAppleErrorToMessage(e), type: SnackbarType.error, context: context);
    }
  }

}