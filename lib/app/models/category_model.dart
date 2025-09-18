import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String title;
  final DateTime date;

  CategoryModel({
    required this.id,
    required this.title,
    required this.date,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      date: (json['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'date': Timestamp.fromDate(date),
    };
  }
}
