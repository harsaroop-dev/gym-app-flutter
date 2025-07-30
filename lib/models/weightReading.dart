import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class WeightReading extends Equatable {
  WeightReading({
    required this.id,
    required this.weight,
    required this.createdAt,
  });
  final String id;
  final double weight;
  final DateTime createdAt;

  /**
   * {
   *  "id": "abc123",
   * "weight: 23.4,
   * "createdAt": Timestamp
   * }
   */

  factory WeightReading.fromJson(Map<String, dynamic> json) {
    return WeightReading(
      id: json['id'],
      weight: json['weight'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  factory WeightReading.fromFirebase(
    String id,
    Map<String, dynamic> data,
  ) {
    return WeightReading.fromJson(
      {...data, "id": id},
    );
  }

  @override
  List<Object?> get props {
    return [weight, createdAt];
  }
}
