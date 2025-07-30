import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/models/weightReading.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeightsNotifier extends StateNotifier<List<WeightReading>> {
  WeightsNotifier() : super([]);

  void addWeight(List<WeightReading> weight) {
    // final SharedPreferences prefs = await SharedPreferences.getInstance();

    // if (weightList.getStringList('weightList') != null) {
    // if (prefs.getString("weightList1") != null) {
    //   String json = prefs.getString("weightList1")!;
    //   state = (jsonDecode(json) as List<dynamic>)
    //       .map(
    //         (e) => e as double,
    //       )
    //       .toList();
    // state = (weightList
    //     .getStringList("weightList")!
    //     .map((e) => double.parse(e))
    //     .toList());
    // }
    state = [
      // ...state,
      // ...weight
      //     .where((newWeight) =>
      //         state.map((weight) => weight.id).contains(newWeight.id) == false)
      //     .toList(),
      ...weight,
    ];

    // String json = jsonEncode(state);
    // prefs.setString("weightList1", json);
    // weightList.setStringList(
    //     "weightList", state.map((e) => e.toString()).toList());
  }
}

final weightsProvider =
    StateNotifierProvider<WeightsNotifier, List<WeightReading>>(
        (ref) => WeightsNotifier());
