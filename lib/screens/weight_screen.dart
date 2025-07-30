import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/models/caloriesReading.dart';
import 'package:gym_app/models/sleepReading.dart';
import 'package:gym_app/models/weightReading.dart';
import 'package:gym_app/providers/weights_provider.dart';
import 'package:gym_app/utils/enums.dart';

import '../providers/calories_provider.dart';
import '../providers/height_provider.dart';
import '../providers/sleep_provider.dart';
import '../providers/steps_provider.dart';
import '../providers/userdata_provider.dart';
import '../providers/water_provider.dart';

class WeightScreen extends ConsumerStatefulWidget {
  const WeightScreen({
    required this.goal,
    super.key,
  });

  final Goal goal;

  @override
  ConsumerState<WeightScreen> createState() => _WeightScreenState();
}

class _WeightScreenState extends ConsumerState<WeightScreen> {
  late bool _update;

  void _onSelectWeight(WeightReading? weightReading, SleepReading? sleepReading,
      CaloriesReading? caloriesReading) async {
    if (widget.goal == Goal.weight) {
      final userInput = await inputDialog(weightReading, null, null);
      if (userInput != null) {
        double weight = double.parse(userInput!);

        if (!_update) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(ref.read(userDataProvider)!.uid)
              .collection('weight')
              .add({
            'weight': weight,
            'createdAt': DateTime.now(),
          });
        } else if (_update) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(ref.read(userDataProvider)!.uid)
              .collection('weight')
              .doc(weightReading!.id)
              .update({'weight': weight});
        }
      }
    }
    if (widget.goal == Goal.sleep) {
      final userInput = await inputDialog(null, sleepReading, null);
      if (userInput != null) {
        double sleep = double.parse(userInput!);

        if (!_update) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(ref.read(userDataProvider)!.uid)
              .collection('sleep')
              .add({
            'sleep': sleep,
            'createdAt': DateTime.now(),
          });
        } else if (_update) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(ref.read(userDataProvider)!.uid)
              .collection('sleep')
              .doc(sleepReading!.id)
              .update({'sleep': sleep});
        }
      }
    }
    if (widget.goal == Goal.calories) {
      final userInput = await inputDialog(null, null, caloriesReading);
      if (userInput != null) {
        int calories = int.parse(userInput!);

        if (!_update) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(ref.read(userDataProvider)!.uid)
              .collection('calories')
              .add({
            'calories': calories,
            'createdAt': DateTime.now(),
          });
        } else if (_update) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(ref.read(userDataProvider)!.uid)
              .collection('calories')
              .doc(caloriesReading!.id)
              .update({'calories': calories});
        }
      }
    }
  }

  Future<String?> inputDialog(WeightReading? weightReading,
      SleepReading? sleepReading, CaloriesReading? caloriesReading) {
    late TextEditingController _dataController;
    if (weightReading != null) {
      _dataController =
          TextEditingController(text: weightReading?.weight.toString());
    } else if (sleepReading != null) {
      _dataController =
          TextEditingController(text: sleepReading?.sleep.toString());
    } else if (caloriesReading != null) {
      _dataController =
          TextEditingController(text: caloriesReading?.calories.toString());
    } else {
      _dataController = TextEditingController(text: null);
    }
    return showDialog<String?>(
      context: (context),
      builder: (ctx) => UserInputPopUp(
        goal: widget.goal,
        dataController: _dataController,
        update: _update,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    late final allEntries;
    if (widget.goal == Goal.weight) {
      allEntries = ref.watch(weightsProvider);
    } else if (widget.goal == Goal.sleep) {
      allEntries = ref.watch(sleepProvider);
    } else if (widget.goal == Goal.calories) {
      allEntries = ref.watch(caloriesProvider);
    }
    print("BUILDING WEIGHTS SCREENS");
    print(allEntries.first);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                _update = false;
                return _onSelectWeight(null, null, null);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: ListView.separated(
        itemCount: allEntries.length,
        padding: EdgeInsets.symmetric(horizontal: 0),
        separatorBuilder: (context, index) {
          return const Divider(height: 0);
        },
        itemBuilder: (context, index) {
          // print(allEntries);
          return ListTile(
            onTap: () {
              _update = true;
              if (widget.goal == Goal.weight) {
                return _onSelectWeight(allEntries[index], null, null);
              } else if (widget.goal == Goal.sleep) {
                return _onSelectWeight(null, allEntries[index], null);
              } else if (widget.goal == Goal.calories) {
                return _onSelectWeight(null, null, allEntries[index]);
              }
            },
            trailing: Icon(Icons.arrow_forward_ios_rounded),
            // tileColor: Colors.black.withOpacity(0.0375),
            // shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.all(Radius.circular(16))),

            title: Text(
              widget.goal == Goal.weight
                  ? '${allEntries[index].weight} kg'
                  : widget.goal == Goal.sleep
                      ? '${allEntries[index].sleep} hours'
                      : '${allEntries[index].calories} kcal',
              style: const TextStyle(fontSize: 18),
            ),
            subtitle: Text(
              '${allEntries[index].createdAt}',
            ),
          );
        },
      ),
    );
  }
}

class UserInputPopUp extends StatefulWidget {
  const UserInputPopUp({
    super.key,
    required TextEditingController dataController,
    required this.goal,
    required this.update,
  }) : _dataController = dataController;

  final bool update;
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
      title: Text(widget.update ? 'Update $title' : 'Add ${title}'),
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
          child: Text(widget.update ? 'Edit' : 'Ok'),
        ),
      ],
    );
  }
}
