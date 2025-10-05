import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_calculator/application/matches_bloc/matchs_bloc.dart';
import 'package:tennis_calculator/application/players_bloc/players_bloc.dart';
import 'package:tennis_calculator/domain/models/player_game.dart';
import 'package:tennis_calculator/domain/models/tournament.dart';

class SchedulerScreen extends StatefulWidget {
  const SchedulerScreen({Key? key}) : super(key: key);

  @override
  _SchedulerScreenState createState() => _SchedulerScreenState();
}

class _SchedulerScreenState extends State<SchedulerScreen> {
  TournamentType _selectedType = TournamentType.League;

  @override
  Widget build(BuildContext context) {
    List<Player> _players = context.read<PlayersBloc>().players;

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(children: [
            const Expanded(
                child: Text('Format:',
                    style: TextStyle(fontWeight: FontWeight.bold))),
            ToggleButtons(
              isSelected: [
                _selectedType == TournamentType.League,
                _selectedType == TournamentType.Cup,
              ],
              onPressed: (i) {
                setState(() {
                  _selectedType =
                      i == 0 ? TournamentType.League : TournamentType.Cup;
                });
              },
              children: const [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('League')),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Cup'))
              ],
            ),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.playlist_add),
              label: const Text('Generate Schedule'),
              onPressed: () {
                context.read<MatchsBloc>().add(
                      CreateMatch(
                        type: _selectedType,
                        players: _players,
                      ),
                    );
              },
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
                icon: const Icon(Icons.shuffle),
                label: const Text('Shuffle Players'),
                onPressed: () {
                  _players.shuffle();
                  showDialog(
                      context: context,
                      builder: (c) =>
                          AlertDialog(
                              title: const Text('Shuffled players'),
                              content:
                                  Text(_players.map((p) => p.name).join(", ")),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.of(c).pop(),
                                    child: const Text('OK'))
                              ]));
                })
          ]),
          const SizedBox(height: 12),

          // لیست بازی‌ها
          Expanded(
            child: BlocBuilder<MatchsBloc, MatchesState>(
              builder: (context, state) {
                if (state is MatchesInitial) {
                  return const Center(child: Text("No matches yet"));
                } else if (state is MatchesLoaded) {
                  final games = state.games;
                  return ListView.builder(
                    itemCount: games.length,
                    itemBuilder: (context, index) {
                      final match = games[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          title: Text("${match[0].name} vs ${match[1].name}"),
                        ),
                      );
                    },
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
