import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_calculator/application/players_bloc/players_bloc.dart';
import 'package:tennis_calculator/application/players_bloc/players_event.dart';
import 'package:tennis_calculator/domain/models/game_dialog.dart';
import 'package:tennis_calculator/domain/models/player.dart';

class ScoreDialog extends StatefulWidget {
  final String winnerNames;
  final String loserNames;
  final List<Player> selectedPlayers;
  final List<Player> selectedWinnerPlayers;

  const ScoreDialog({
    Key? key,
    required this.winnerNames,
    required this.loserNames,
    required this.selectedPlayers,
    required this.selectedWinnerPlayers,
  }) : super(key: key);

  @override
  State<ScoreDialog> createState() => _ScoreDialogState();
}

class _ScoreDialogState extends State<ScoreDialog> {
  int playerScore = 4;
  int opponentScore = 0;
  bool isWinDeuce = false;

  final Map<int, String> scoreOptions = {
    0: 'Love',
    1: '15',
    2: '30',
    3: '40',
    4: '50',
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Enter Scores'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Win by Deuce: "),
                Switch(
                  thumbColor: MaterialStatePropertyAll(
                      !isWinDeuce ? Colors.blue[100] : Colors.blue[900]),
                  trackColor: MaterialStatePropertyAll(
                      !isWinDeuce ? Colors.blue[300] : null),
                  value: isWinDeuce,
                  onChanged: (value) {
                    setState(() {
                      isWinDeuce = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),
            isWinDeuce
                ? const Text(
                    "Since the game was won by Deuce, you don’t need to enter scores — just press Submit.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 15),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Winner (${widget.winnerNames}): ${widget.winnerNames}'),
                      DropdownButton<int>(
                        dropdownColor: Colors.white,
                        value: playerScore,
                        items: scoreOptions.entries
                            .map((e) => DropdownMenuItem<int>(
                                  value: e.key,
                                  child: Text(e.value),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            playerScore = val ?? 0;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      Text('Loser: (${widget.loserNames})${widget.loserNames}'),
                      DropdownButton<int>(
                        value: opponentScore,
                        items: scoreOptions.entries
                            .map((e) => DropdownMenuItem<int>(
                                  value: e.key,
                                  child: Text(e.value),
                                ))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            opponentScore = val ?? 0;
                          });
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          style: ButtonStyle(
              padding: MaterialStatePropertyAll(
                  const EdgeInsets.symmetric(horizontal: 20)),
              backgroundColor: MaterialStatePropertyAll(Colors.red[800])),
        ),
        TextButton(
          onPressed: () {
            final dialogText = gameDialog(
              playerScore: isWinDeuce ? 0 : playerScore,
              opponentScore: isWinDeuce ? 0 : opponentScore,
            );

            final Map<String, Map<String, int>> scoreMap = {};

            for (final p in widget.selectedPlayers) {
              final bool isWinner =
                  (widget.selectedWinnerPlayers).any((e) => e.name == p.name);

              final int safePlayerScore = playerScore;
              final int safeOpponentScore = opponentScore;
              final bool safeIsWinDeuce = isWinDeuce;

              scoreMap[p.name] = {
                'playerScore': isWinner
                    ? (safeIsWinDeuce ? 4 : safePlayerScore)
                    : (safeIsWinDeuce ? 0 : safeOpponentScore),
                'opponentScore': isWinner
                    ? (safeIsWinDeuce ? 0 : safeOpponentScore)
                    : (safeIsWinDeuce ? 4 : safePlayerScore),
              };
            }

            context.read<PlayersBloc>().add(
                  RegisterGame(
                    selectedPlayers:
                        widget.selectedPlayers.map((p) => p.name).toList(),
                    winnerNames: widget.selectedWinnerPlayers
                        .map((p) => p.name)
                        .toList(),
                    scores: scoreMap,
                  ),
                );

            Navigator.of(context).pop();
          },
          child: const Text(
            'Submit',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          style: ButtonStyle(
              padding: MaterialStatePropertyAll(
                  const EdgeInsets.symmetric(horizontal: 20)),
              backgroundColor: MaterialStatePropertyAll(Colors.green[900])),
        ),
      ],
    );
  }
}
