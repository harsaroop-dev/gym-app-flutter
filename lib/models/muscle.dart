import 'package:gym_app/models/exercise.dart';

class Muscle {
  Muscle({
    required this.id,
    required this.name,
    required this.exercises,
  });
  final String id;
  final String name;
  final List<Exercise> exercises;

  factory Muscle.fromFirebase(
    String id,
    Map<String, dynamic> data,
    List<Exercise> exercises,
  ) {
    return Muscle.fromJson({
      ...data,
      'id': id,
      'exercises': exercises,
    });
  }

  factory Muscle.fromJson(Map<String, dynamic> json) {
    return Muscle(
      id: json['id'],
      name: json['name'],
      exercises: json['exercises'],
    );
  }
}
