import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/models/exercise.dart';

class SelectedExerciseNotifier extends StateNotifier<List<Exercise>> {
  SelectedExerciseNotifier() : super([]);

  void addExercise(Exercise exercise) {
    if (state.contains(exercise)) {
      state = state.where((e) => e.id != exercise.id).toList();
    } else {
      state = [...state, exercise];
    }
  }
}

final selectedExerciseProvider =
    StateNotifierProvider<SelectedExerciseNotifier, List<Exercise>>((ref) {
  return SelectedExerciseNotifier();
});
