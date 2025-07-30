import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class CaloriesReading extends Equatable {
  CaloriesReading({
    required this.id,
    required this.calories,
    required this.createdAt,
  });
  final String id;
  final int calories;
  final DateTime createdAt;

  factory CaloriesReading.fromJson(Map<String, dynamic> json) {
    return CaloriesReading(
      id: json['id'],
      calories: json['calories'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  factory CaloriesReading.fromFirebase(
    String id,
    Map<String, dynamic> data,
  ) {
    return CaloriesReading.fromJson(
      {...data, "id": id},
    );
  }

  @override
  List<Object?> get props {
    return [calories, createdAt];
  }
}
