import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String? photoURL;
  final DateTime createdAt;
  final String firstname;
  final String? phoneNumber;
  final String email;
  final String lastname;

  UserModel({
    required this.uid,
    this.photoURL,
    required this.createdAt,
    required this.firstname,
    this.phoneNumber,
    required this.email,
    required this.lastname,
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
    };
  }
}
