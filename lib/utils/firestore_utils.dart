import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:money_tracker/app/models/customer_model.dart';
import 'package:money_tracker/config/app_collection.dart';

class FireStoreUtils {
  static FirebaseFirestore fireStore = FirebaseFirestore.instance;

  /// GET UID
  static String getCurrentUid() {
    return FirebaseAuth.instance.currentUser!.uid;
  }


  /// CHECK USER EXIST OR NOT
  static Future<bool> userExistOrNot() async {
    final uid = FireStoreUtils.getCurrentUid();
    try {
      final doc =
          await fireStore
              .collection(CollectionName.kUserCollection)
              .doc(uid)
              .get();
      return doc.exists;
    } on FirebaseException catch (e) {
      log(
        "Firebase error while checking user existence for [$uid]: ${e.message}",
      );
      return false;
    } catch (e) {
      log("Unexpected error while checking user existence for [$uid]");
      return false;
    }
  }

  /// GET USER PROFILE
  static Future<UserModel?> getUserProfile() async {
    final uid = FireStoreUtils.getCurrentUid();
    try {
      final doc =
          await fireStore
              .collection(CollectionName.kUserCollection)
              .doc(uid)
              .get();
      if (!doc.exists) {
        log("ℹ️ User profile not found for [$uid]");
        return null;
      }
      final data = doc.data();
      if (data == null) {
        log("⚠User profile data is null for [$uid]");
        return null;
      }
      return UserModel.fromJson(data);
    } on FirebaseException catch (e) {
      log(
        "Firebase error while fetching user profile for [$uid]: ${e.message}",
      );
      return null;
    } catch (e) {
      log("Unexpected error while fetching user profile for [$uid]");
      return null;
    }
  }

  /// UPDATE USER PROFILE
  static Future<bool> updateUser(Map<String, dynamic> userData) async {
    final uid = FireStoreUtils.getCurrentUid();
    try {
      await fireStore
          .collection(CollectionName.kUserCollection)
          .doc(uid)
          .set(userData, SetOptions(merge: true));

      log("User [$uid] updated successfully");
      return true;
    } on FirebaseException catch (e) {
      log("Firebase error while updating user [$uid]: ${e.message}");
      return false;
    } catch (e) {
      log("Unexpected error while updating user [$uid]");
      return false;
    }
  }


  /// DELETE USER
  static Future<bool> deleteUser() async {
    final uid = FireStoreUtils.getCurrentUid();
    try {
      await fireStore
          .collection(CollectionName.kUserCollection)
          .doc(uid)
          .delete();
      log("User [$uid] deleted successfully");
      return true;
    } on FirebaseException catch (e) {
      log("Firebase error while deleting user [$uid]: ${e.message}");
      return false;
    } catch (e) {
      log("Unexpected error while deleting user [$uid]");
      return false;
    }
  }
}
