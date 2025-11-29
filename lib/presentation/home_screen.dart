import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_calculator/application/match_history_bloc/match_history_bloc.dart';
import 'package:tennis_calculator/application/match_history_bloc/match_history_event.dart';
import 'package:tennis_calculator/presentation/about_screen.dart';
import 'package:tennis_calculator/presentation/histoies_screen.dart';
import 'package:tennis_calculator/presentation/play_screen.dart';
import 'package:tennis_calculator/presentation/scheduler_screen.dart';
import 'package:tennis_calculator/presentation/settings_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  final _tabs = [
    const PlayScreen(),
    const SchedulerScreen(),
    const HistoryScreen(),
    const SettingsScreen()
  ];

  @override
  void initState() {
    super.initState();
    context.read<MatchHistoryBloc>().add(LoadHistory());
  }

  Future<bool> exitDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text(
          'Exit App?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        content: const Text(
          'Are you sure you want to exit the app?',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Colors.red[800],
              ),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Navigator.of(context).pop();
              exit(0);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Colors.green[800],
              ),
            ),
            child: const Text(
              'Exit',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async => exitDialog(context),
      child: Scaffold(
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
      ),
    );
  }
}
