import 'package:flash/flash.dart';
import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_calculator/application/players_bloc/players_bloc.dart';
import 'package:tennis_calculator/domain/models/player_game.dart';

class RosterScreen extends StatefulWidget {
  const RosterScreen({Key? key}) : super(key: key);

  @override
  _RosterScreenState createState() => _RosterScreenState();
}

class _RosterScreenState extends State<RosterScreen> {
  final _newUserNameController = TextEditingController();

  @override
  void dispose() {
    _newUserNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _selectedPlayers.clear();
    _selectedWinnerPlayers.clear();

    print('Selected Players: ${_selectedPlayers}');
    print('Winner Players ${_selectedWinnerPlayers}');
  }

  List<Player> _selectedPlayers = [];
  List<Player> _selectedWinnerPlayers = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: TextField(
                controller: _newUserNameController,
                onEditingComplete: () {
                  if (_newUserNameController.text == '') {
                    context.showErrorBar(
                      content: const Text("Player name can not be empty."),
                    );
                    return;
                  }

                  if (context.read<PlayersBloc>().players.any((element) =>
                      element.name == _newUserNameController.text)) {
                    context.showErrorBar(
                      content: const Text("Player already exists."),
                    );
                    return;
                  }

                  context.read<PlayersBloc>().add(
                        AddPlayer(
                          _newUserNameController.text,
                        ),
                      );
                  _newUserNameController.clear();

                  context.read<PlayersBloc>().players.toList();
                },
                decoration: const InputDecoration(
                  labelText: 'Add player name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () async {
                if (_newUserNameController.text == '') {
                  context.showErrorBar(
                    content: const Text("You should write something!"),
                  );
                  return;
                }

                if (context.read<PlayersBloc>().players.any(
                    (element) => element.name == _newUserNameController.text)) {
                  context.showErrorBar(
                    content: const Text("Player already exists."),
                  );
                  return;
                }

                context.read<PlayersBloc>().add(
                      AddPlayer(
                        _newUserNameController.text,
                      ),
                    );
                _newUserNameController.clear();

                context.read<PlayersBloc>().players.toList();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Colors.green[800],
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ]),
          const SizedBox(height: 12),
          const Text('Today\'s Roster',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Expanded(
            child: BlocBuilder<PlayersBloc, PlayersState>(
              builder: (context, state) {
                if (state is PlayersLoaded) {
                  return ListView.builder(
                    itemCount: state.players.length,
                    itemBuilder: (context, index) {
                      Player isPlayerExist = Player(name: '');
                      try {
                        isPlayerExist = _selectedPlayers.firstWhere((element) =>
                            element.name == state.players[index].name);
                      } catch (e) {}

                      return Card(
                        child: CheckboxListTile(
                          value: isPlayerExist.name != '' ? true : false,
                          title: Text(
                            state.players[index].name,
                          ),
                          subtitle: Text(
                            'Games: ${state.players[index].totalGames}, Wins: ${state.players[index].totalWins}',
                          ),
                          onChanged: (value) {
                            setState(() {
                              final player = state.players[index];
                              if (value == true) {
                                if (!_selectedPlayers.contains(player)) {
                                  _selectedPlayers.add(player);
                                }
                              } else {
                                _selectedPlayers.remove(player);
                              }
                            });
                          },
                        ),
                      );
                    },
                  );
                }
                return ListView.builder(
                  itemCount: 0,
                  itemBuilder: (context, i) {
                    return Card(
                      child: ListTile(
                        leading: Checkbox(
                          value: true,
                          onChanged: (value) {},
                        ),
                        title: const Text("p.name"),
                        subtitle: const Text('Games: \${p.gamesPlayed}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {},
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Row(children: [
            Expanded(
              child: ElevatedButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    _selectedPlayers.length > 1
                        ? Colors.green[800]
                        : Colors.green[200],
                  ),
                ),
                icon: const Icon(
                  Icons.save,
                  color: Colors.white,
                ),
                label: const Text(
                  'Record Game',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: _selectedPlayers.length > 1
                    ? () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Colors.white,
                              child: StatefulBuilder(
                                builder: (context, setStateDialog) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "Who's winner?",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          height: 200,
                                          child: ListView.builder(
                                            itemCount: _selectedPlayers.length,
                                            itemBuilder: (context, index) {
                                              final player =
                                                  _selectedPlayers[index];
                                              final isSelected =
                                                  _selectedWinnerPlayers.any(
                                                      (p) =>
                                                          p.name ==
                                                          player.name);

                                              return CheckboxListTile(
                                                title: Text(player.name),
                                                value: isSelected,
                                                onChanged: (value) {
                                                  setStateDialog(
                                                    () {
                                                      final player =
                                                          _selectedPlayers[
                                                              index];
                                                      if (value == true) {
                                                        if (!_selectedWinnerPlayers
                                                            .contains(player)) {
                                                          _selectedWinnerPlayers
                                                              .add(player);
                                                        }
                                                      } else {
                                                        _selectedWinnerPlayers
                                                            .remove(player);
                                                      }
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                _selectedWinnerPlayers.clear();

                                                Navigator.of(context).pop();
                                              },
                                              child: const Text(
                                                "Cancel",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                  Colors.red[800],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            ElevatedButton(
                                              onPressed: _selectedWinnerPlayers
                                                          .length >=
                                                      1
                                                  ? () {
                                                      context
                                                          .read<PlayersBloc>()
                                                          .add(
                                                            RegisterGame(
                                                              _selectedPlayers
                                                                  .map((p) =>
                                                                      p.name)
                                                                  .toList(),
                                                              _selectedWinnerPlayers
                                                                  .map((p) =>
                                                                      p.name)
                                                                  .toList(),
                                                            ),
                                                          );

                                                      setState(() {
                                                        _selectedPlayers
                                                            .clear();
                                                        _selectedWinnerPlayers
                                                            .clear();
                                                      });

                                                      Navigator.of(context)
                                                          .pop();
                                                    }
                                                  : null,
                                              child: Text(
                                                "Select",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll(
                                                  _selectedWinnerPlayers
                                                              .length >=
                                                          1
                                                      ? Colors.green[800]
                                                      : Colors.green[300],
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }
                    : null,
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              icon: const Icon(
                Icons.refresh_sharp,
                color: Colors.white,
              ),
              label: const Text(
                'Reset Scores',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () async {
                await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    backgroundColor: Colors.white,
                    title: const Text(
                      'Reset Games for today?',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    content: const Text(
                      'This will remove total games and total wins that were added today from the roster (history remains).',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(c).pop(false),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.red[800])),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // c.read<PlayersBloc>().add(ClearPlayers());
                          // Navigator.of(c).pop();
                          // _selectedPlayers.clear();

                          c.read<PlayersBloc>().add(ClearMatches());
                          _selectedPlayers.clear();
                          Navigator.of(c).pop();
                        },
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.green[800])),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          ])
        ],
      ),
    );
  }
}
