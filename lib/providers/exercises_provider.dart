import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/models/exercise.dart';

class ExercisesNotifier extends StateNotifier<List<Exercise>> {
  ExercisesNotifier() : super([]);

  void addExercises(List<Exercise> exercises) {
    state = [
      ...state,
      ...exercises
          .where((newExercise) =>
              state.map((exercise) => exercise.id).contains(newExercise.id) ==
              false)
          .toList(),
    ];
  }

  void emptyExercises() {
    state = [];
  }
}

final exercisesProvider =
    StateNotifierProvider<ExercisesNotifier, List<Exercise>>(
        (ref) => ExercisesNotifier());
