import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_calculator/application/match_history_bloc/match_history_bloc.dart';
import 'package:tennis_calculator/application/match_history_bloc/match_history_event.dart';
import 'package:tennis_calculator/application/matches_bloc/matchs_bloc.dart';
import 'package:tennis_calculator/application/players_bloc/players_bloc.dart';
import 'package:tennis_calculator/domain/models/match_history.dart';
import 'package:tennis_calculator/domain/models/player_game.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Colors.red[900],
                ),
              ),
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.white,
              ),
              label: const Text(
                'Reset all data',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {
                await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text(
                      'Confirm reset',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    content: const Text(
                      'This will clear all saved players and games. Are you sure?',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(c).pop(false),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Colors.red[800],
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          final players = context
                              .read<PlayersBloc>()
                              .players
                              .map((p) => Player(
                                    name: p.name,
                                    totalGames: p.totalGames,
                                    totalWins: p.totalWins,
                                  ))
                              .toList();

                          final matches = context
                              .read<MatchsBloc>()
                              .games
                              .map((m) => m
                                  .map((p) => Player(
                                        name: p.name,
                                        totalGames: p.totalGames,
                                        totalWins: p.totalWins,
                                      ))
                                  .toList())
                              .toList();

                          context.read<MatchHistoryBloc>().add(
                                AddHistory(
                                  MatchHistory(
                                    createdAt: DateTime.now(),
                                    players: players,
                                    matches: matches,
                                  ),
                                ),
                              );

                          // بعد از ذخیره، پاک‌سازی
                          context.read<PlayersBloc>().add(ClearMatches());
                          context.read<PlayersBloc>().add(ClearPlayers());
                          context.read<MatchsBloc>().add(CleanMatchs());

                          Navigator.of(c).pop(true);

                          context.showSuccessBar(
                            content:
                                const Text("Everything cleared successfully"),
                          );
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Colors.green[800],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
          const SizedBox(height: 12),
          const Text(
              'Theme and colors are tennis-inspired: greens and tennis-ball yellow.'),
          const SizedBox(height: 6),
          const Text(
              'Architecture: flutter_bloc (Cubits), SharedPreferences persistence, modular files.'),
        ],
      ),
    );
  }
}
