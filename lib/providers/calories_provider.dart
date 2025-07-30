import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/models/weightReading.dart';

import '../models/caloriesReading.dart';

class CaloriesNotifier extends StateNotifier<List<CaloriesReading>> {
  CaloriesNotifier() : super([]);

  void addCalories(List<CaloriesReading> calories) {
    state = [
      ...calories,
    ];
  }
}

final caloriesProvider =
    StateNotifierProvider<CaloriesNotifier, List<CaloriesReading>>(
        (ref) => CaloriesNotifier());
