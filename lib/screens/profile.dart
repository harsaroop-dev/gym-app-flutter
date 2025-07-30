import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/models/weightReading.dart';
import 'package:gym_app/providers/user_vitals_provider.dart';
import 'package:gym_app/providers/userdata_provider.dart';
import 'package:gym_app/widgets/user_data.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  double _yAxisCalc(
    List<DateTime> allDates,
    List<WeightReading> weightReadings,
  ) {
    final currentDay = (allDates.first.millisecondsSinceEpoch +
            allDates.last.millisecondsSinceEpoch) /
        2.0;

    final listOfDays = allDates.map((e) => e.millisecondsSinceEpoch).toList();
    var greaterDayIdx = 0;
    var lowerDayIdx = 0;
    var i = 0;

    for (final d in listOfDays) {
      if (d > currentDay) {
        greaterDayIdx = i;
        lowerDayIdx = i - 1;
        break;
      }
      i++;
    }

    final greaterDay = listOfDays[greaterDayIdx];
    final lowerDay = listOfDays[lowerDayIdx];

    final greaterWeight = weightReadings
        .firstWhere((e) => e.createdAt.millisecondsSinceEpoch == greaterDay)
        .weight;
    final lowerWeight = weightReadings
        .lastWhere((e) => e.createdAt.millisecondsSinceEpoch == lowerDay)
        .weight;

    final s = (currentDay - lowerDay) / (greaterDay - lowerDay);
    // s = y0 - y1/ y2 - y1
    final y = ((s * (greaterWeight - lowerWeight)) + lowerWeight);

    // final m = (greaterWeight - lowerWeight) / (greaterDay - lowerDay);

    // final b = lowerWeight / m * lowerDay;

    // final y = m * currentDay + b;
    return y;
  }

  Widget profilePicture() {
    if (ref.watch(userDataProvider)?.photoURL != null) {
      return Image.network(ref.watch(userDataProvider)!.photoURL!,
          height: 100, width: 100);
    } else {
      return Icon(Icons.person, size: 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = ref.watch(userDataProvider);

    return const SizedBox.shrink();
    // final userVitals = ref.watch(userVitalsProvider);
    // var weight = [...userVitals.weights];
    // weight.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // final yMin = weight.map((e) => e.weight).reduce(min);
    // final yMax = weight.map((e) => e.weight).reduce(max);

    // final allDates = weight.map((e) => e.createdAt).toList();

    // // weight.add(
    // //   WeightReading(
    // //     weight: _yAxisCalc(allDates, weight),
    // //     createdAt: DateTime.fromMicrosecondsSinceEpoch(
    // //         allDates.first.microsecondsSinceEpoch +
    // //             (allDates.last.microsecondsSinceEpoch -
    // //                     allDates.first.microsecondsSinceEpoch) ~/
    // //                 2),
    // //   ),
    // // );

    // final checkDate = weight.map((e) => e.createdAt).toList();

    // final showDates = [
    //   allDates.first,
    //   DateTime.fromMillisecondsSinceEpoch(
    //       (allDates.first.millisecondsSinceEpoch +
    //               allDates.last.millisecondsSinceEpoch) ~/
    //           2),
    //   // allDates[allDates.last.day - allDates.first.day ~/ 2],
    //   // allDates[allDates.length ~/ 4],
    //   // allDates[allDates.length ~/ 2],
    //   // allDates[(allDates.length ~/ 4) * 3],
    //   allDates.last
    // ];

    // // print(yMin);
    // // print(yMax);

    // return Scaffold(
    //   // appBar: AppBar(
    //   //   // title: const Text('Profile'),
    //   //   centerTitle: true,
    //   // ),
    //   body: Column(
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       profilePicture(),
    //       const SizedBox(height: 18),
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           Icon(Icons.verified),
    //           SizedBox(width: 5),
    //           Text('${userData!.displayName}',
    //               style: TextStyle(
    //                 fontWeight: FontWeight.bold,
    //                 fontSize: 20,
    //               )),
    //         ],
    //       ),
    //       const SizedBox(height: 20),
    //       const Padding(
    //         padding: EdgeInsets.symmetric(horizontal: 9),
    //         child: Text(
    //           '"The meaning of life is not simply to exist, to survive, but to move ahead, to go up, to conquer." – Arnold Schwarzenegger, 7-time Mr Olympia',
    //           textAlign: TextAlign.center,
    //         ),
    //       ),
    //       const SizedBox(height: 20),
    //       const Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           UserData(
    //             icon: Icons.directions_walk,
    //             data: 'Weight',
    //             color: Colors.red,
    //           ),
    //           UserData(
    //             icon: Icons.bedtime,
    //             data: 'Height',
    //             color: Colors.amber,
    //           ),
    //           UserData(
    //             icon: Icons.water_drop,
    //             data: 'Water',
    //             color: Colors.blue,
    //           ),
    //         ],
    //       ),
    //       const SizedBox(height: 20),
    //       Container(
    //         padding: EdgeInsets.symmetric(horizontal: 30),
    //         child: Row(
    //           children: [
    //             Expanded(
    //               flex: 2,
    //               child: FilledButton(
    //                 onPressed: () {},
    //                 style: FilledButton.styleFrom(
    //                   foregroundColor: Colors.blue[900],
    //                   backgroundColor: Colors.blue.withOpacity(0.3),
    //                   shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(8),
    //                   ),
    //                 ),
    //                 child: Text('Edit Profile'),
    //               ),
    //             ),
    //             const SizedBox(width: 35),
    //             Expanded(
    //               flex: 2,
    //               child: OutlinedButton(
    //                 onPressed: () {},
    //                 style: OutlinedButton.styleFrom(
    //                   foregroundColor: Colors.blue[900],
    //                   side: BorderSide(color: Colors.blue),
    //                   shape: RoundedRectangleBorder(
    //                     borderRadius: BorderRadius.circular(8),
    //                   ),
    //                 ),
    //                 child: Text('Share Profile'),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //       Expanded(
    //         child: Padding(
    //           padding: const EdgeInsets.only(
    //               left: 25, top: 20, bottom: 15, right: 25),
    //           child: LineChart(
    //             LineChartData(
    //               lineBarsData: [
    //                 LineChartBarData(
    //                   spots: [
    //                     for (final reading in weight)
    //                       FlSpot(
    //                         () {
    //                           // return (reading
    //                           //             .createdAt.millisecondsSinceEpoch /
    //                           //         1000)
    //                           //     .toDouble();
    //                           var num = reading.createdAt.year;
    //                           num *= 100;
    //                           num += reading.createdAt.month;
    //                           num *= 100;
    //                           num += reading.createdAt.day;
    //                           num *= 100;
    //                           num += reading.createdAt.hour;
    //                           return num.toDouble();
    //                         }(),
    //                         // reading.createdAt,
    //                         reading.weight,
    //                       ),
    //                     // FlSpot(1, 1),
    //                     // FlSpot(2, 20),
    //                     // FlSpot(3, 40),
    //                   ],
    //                   // show: checkDate.contains(
    //                   //   DateTime.fromMicrosecondsSinceEpoch(
    //                   //       (allDates.first.microsecondsSinceEpoch +
    //                   //               allDates.last.microsecondsSinceEpoch) ~/
    //                   //           2),
    //                   // )
    //                   //     ? false
    //                   //     : true,
    //                   color: Colors.black,
    //                 ),
    //               ],
    //               titlesData: FlTitlesData(
    //                 topTitles: AxisTitles(
    //                   sideTitles: SideTitles(showTitles: false),
    //                 ),
    //                 rightTitles: AxisTitles(
    //                   sideTitles: SideTitles(showTitles: false),
    //                 ),
    //                 leftTitles: AxisTitles(
    //                   axisNameWidget: Text('Weight(in kg)'),
    //                   sideTitles: SideTitles(
    //                     showTitles: true,
    //                     reservedSize: 35,
    //                   ),
    //                 ),
    //                 bottomTitles: AxisTitles(
    //                   axisNameWidget: Text('date'),
    //                   sideTitles: SideTitles(
    //                     getTitlesWidget: (value, meta) {
    //                       return SideTitleWidget(
    //                         axisSide: AxisSide.bottom,
    //                         space: 12,
    //                         angle: 0.6,
    //                         child: Text(showDates
    //                                 .map((e) =>
    //                                     (((e.year * 100) + e.month) * 100 +
    //                                             e.day) *
    //                                         100 +
    //                                     e.hour)
    //                                 .toList()
    //                                 .contains(value.toInt())
    //                             ? '${value ~/ 100.toInt() % 100}/${value ~/ 100.toInt() ~/ 100 % 100}/${value ~/ 100.toInt() ~/ 10000}'
    //                             : ''),
    //                       );
    //                     },
    //                     showTitles: true,
    //                     reservedSize: 30,
    //                     interval: 1,
    //                   ),
    //                 ),
    //               ),
    //               // minX: 1,
    //               // maxX: 31,
    //               minY: yMin,
    //               maxY: yMax,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
