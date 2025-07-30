import 'package:flutter_riverpod/flutter_riverpod.dart';

class WaterNotifier extends StateNotifier<List<int>> {
  WaterNotifier() : super([]);

  void addWater(int water) {
    state = [...state, water];
  }
}

final waterProvider =
    StateNotifierProvider<WaterNotifier, List<int>>((ref) => WaterNotifier());
