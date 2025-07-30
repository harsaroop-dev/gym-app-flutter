import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class StepsReading extends Equatable {
  StepsReading({
    required this.id,
    required this.steps,
    required this.createdAt,
  });
  final String id;
  final int steps;
  final DateTime createdAt;

  factory StepsReading.fromJson(Map<String, dynamic> json) {
    return StepsReading(
      id: json['id'],
      steps: json['steps'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  factory StepsReading.fromFirebase(
    String id,
    Map<String, dynamic> data,
  ) {
    return StepsReading.fromJson(
      {...data, "id": id},
    );
  }

  @override
  List<Object?> get props {
    return [steps, createdAt];
  }
}
