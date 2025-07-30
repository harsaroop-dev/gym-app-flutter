import 'package:flutter/material.dart';
import 'package:gym_app/screens/workout_categories.dart';

class NewWorkoutScreen extends StatefulWidget {
  NewWorkoutScreen({super.key});

  @override
  State<NewWorkoutScreen> createState() => _NewWorkoutScreenState();
}

class _NewWorkoutScreenState extends State<NewWorkoutScreen> {
  final _workoutNameController = TextEditingController();

  @override
  void dispose() {
    _workoutNameController.dispose();
    super.dispose();
  }

  void _onAddExercise() async {
    final workoutName = _workoutNameController.text;

    if (workoutName.trim().isEmpty) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('Please enter a workout name.'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.indigo[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: Text('Ok'),
                ),
              ],
            );
          });
      return;
    }

    _workoutNameController.clear();
    final _moveToWorkoutCategoriesScreen = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return WorkoutCategoriesScreen();
        },
      ),
    );
    return _moveToWorkoutCategoriesScreen;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Create Workout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workout Name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextFormField(
              controller: _workoutNameController,
              decoration: InputDecoration(
                hintText: 'Give your workout a name',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: (Colors.indigo[800])!,
                  ),
                ),
              ),
              autocorrect: true,
              enableSuggestions: true,
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _onAddExercise,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.indigo[800],
                  ),
                  child: Text('+ Add Excercises'),
                ),
              ],
            ),
            const Spacer(),
            Container(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.indigo[800],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text('Save Workout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
