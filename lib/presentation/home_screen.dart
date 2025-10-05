import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_calculator/application/match_history_bloc/match_history_bloc.dart';
import 'package:tennis_calculator/application/match_history_bloc/match_history_event.dart';
import 'package:tennis_calculator/presentation/about_screen.dart';
import 'package:tennis_calculator/presentation/histoies_screen.dart';
import 'package:tennis_calculator/presentation/roster_screen.dart';
import 'package:tennis_calculator/presentation/scheduler_screen.dart';
import 'package:tennis_calculator/presentation/settings_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final _tabs = [
    const RosterScreen(),
    const SchedulerScreen(),
    const HistoryScreen(),
    const SettingsScreen()
  ];

  @override
  void initState() {
    super.initState();
    context.read<MatchHistoryBloc>().add(const LoadHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.info_outline,
              color: Colors.white,
            ),
          ),
        ],
        title: const Text('Tennis Match App'),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _tabs[_index],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.green[800],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white54,
          currentIndex: _index,
          onTap: (i) => setState(
                () => _index = i,
              ),
          items: [
            BottomNavigationBarItem(
              backgroundColor: Colors.green[800],
              icon: Icon(Icons.group),
              label: 'Play',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.green[800],
              icon: Icon(Icons.schedule),
              label: 'Competetive',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.green[800],
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              backgroundColor: Colors.green[800],
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ]),
    );
  }
}
