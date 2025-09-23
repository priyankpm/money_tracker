import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String title;
  final String icon;
  final int categoryId;
  final DateTime date;

  CategoryModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.date,
    required this.categoryId,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      categoryId: json['category_id'] ?? 1,
      icon: json['icon'] ?? '',
      date: (json['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category_id': categoryId,
      'icon': icon,
      'date': Timestamp.fromDate(date),
    };
  }
}
