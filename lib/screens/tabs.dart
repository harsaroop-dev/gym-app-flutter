import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/screens/home.dart';
import 'package:gym_app/screens/profile.dart';
import 'package:gym_app/screens/workout.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gym_app/providers/userdata_provider.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _onClickProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => ProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = HomeScreen();
    if (_selectedPageIndex == 1) {
      activePage = WorkoutScreen();
    }
    if (_selectedPageIndex == 2) {
      activePage = ProfileScreen();
    }
    final user = ref.watch(userDataProvider);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 68,
        titleSpacing: 0.0,
        leading: Container(
          padding: EdgeInsets.only(left: 12),
          child: IconButton(
            iconSize: 32,
            onPressed: _onClickProfile,
            icon: const Icon(Icons.person),
          ),
        ),
        title: Text('Hey, ${user!.displayName}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      body: activePage,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedPageIndex,
        onDestinationSelected: _selectPage,
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.fitness_center),
            icon: Icon(Icons.fitness_center_outlined),
            label: 'Workout',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
