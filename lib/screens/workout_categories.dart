import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/screens/exercises.dart';

import '../models/muscle.dart';

class WorkoutCategoriesScreen extends StatefulWidget {
  const WorkoutCategoriesScreen({super.key});

  @override
  State<WorkoutCategoriesScreen> createState() =>
      _WorkoutCategoriesScreenState();
}

class _WorkoutCategoriesScreenState extends State<WorkoutCategoriesScreen> {
  late final Future<QuerySnapshot<Map<String, dynamic>>> _musclesFuture;

  @override
  void initState() {
    super.initState();
    _getMuscles();
    //
  }

  void _getMuscles() async {
    _musclesFuture = FirebaseFirestore.instance.collection('muscles').get();
    await _musclesFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Target Muscles',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.add_box_outlined),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: FutureBuilder(
            future: _musclesFuture,
            builder: (context, snapshot) {
              // print("PRINT__: ${snapshot.data?.docs.first.data()}");
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final musclesList = snapshot.data!.docs.map(
                  (muscleDoc) {
                    return Muscle.fromFirebase(
                      muscleDoc.id,
                      muscleDoc.data(),
                      [],
                    );
                  },
                ).toList();

                return GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1 / .3,
                  ),
                  children: [
                    ...musclesList
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return Exercises(
                                      muscle: e,
                                    );
                                  },
                                ),
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(e.name),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
