import 'package:equatable/equatable.dart';

class Exercise extends Equatable {
  Exercise({
    required this.id,
    required this.name,
  });
  final String id;
  final String name;

  // @override
  // bool operator ==(Object other) {
  //   return (other is Exercise) && other.name == name && other.id == id;
  // }

  factory Exercise.fromFirebase(
    String id,
    Map<String, dynamic> data,
  ) {
    return Exercise.fromJson({
      ...data,
      "id": id,
    });
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(id: json['id'], name: json['name']);
  }

  // @override
  // int get hashCode => id.hashCode ^ name.hashCode;

  @override
  List<Object?> get props {
    return [id, name];
  }
}
