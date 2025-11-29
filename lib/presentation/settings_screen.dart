import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flash/flash_helper.dart';
import 'package:tennis_calculator/application/players_bloc/players_event.dart';
import '../application/match_history_bloc/match_history_bloc.dart';
import '../application/match_history_bloc/match_history_event.dart';
import '../application/players_bloc/players_bloc.dart';
import '../application/players_bloc/players_state.dart';
import '../domain/models/match_history.dart';
import '../domain/models/game_score.dart';
import '../domain/models/player.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDeleteMatches = false;
  bool isDeletePlayers = false;
  bool isDeleteHistory = false;
  bool isSaveToHistory = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Settings',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.red[900])),
          icon: const Icon(Icons.delete_forever, color: Colors.white),
          label: const Text('Reset all data',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (c) => StatefulBuilder(
                builder: (context, setState) => AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text('Are you sure to reset?'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Which one do you want to delete?',
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          "Delete Players: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        value: isDeletePlayers,
                        onChanged: (value) => setState(() {
                          isDeletePlayers = value!;
                        }),
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          "Delete Matches: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        value: isDeleteMatches,
                        onChanged: (value) => setState(() {
                          isDeleteMatches = value!;
                        }),
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          "Delete Histories: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        value: isDeleteHistory,
                        onChanged: (value) => setState(() {
                          isDeleteHistory = value!;
                        }),
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.all(0),
                        title: Text(
                          "Save match to history: ",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        value: isSaveToHistory,
                        onChanged: (value) => setState(() {
                          isSaveToHistory = value!;
                        }),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(c).pop(false),
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
                      onPressed: () => Navigator.of(c).pop(true),
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          Colors.green[800],
                        ),
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );

            if (confirmed != true) {
              isDeleteMatches = false;
              isDeletePlayers = false;
              isDeleteHistory = false;
              isSaveToHistory = true;

              return;
            }
            ;

            final playersState = context.read<PlayersBloc>().state;
            List<Player> snapshotPlayers = [];
            if (playersState is PlayersLoaded) {
              snapshotPlayers =
                  playersState.players.map((p) => p.copy()).toList();
            } else {
              snapshotPlayers = context
                  .read<PlayersBloc>()
                  .players
                  .map((p) => p.copy())
                  .toList();
            }

            final Map<String, GameScore> unique = {};
            for (var p in snapshotPlayers) {
              for (var g in p.matches) {
                final keyParts = [
                  g.winnerPlayerName,
                  g.LoserPlayerName,
                  g.date.toIso8601String()
                ];
                final key = keyParts.join('|');
                unique[key] = g;
              }
            }

            final matches = unique.values.toList();

            final history = MatchHistory(
                createdAt: DateTime.now(),
                players: snapshotPlayers,
                matches: matches);

            if (isDeletePlayers)
              context.read<PlayersBloc>().add(ClearPlayers());

            if (isDeleteMatches)
              context.read<PlayersBloc>().add(ClearMatches());

            if (isDeleteHistory)
              context.read<MatchHistoryBloc>().add(ClearHistories());

            if (isSaveToHistory) {
              if (history.players.isEmpty) {
                context.showErrorBar(
                  content: Text(
                    "You Haven't any game or Players to save it!",
                  ),
                );

                isDeleteMatches = false;
                isDeletePlayers = false;
                isDeleteHistory = false;
                isSaveToHistory = true;

                return;
              }
              context.read<MatchHistoryBloc>().add(AddHistory(history));
            }

            context.showSuccessBar(
              content: Text(
                "${isDeletePlayers ? "Players, " : ''} ${isDeleteMatches ? "Matches, " : ''} ${isDeleteHistory ? "Histories" : ''} ${isDeletePlayers || isDeleteMatches || isDeleteHistory ? 'cleared, ' : ''} ${isSaveToHistory ? "This game saved to history" : ''}",
              ),
            );

            isDeleteMatches = false;
            isDeletePlayers = false;
            isDeleteHistory = false;
            isSaveToHistory = true;
          },
        ),
        const SizedBox(height: 12),
        const Text(
            'Theme and colors are tennis-inspired: greens and tennis-ball yellow.'),
        const SizedBox(height: 6),
        const Text(
            'Architecture: flutter_bloc, SharedPreferences persistence.'),
      ]),
    );
  }
}
