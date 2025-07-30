import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/models/stepsReading.dart';

class StepsNotifier extends StateNotifier<List<StepsReading>> {
  StepsNotifier() : super([]);

  void addSteps(List<StepsReading> steps) {
    state = [
      ...steps,
    ];
  }
}

final stepsProvider = StateNotifierProvider<StepsNotifier, List<StepsReading>>(
    (ref) => StepsNotifier());
