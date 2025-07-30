// import 'dart:convert';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gym_app/models/weightReading.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class UserVitalsData {
//   final List<WeightReading> weights;
//   final List<int> calories;
//   final List<int> steps;
//   final List<double> sleep;

//   UserVitalsData({
//     required this.weights,
//     required this.calories,
//     required this.steps,
//     required this.sleep,
//   });

//   UserVitalsData copyWith({
//     List<WeightReading>? weights,
//     List<int>? calories,
//     List<int>? steps,
//     List<double>? sleep,
//   }) {
//     return UserVitalsData(
//       weights: weights != null ? [...weights] : this.weights,
//       calories: calories != null ? [...calories] : this.calories,
//       steps: steps != null ? [...steps] : this.steps,
//       sleep: sleep != null ? [...sleep] : this.sleep,
//     );
//   }
// }

// class UserVitalsNotifier extends StateNotifier<UserVitalsData> {
//   UserVitalsNotifier()
//       : super(
//           UserVitalsData(
//             calories: [],
//             weights: [],
//             steps: [],
//             sleep: [],
//           ),
//         );

//   void addCaloryReading(int calory) {
//     state = state.copyWith(
//       calories: [...state.calories, calory],
//     );
//     _saveCurrentStateToLocalStorage();
//   }

//   void addWeightReading(WeightReading weight) {
//     state = state.copyWith(
//       weights: [...state.weights, weight],
//     );
//     _saveCurrentStateToLocalStorage();
//   }

//   void addStepReading(int step) {
//     state = state.copyWith(
//       steps: [...state.steps, step],
//     );
//     _saveCurrentStateToLocalStorage();
//   }

//   void addSleepReading(double sleep) {
//     state = state.copyWith(
//       sleep: [...state.sleep, sleep],
//     );
//     _saveCurrentStateToLocalStorage();
//   }

// // weight = [WeightReading(weight: weight, recordedAt: recordedAt)]
//   void _saveCurrentStateToLocalStorage() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();

//     // String json = jsonEncode(state.weights);
//     prefs.setString(
//       "weightList2",
//       jsonEncode(
//         state.weights
//             .map(
//               (e) => {e.createdAt.toIso8601String(): e.weight},
//             )
//             .toList(),
//       ),
//     );
//     prefs.setString("caloriesList", jsonEncode(state.calories));
//     prefs.setString("stepList", jsonEncode(state.steps));
//     prefs.setString("sleepList", jsonEncode(state.sleep));
//   }

//   void initDataFromLocalStorage() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();

//     if (prefs.getString("weightList2") != null) {
//       String json = prefs.getString("weightList2")!;
//       final listWeight = (jsonDecode(json) as List<dynamic>)
//           .map(
//             (e) => e as Map<String, dynamic>,
//           )
//           .map(
//             (e) => WeightReading(
//               weight: e.values.first as double,
//               createdAt: DateTime.parse(e.keys.first),
//             ),
//           )
//           .toList();

//       state = state.copyWith(weights: listWeight);
//     }
//     if (prefs.getString("caloriesList") != null) {
//       String json = prefs.getString("caloriesList")!;
//       final caloryList = (jsonDecode(json) as List<dynamic>)
//           .map(
//             (e) => e as int,
//           )
//           .toList();
//       state = state.copyWith(calories: caloryList);
//     }
//     if (prefs.getString("stepList") != null) {
//       String json = prefs.getString("stepList")!;
//       final stepList = (jsonDecode(json) as List<dynamic>)
//           .map(
//             (e) => e as int,
//           )
//           .toList();
//       state = state.copyWith(steps: stepList);
//     }
//     if (prefs.getString("sleepList") != null) {
//       String json = prefs.getString("sleepList")!;
//       final sleepList = (jsonDecode(json) as List<dynamic>)
//           .map(
//             (e) => e as double,
//           )
//           .toList();
//       state = state.copyWith(sleep: sleepList);
//     }
//   }
// }

// final userVitalsProvider =
//     StateNotifierProvider<UserVitalsNotifier, UserVitalsData>(
//         (ref) => UserVitalsNotifier());
