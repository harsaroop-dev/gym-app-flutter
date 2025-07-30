import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/models/caloriesReading.dart';
import 'package:gym_app/models/sleepReading.dart';
import 'package:gym_app/models/stepsReading.dart';
import 'package:gym_app/models/weightReading.dart';
import 'package:gym_app/providers/calories_provider.dart';
import 'package:gym_app/providers/height_provider.dart';
import 'package:gym_app/providers/sleep_provider.dart';
import 'package:gym_app/providers/steps_provider.dart';
import 'package:gym_app/providers/user_vitals_provider.dart';
import 'package:gym_app/providers/userdata_provider.dart';
import 'package:gym_app/providers/water_provider.dart';
import 'package:gym_app/providers/weights_provider.dart';
import 'package:gym_app/screens/weight_screen.dart';
import 'package:gym_app/utils/enums.dart';
import 'package:gym_app/widgets/circle_stacked_child.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Health().configure();
    fetchStepData();
    final _weightStream = FirebaseFirestore.instance
        .collection('users')
        .doc(ref.read(userDataProvider)!.uid)
        .collection('weight')
        .orderBy('createdAt', descending: true)
        // .limit(1)
        .snapshots()
        .asBroadcastStream();

    final _sleepStream = FirebaseFirestore.instance
        .collection('users')
        .doc(ref.read(userDataProvider)!.uid)
        .collection('sleep')
        .orderBy('createdAt', descending: true)
        // .limit(1)
        .snapshots()
        .asBroadcastStream();

    final _caloriesStream = FirebaseFirestore.instance
        .collection('users')
        .doc(ref.read(userDataProvider)!.uid)
        .collection('calories')
        .orderBy('createdAt', descending: true)
        // .limit(1)
        .snapshots()
        .asBroadcastStream();

    final _stepsStream = FirebaseFirestore.instance
        .collection('users')
        .doc(ref.read(userDataProvider)!.uid)
        .collection('steps')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asBroadcastStream();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _weightStream.listen((snapshot) {
        print(snapshot.docs.first.data());
        final _weightList = snapshot.docs
            .map(
              (weightDoc) => WeightReading.fromFirebase(
                weightDoc.id,
                weightDoc.data(),
              ),
            )
            .toList();
        ref.read(weightsProvider.notifier).addWeight(_weightList);
      });

      _sleepStream.listen((snapshot) {
        print(snapshot.docs.first.data());
        final _sleepList = snapshot.docs
            .map(
              (sleepDoc) => SleepReading.fromFirebase(
                sleepDoc.id,
                sleepDoc.data(),
              ),
            )
            .toList();
        ref.read(sleepProvider.notifier).addSleep(_sleepList);
      });

      _caloriesStream.listen((snapshot) {
        print(snapshot.docs.first.data());
        final _caloriesList = snapshot.docs
            .map(
              (caloriesDoc) => CaloriesReading.fromFirebase(
                caloriesDoc.id,
                caloriesDoc.data(),
              ),
            )
            .toList();
        ref.read(caloriesProvider.notifier).addCalories(_caloriesList);
      });

      _stepsStream.listen((snapshot) {
        final stepsList = snapshot.docs
            .map(
              (stepsDoc) =>
                  StepsReading.fromFirebase(stepsDoc.id, stepsDoc.data()),
            )
            .toList();
        ref.read(stepsProvider.notifier).addSteps(stepsList);
      });
    });
  }

  final _dataController = TextEditingController();

  void _onSelectWeight(Goal goal) async {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return WeightScreen(
        goal: goal,
      );
    }));
    // final userInput = await InputDialog(goal);
    // if (userInput != null) {
    //   switch (goal) {
    //     case Goal.weight:
    //       double weight = double.parse(userInput!);
    //       // ref.read(weightsProvider.notifier).addWeight(weight);
    //       // ref.read(weightsProvider.notifier).addWeight(weight);
    //       // ref.read(userVitalsProvider.notifier).addWeightReading(
    //       // WeightReading(
    //       //   weight: weight,
    //       //   createdAt: DateTime.now(),
    //       // ),
    //       // );

    //       FirebaseFirestore.instance
    //           .collection('users')
    //           .doc(ref.read(userDataProvider)!.uid)
    //           .collection('weight')
    //           .add({
    //         'weight': weight,
    //         'createdAt': DateTime.now(),
    //       });

    //     case Goal.height:
    //       double height = double.parse(userInput!);
    //       ref.read(heightsProvider.notifier).addHeight(height);

    //     case Goal.steps:
    //       int steps = int.parse(userInput!);
    //       ref.read(stepsProvider.notifier).addSteps(steps);
    //     // ref.read(userVitalsProvider.notifier).addStepReading(steps);

    //     case Goal.sleep:
    //       double sleep = double.parse(userInput!);
    //       ref.read(sleepProvider.notifier).addSleep(sleep);
    //       // ref.read(userVitalsProvider.notifier).addSleepReading(sleep);

    //       FirebaseFirestore.instance
    //           .collection('users')
    //           .doc(ref.read(userDataProvider)!.uid)
    //           .collection('sleep')
    //           .add({
    //         'sleep': sleep,
    //         'createdAt': DateTime.now(),
    //       });

    //     case Goal.water:
    //       int water = int.parse(userInput!);
    //       ref.read(waterProvider.notifier).addWater(water);

    //     case Goal.calories:
    //       int calories = int.parse(userInput!);
    //       ref.read(caloriesProvider.notifier).addCalories(calories);
    //       // ref.read(userVitalsProvider.notifier).addCaloryReading(calories);

    //       FirebaseFirestore.instance
    //           .collection('users')
    //           .doc(ref.read(userDataProvider)!.uid)
    //           .collection('calories')
    //           .add({
    //         'calories': calories,
    //         'createdAt': DateTime.now(),
    //       });
    //   }
    // }
  }

  Future<String?> InputDialog(Goal goal) {
    _dataController.clear();
    return showDialog<String?>(
      context: (context),
      builder: (ctx) =>
          UserInputPopUp(goal: goal, dataController: _dataController),
    );
  }

  void _onAddGoal(Goal goal) {
    if (false) {
    } else {
      return null;
    }
  }

  Future<void> fetchStepData() async {
    await Permission.activityRecognition.request();

    int? steps;

    // get steps for today (i.e., since midnight)
    final now = DateTime.now();
    final formattedDate =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';
    final midnight = DateTime(now.year, now.month, now.day);

    bool stepsPermission =
        await Health().hasPermissions([HealthDataType.STEPS]) ?? false;
    if (!stepsPermission) {
      stepsPermission = await Health().requestAuthorization([
        HealthDataType.STEPS
      ], permissions: [
        HealthDataAccess.READ,
      ]);
    }

    if (stepsPermission) {
      try {
        steps = await Health().getTotalStepsInInterval(midnight, now);
      } catch (error) {
        print("Exception in getTotalStepsInInterval: $error");
      }

      print('Total number of steps: $steps');
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(ref.read(userDataProvider)!.uid)
          .collection('steps')
          .doc(formattedDate)
          .get();
      if (!doc.exists) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(ref.read(userDataProvider)!.uid)
            .collection('steps')
            .doc(formattedDate)
            .set({
          'steps': steps,
          'createdAt': now,
        });
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(ref.read(userDataProvider)!.uid)
            .collection('steps')
            .doc(formattedDate)
            .set({
          'steps': steps,
        }, SetOptions(merge: true));
      }
    }
  }

  @override
  void dispose() {
    _dataController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // final userVitals = ref.watch(userVitalsProvider);
    final weight = ref.watch(weightsProvider);
    // final weight = [
    //   WeightReading(
    //     id: "abc",
    //     weight: 1,
    //     createdAt: DateTime.now(),
    //   ),
    // ]; // userVitals.weights;

    final calories = ref.watch(caloriesProvider);
    // final calories = [1]; // userVitals.calories;

    final steps = ref.watch(stepsProvider);
    // final steps = [1]; // userVitals.steps;

    final sleep = ref.watch(sleepProvider);
    // final sleep = [1.0]; // userVitals.sleep;
    double? currentWeight;
    if (weight.isNotEmpty) {
      currentWeight = weight.first.weight;
    }
    int? currentCalories;
    if (calories.isNotEmpty) {
      currentCalories = calories.first.calories;
    }
    int? currentSteps;
    if (steps.isNotEmpty) {
      currentSteps = steps.first.steps;
    }

    double? currentSleep;
    if (sleep.isNotEmpty) {
      currentSleep = sleep.first.sleep;
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: width / 2,
                width: width / 2,
                color: Color(0xff0d0051),
              ),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        CircleStackedChild(
                          onSelectWeight: () {
                            _onSelectWeight(Goal.weight);
                          },
                          innerColor: const Color(0xffe52f5b),
                          width: width / 2,
                          child: _CircleChild(
                            enclosingOuterCircleDiameter: width / 2,
                            title: Text(
                              currentWeight != null
                                  ? "$currentWeight kg"
                                  : 'Weight',
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: Icons.menu,
                          ),
                        ),
                        CircleStackedChild(
                          onSelectWeight: () {},
                          innerColor: const Color(0xff0d0051),
                          width: width / 2,
                          child: _CircleChild(
                            enclosingOuterCircleDiameter: width / 2,
                            title: Text(
                              currentSteps != null
                                  ? "$currentSteps steps"
                                  : 'Steps',
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: Icons.offline_bolt,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        CircleStackedChild(
                          onSelectWeight: () {
                            _onSelectWeight(Goal.calories);
                          },
                          innerColor: const Color(0xff0d0051),
                          width: width / 2,
                          child: _CircleChild(
                            enclosingOuterCircleDiameter: width / 2,
                            title: Text(
                              currentCalories != null
                                  ? "$currentCalories calories"
                                  : 'Calories',
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: Icons.food_bank,
                          ),
                        ),
                        CircleStackedChild(
                          onSelectWeight: () {
                            _onSelectWeight(Goal.sleep);
                          },
                          innerColor: Colors.white,
                          innerBorder: Border.all(
                            color: Color(0xff0d0051),
                            width: 2,
                          ),
                          width: width / 2,
                          child: _CircleChild(
                            enclosingOuterCircleDiameter: width / 2,
                            title: Text(
                              currentSleep != null
                                  ? "$currentSleep hours"
                                  : 'Sleep',
                              style: TextStyle(color: Color(0xff0d0051)),
                            ),
                            icon: Icons.bed,
                            iconBgColor: Color(0xff0d0051),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Text(
          //   ref.watch(userVitalsProvider).weights.toString(),
          // ),
        ],
      ),
    );
  }
}

class UserInputPopUp extends StatefulWidget {
  const UserInputPopUp({
    super.key,
    required TextEditingController dataController,
    required this.goal,
  }) : _dataController = dataController;

  final Goal goal;
  final TextEditingController _dataController;

  @override
  State<UserInputPopUp> createState() => _UserInputPopUpState();
}

class _UserInputPopUpState extends State<UserInputPopUp> {
  @override
  void initState() {
    super.initState();
    widget._dataController.addListener(_updateWidget);
  }

  @override
  void deactivate() {
    super.deactivate();
    widget._dataController.removeListener(_updateWidget);
  }

  void _updateWidget() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final title =
        widget.goal.name[0].toUpperCase() + widget.goal.name.substring(1);

    return AlertDialog(
      title: Text('Update $title'),
      content: TextFormField(
        controller: widget._dataController,
        style: TextStyle(),
        autofocus: true,
        decoration: InputDecoration(
            hintText: 'Enter Your $title',
            fillColor: Colors.red,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: const Color.fromRGBO(13, 71, 161, 1),
                width: 2.0,
              ),
            )),
        keyboardType: TextInputType.number,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.blue[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            switch (widget.goal) {
              case Goal.calories:
              case Goal.steps:
              case Goal.water:
                if (int.tryParse(widget._dataController.text) == null ||
                    widget._dataController.text.contains(".")) {
                  return null;
                }

              case Goal.height:
              case Goal.sleep:
              case Goal.weight:
                if (double.tryParse(widget._dataController.text) == null) {
                  return null;
                }
            }
            return () {
              Navigator.of(context).pop(widget._dataController.text);
            };
          }(),
          // onPressed: () {
          //   _onAddGoal(goal);
          //   // Navigator.of(context).pop(_dataController.text);
          // },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue[900],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text('Ok'),
        ),
      ],
    );
  }
}

class _CircleChild extends StatefulWidget {
  const _CircleChild({
    super.key,
    required this.enclosingOuterCircleDiameter,
    required this.title,
    required this.icon,
    this.iconBgColor = const Color(0x4cffffff),
  });

  final double enclosingOuterCircleDiameter;
  final Text title;
  final IconData icon;
  final Color iconBgColor;

  @override
  State<_CircleChild> createState() => _CircleChildState();
}

class _CircleChildState extends State<_CircleChild> {
  final _circleKey = GlobalKey();
  double _height = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        setState(() {
          _height = (_circleKey.currentContext!.findRenderObject() as RenderBox)
              .size
              .height;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: widget.enclosingOuterCircleDiameter / 2 - _height / 2,
        ),
        Container(
          key: _circleKey,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(1000),
            color: widget.iconBgColor,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 3,
            vertical: 3,
          ),
          child: Icon(
            widget.icon,
            size: widget.enclosingOuterCircleDiameter * 0.15,
            color: Colors.white,
          ),
        ),
        widget.title,
      ],
    );
  }
}
