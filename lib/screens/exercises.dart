import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/models/exercise.dart';
import 'package:gym_app/models/muscle.dart';
import 'package:gym_app/providers/exercises_provider.dart';
import 'package:gym_app/providers/selected_exercise_provider.dart';
import 'package:gym_app/providers/userdata_provider.dart';

class Exercises extends ConsumerStatefulWidget {
  const Exercises({
    super.key,
    required this.muscle,
  });

  final Muscle muscle;

  @override
  ConsumerState<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends ConsumerState<Exercises> {
  // late Future<QuerySnapshot<Map<String, dynamic>>> _exerciseFuture;
  final _exerciseController = TextEditingController();
  late final Stream<QuerySnapshot<Map<String, dynamic>>> _exerciseStream;

  @override
  void initState() {
    super.initState();
    // _getExercises();

    _exerciseStream = FirebaseFirestore.instance
        .collection('muscles')
        .doc(widget.muscle.id)
        .collection('exercises')
        .where(
          Filter.or(
            Filter("userId", isNull: true),
            Filter("userId", isEqualTo: ref.read(userDataProvider)!.uid),
          ),
        )
        .snapshots()
        .asBroadcastStream();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(exercisesProvider.notifier).emptyExercises();

      _exerciseStream.listen(
        (snapshot) {
          final exerciseList = snapshot.docs
              .map(
                (exerciseDoc) => Exercise.fromFirebase(
                  exerciseDoc.id,
                  exerciseDoc.data(),
                ),
              )
              .toList();
          ref.read(exercisesProvider.notifier).addExercises(exerciseList);
        },
      );
    });
  }

  @override
  void dispose() {
    _exerciseController.dispose();
    super.dispose();
  }

  // Future<void> _getExercises() async {
  //   _exerciseFuture = FirebaseFirestore.instance
  //       .collection('muscles')
  //       .doc(widget.muscle.id)
  //       .collection("exercises")
  //       .where(
  //         Filter.or(
  //           Filter("userId", isNull: true),
  //           Filter("userId", isEqualTo: ref.read(userDataProvider)!.uid),
  //         ),
  //       )
  //       .get();
  //   await _exerciseFuture;
  // }

  void _onAddExercise() async {
    _exerciseController.clear();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AddExerciseDialog(
              exerciseController: _exerciseController, muscle: widget.muscle);
        });
  }

  @override
  Widget build(BuildContext context) {
    final exercises = ref.watch(exercisesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.muscle.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _onAddExercise,
            icon: Icon(Icons.add_box_outlined),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: Column(
          children: [
            StreamBuilder(
              stream: _exerciseStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active &&
                    snapshot.hasData) {
                  final selectedExercise = ref.watch(selectedExerciseProvider);

                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: ListView.builder(
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Material(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              color: selectedExercise.contains(exercises[index])
                                  ? Colors.blue.shade200
                                  : Colors.white,
                              child: InkWell(
                                onTap: () {
                                  ref
                                      .read(selectedExerciseProvider.notifier)
                                      .addExercise(exercises[index]);
                                  print(selectedExercise.map(
                                    (e) => e.name,
                                  ));
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 20,
                                  ),
                                  width: double.infinity,
                                  child: Text(
                                    exercises[index].name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        // children: [
                        //   ...exerciseList.map(
                        //     (e) {

                        //     },
                        //   )
                        // ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            // FutureBuilder(
            //   future: _exerciseFuture,
            //   builder: (context, snapshot) {
            //     if (snapshot.connectionState == ConnectionState.done &&
            //         snapshot.hasData) {
            //       final selectedExercise = ref.watch(selectedExerciseProvider);

            //       final exerciseList = snapshot.data!.docs
            //           .map(
            //             (exerciseDoc) => Exercise.fromFirebase(
            //               exerciseDoc.id,
            //               exerciseDoc.data(),
            //             ),
            //           )
            //           .toList();
            //       return Expanded(
            //         child: Padding(
            //           padding: const EdgeInsets.symmetric(vertical: 20),
            //           child: ListView.builder(
            //             itemCount: exerciseList.length,
            //             itemBuilder: (context, index) {
            //               return Padding(
            //                 padding: const EdgeInsets.only(bottom: 14),
            //                 child: Material(
            //                   clipBehavior: Clip.antiAlias,
            //                   shape: RoundedRectangleBorder(
            //                     borderRadius: BorderRadius.circular(8),
            //                     side: BorderSide(
            //                       color: Colors.grey.shade400,
            //                     ),
            //                   ),
            //                   color:
            //                       selectedExercise.contains(exerciseList[index])
            //                           ? Colors.blue.shade200
            //                           : Colors.white,
            //                   child: InkWell(
            //                     onTap: () {
            //                       ref
            //                           .read(selectedExerciseProvider.notifier)
            //                           .addExercise(exerciseList[index]);
            //                       print(selectedExercise.map(
            //                         (e) => e.name,
            //                       ));
            //                     },
            //                     child: Container(
            //                       color: Colors.transparent,
            //                       padding: const EdgeInsets.symmetric(
            //                         vertical: 20,
            //                         horizontal: 20,
            //                       ),
            //                       width: double.infinity,
            //                       child: Text(
            //                         exerciseList[index].name,
            //                         style: const TextStyle(
            //                           fontSize: 18,
            //                           fontWeight: FontWeight.bold,
            //                         ),
            //                       ),
            //                     ),
            //                   ),
            //                 ),
            //               );
            //             },
            //             // children: [
            //             //   ...exerciseList.map(
            //             //     (e) {

            //             //     },
            //             //   )
            //             // ],
            //           ),
            //         ),
            //       );
            //     } else {
            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //   },
            // ),
            // const Spacer(),
            Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.indigo[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddExerciseDialog extends ConsumerStatefulWidget {
  const AddExerciseDialog({
    super.key,
    required TextEditingController exerciseController,
    required this.muscle,
  }) : _exerciseController = exerciseController;

  final TextEditingController _exerciseController;
  final Muscle muscle;

  @override
  ConsumerState<AddExerciseDialog> createState() => _AddExerciseDialogState();
}

class _AddExerciseDialogState extends ConsumerState<AddExerciseDialog> {
  @override
  void initState() {
    super.initState();
    widget._exerciseController.addListener(_updateWidget);
  }

  @override
  void deactivate() {
    super.deactivate();
    widget._exerciseController.removeListener(_updateWidget);
  }

  void _updateWidget() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDataProvider);
    return AlertDialog(
      title: Text("Add Exercise"),
      content: TextField(
        controller: widget._exerciseController,
        style: TextStyle(),
        autofocus: true,
        decoration: InputDecoration(
            hintText: 'Exercise Name',
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
            if (widget._exerciseController.text.trim().isEmpty) {
              return null;
            }
            return () {
              print(widget._exerciseController.text);
              FirebaseFirestore.instance
                  .collection('muscles')
                  .doc(widget.muscle.id)
                  .collection('exercises')
                  .add({
                "name": widget._exerciseController.text,
                "userId": user!.uid
              });
              Navigator.of(context).pop(widget._exerciseController.text);
            };
          }(),
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
