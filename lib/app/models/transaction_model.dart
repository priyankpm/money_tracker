import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  final String id;
  final String uid;
  final String amount;
  final String note;
  final String type;
  final String category;
  final String attachment;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.uid,
    required this.amount,
    required this.note,
    required this.type,
    required this.category,
    required this.date,
    required this.attachment,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      uid: json['uid'] ?? '',
      amount: json['amount'] ?? '',
      note: json['note'] ?? '',
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      attachment: json['attachment'] ?? '',
      date: (json['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'amount': amount,
      'note': note,
      'type': type,
      'attachment': attachment,
      'category': category,
      'date': Timestamp.fromDate(date),
    };
  }
}
