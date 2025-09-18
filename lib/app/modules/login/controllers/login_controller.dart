import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_tracker/app/routes/app_pages.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/extenstion.dart';
import 'package:money_tracker/utils/firestore_utils.dart';
import 'package:money_tracker/utils/shared_prefs.dart';
import 'package:money_tracker/utils/snackbar.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;

  Future<void> loginWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();

      final GoogleSignInAccount user = await googleSignIn.authenticate(
        scopeHint: ['email'],
      );
      final GoogleSignInAuthentication googleAuth = user.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        isLoading.value = false;
        await FireStoreUtils.createOrUpdateUserFromAuth(firebaseUser);
        Get.offAllNamed(Routes.BOTTOMBAR);
        preferences.putString(SharedPreference.USER_UID, firebaseUser.uid);
        preferences.putString(
          SharedPreference.USER_NAME,
          firebaseUser.displayName ?? ""
        );
        
        preferences.putBool(SharedPreference.IS_LOGGED_IN, true);
        await Future.delayed(Duration(milliseconds: 100)).then((value) {
          return CommonSnackbar.showSnackbar(
            message: AppText.loginSuccess,
            type: SnackbarType.success,
          );
        });
      } else {
        isLoading.value = false;
        return CommonSnackbar.showSnackbar(
          message: AppText.loginFailed,
          type: SnackbarType.error,
        );
      }
    } on GoogleSignInException catch (e) {
      isLoading.value = false;
      String msg = switch (e.code) {
        GoogleSignInExceptionCode.canceled => 'Cancel User',
        _ => e.description ?? AppText.loginFailed,
      };
      return CommonSnackbar.showSnackbar(
        message: msg,
        type: SnackbarType.error,
      );
    } catch (e) {
      isLoading.value = false;
      return CommonSnackbar.showSnackbar(
        message: mapAppleErrorToMessage(e),
        type: SnackbarType.error,
      );
    }
  }
}
