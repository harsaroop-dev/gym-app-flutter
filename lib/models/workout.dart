import 'package:gym_app/models/muscle.dart';

class Workout {
  Workout({
    required this.id,
    required this.muscles,
    required this.name,
  });
  final String id;
  final String name;
  final List<Muscle> muscles;

  factory Workout.fromFirebase(
      String id, Map<String, dynamic> data, List<Muscle> muscles) {
    return Workout.fromJson({
      ...data,
      'id': id,
      'muscles': muscles,
    });
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      name: json['name'],
      muscles: json['muscles'],
    );
  }
}
