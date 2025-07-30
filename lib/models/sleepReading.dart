import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class SleepReading extends Equatable {
  SleepReading({
    required this.id,
    required this.sleep,
    required this.createdAt,
  });
  final String id;
  final double sleep;
  final DateTime createdAt;

  factory SleepReading.fromJson(Map<String, dynamic> json) {
    return SleepReading(
      id: json['id'],
      sleep: json['sleep'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  factory SleepReading.fromFirebase(
    String id,
    Map<String, dynamic> data,
  ) {
    return SleepReading.fromJson(
      {...data, "id": id},
    );
  }

  @override
  List<Object?> get props {
    return [sleep, createdAt];
  }
}
