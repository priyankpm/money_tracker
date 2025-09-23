import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? photoURL;
  final DateTime createdAt;
  final String firstname;
  final String? phoneNumber;
  final String email;
  final String lastname;
  final double totalExpense;
  final double totalIncome;

  UserModel({
    required this.uid,
    this.photoURL,
    required this.createdAt,
    required this.firstname,
    this.phoneNumber,
    required this.email,
    required this.lastname,
    required this.totalExpense,
    required this.totalIncome,
  });

  // Factory method to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      photoURL: json['photoURL'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      firstname: json['firstname'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      lastname: json['lastname'],
      totalExpense: json['totalExpense'].toDouble() ?? 0,
      totalIncome: json['totalIncome'].toDouble() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'photoURL': photoURL,
      'createdAt': Timestamp.fromDate(createdAt),
      'firstname': firstname,
      'phoneNumber': phoneNumber,
      'email': email,
      'lastname': lastname,
      'totalExpense': totalExpense,
      'totalIncome': totalIncome,
    };
  }
}
