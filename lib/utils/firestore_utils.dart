import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_tracker/app/models/customer_model.dart';
import 'package:money_tracker/config/app_collection.dart';
import 'package:money_tracker/config/app_text.dart';
import 'package:money_tracker/utils/shared_prefs.dart';
import 'package:money_tracker/utils/snackbar.dart';

class FireStoreUtils {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  /// GET UID (throws if no current user)
  static String getCurrentUid() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw StateError(
        'No authenticated user found when requesting current UID.',
      );
    }
    return currentUser.uid;
  }

  /// CHECK USER EXIST OR NOT
  static Future<bool> userExistOrNot() async {
    try {
      final uid = getCurrentUid();
      final doc =
          await fireStore
              .collection(CollectionName.kUserCollection)
              .doc(uid)
              .get();
      return doc.exists;
    } catch (e) {
      log("Error checking if user exists: $e");
      return false;
    }
  }

  /// GET USER PROFILE
  static Future<UserModel?> getUserProfile() async {
    try {
      final uid = getCurrentUid();
      final doc =
          await fireStore
              .collection(CollectionName.kUserCollection)
              .doc(uid)
              .get();
      if (!doc.exists) return null;
      final data = doc.data();
      if (data == null) return null;
      final Map<String, dynamic> json = Map<String, dynamic>.from(data);
      return UserModel.fromJson(json);
    } catch (e) {
      log("Error fetching user profile: $e");
      return null;
    }
  }

  /// UPDATE USER PROFILE (merge by default)
  static Future<bool> updateUser(Map<String, dynamic> userData) async {
    try {
      final uid = getCurrentUid();
      await fireStore
          .collection(CollectionName.kUserCollection)
          .doc(uid)
          .set(userData, SetOptions(merge: true));
      return true;
    } catch (e) {
      log("Error updating user profile: $e");
      return false;
    }
  }

  /// DELETE USER
  static Future<bool> deleteUser() async {
    try {
      final uid = getCurrentUid();
      await fireStore
          .collection(CollectionName.kUserCollection)
          .doc(uid)
          .delete();
      return true;
    } catch (e) {
      log("Error deleting user: $e");
      return false;
    }
  }

  /// CREATE USER DOC FROM FIREBASE AUTH
  static Future<bool> createOrUpdateUserFromAuth(User firebaseUser) async {
    try {
      final exists = await userExistOrNot();
      if (exists) return true;

      final uid = getCurrentUid();
      final Map<String, dynamic> payload = {
        'uid': uid,
        'firstname':
            (firebaseUser.displayName ?? firebaseUser.email?.split("@").first)
                ?.split(" ")
                .first ??
            "",
        'lastname':
            (firebaseUser.displayName != null &&
                    firebaseUser.displayName!.trim().contains(" "))
                ? firebaseUser.displayName!.split(" ").last
                : "",
        'email': firebaseUser.email ?? "",
        'phoneNumber': firebaseUser.phoneNumber ?? "",
        'photoURL': firebaseUser.photoURL ?? "",
        'createdAt': DateTime.now(),
      };

      await fireStore
          .collection(CollectionName.kUserCollection)
          .doc(uid)
          .set(payload, SetOptions(merge: true));

      return true;
    } catch (e) {
      log("Error creating/updating user from FirebaseAuth: $e");
      return false;
    }
  }

  static Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.signOut();
      await googleSignIn.disconnect();
      await preferences.logOut();

      await Future.delayed(Duration(milliseconds: 100)).then((value) {
        CommonSnackbar.showSnackbar(
          message: AppText.logoutSuccess,
          type: SnackbarType.success,
        );
      });
    } catch (e) {
      CommonSnackbar.showSnackbar(
        message: AppText.logoutFailed,
        type: SnackbarType.error,
      );
    }
  }
}
