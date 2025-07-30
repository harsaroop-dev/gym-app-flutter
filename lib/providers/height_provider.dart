import 'package:flutter_riverpod/flutter_riverpod.dart';

class HeightNotifier extends StateNotifier<List<double>> {
  HeightNotifier() : super([]);

  void addHeight(double height) {
    state = [...state, height];
  }
}

final heightsProvider = StateNotifierProvider<HeightNotifier, List<double>>(
    (ref) => HeightNotifier());
