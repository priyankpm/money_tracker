import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String uid;
  final String amount;
  final String description;
  final String type;
  final String title;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.uid,
    required this.amount,
    required this.description,
    required this.type,
    required this.title,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      uid: json['uid'] ?? '',
      amount: json['amount'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      date: (json['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'amount': amount,
      'description': description,
      'type': type,
      'title': title,
      'date': Timestamp.fromDate(date),
    };
  }
}
