import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/models/weightReading.dart';

import '../models/sleepReading.dart';

class SleepNotifier extends StateNotifier<List<SleepReading>> {
  SleepNotifier() : super([]);

  void addSleep(List<SleepReading> sleep) {
    state = [
      ...sleep,
    ];
  }
}

final sleepProvider = StateNotifierProvider<SleepNotifier, List<SleepReading>>(
    (ref) => SleepNotifier());
