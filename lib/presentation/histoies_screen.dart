import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_calculator/application/match_history_bloc/match_history_bloc.dart';
import 'package:tennis_calculator/application/match_history_bloc/match_history_event.dart';
import 'package:tennis_calculator/application/match_history_bloc/match_history_state.dart';
import 'package:tennis_calculator/application/match_history_bloc/match_history_state.dart';
import 'package:tennis_calculator/application/match_history_bloc/match_history_state.dart';
import 'package:tennis_calculator/presentation/history_screen.dart';

import '../application/match_history_bloc/match_history_state.dart';
import '../application/match_history_bloc/match_history_state.dart';
import '../application/match_history_bloc/match_history_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      body: BlocBuilder<MatchHistoryBloc, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoaded && state.histories.isNotEmpty) {
            return ListView.builder(
              itemCount: state.histories.length,
              itemBuilder: (context, index) {
                final history = state.histories[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    trailing: IconButton(
                      onPressed: () {
                        context.read<MatchHistoryBloc>().add(
                              RemoveHistory(
                                history,
                              ),
                            );
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red[800],
                      ),
                    ),
                    title: Text(
                        "Tournament - ${history.createdAt.toLocal().toString().substring(0, 16)}"),
                    subtitle: Text(
                        "${history.players.length} players - ${history.matches.length} matches"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HistoryDetailScreen(history: history),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text("No history yet"));
        },
      ),
    );
  }
}
