import 'dart:io';

import 'package:flash/flash_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_calculator/application/players_bloc/players_bloc.dart';
import 'package:tennis_calculator/application/players_bloc/players_event.dart';
import 'package:tennis_calculator/application/players_bloc/players_state.dart';
import 'package:tennis_calculator/application/save_ps_names/save_ps_names.dart';
import 'package:tennis_calculator/domain/models/player.dart';
import 'package:tennis_calculator/presentation/win_score_dialog.dart';

class PlayScreen extends StatefulWidget {
  const PlayScreen({Key? key}) : super(key: key);

  @override
  _PlayScreenState createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  final TextEditingController _newPlayerNameController =
      TextEditingController();

  final TextEditingController _editPlayerNameController =
      TextEditingController();

  @override
  void dispose() {
    _newPlayerNameController.dispose();
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
    List<Widget> stars(int specialRate) {
      List<Widget> widgets = [];

      if (specialRate <= 0) return widgets;

      int displayCount = specialRate > 5 ? 5 : specialRate;

      for (int i = 0; i < displayCount; i++) {
        widgets.add(
          Icon(
            Icons.star,
            color: Colors.amber,
            size: 20,
          ),
        );
        if (i != displayCount - 1) widgets.add(SizedBox(width: 2));
      }

      if (specialRate > displayCount) {
        widgets.add(SizedBox(width: 4));
        widgets.add(
          Icon(
            Icons.military_tech,
            color: Colors.red,
            size: 20,
          ),
        );
      }

      return widgets;
    }

    void deleteDialog(
      BuildContext context,
      Player player,
    ) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Delete player "${player.name}"?',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'This will also remove all match history associated with this player.',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
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
                context.read<PlayersBloc>().add(
                      RemovePlayer(
                        player.name,
                      ),
                    );

                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Colors.green[800],
                ),
              ),
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
      _newPlayerNameController.clear();
    }

    void editDialog(
      BuildContext context,
      Player player,
    ) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Colors.grey[700],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit player "${player.name}"?',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _editPlayerNameController,
                decoration: InputDecoration(
                  labelText: 'New player name',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 12),
              const Text(
                'This will change the player\'s name in all match history associated with this player.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
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
                List<Player> players = context.read<PlayersBloc>().players;

                final isNameExists = players
                    .where(
                      (element) =>
                          element.name == _editPlayerNameController.text,
                    )
                    .isNotEmpty;

                if (isNameExists) {
                  context.showErrorBar(
                    content: const Text("Player already exists."),
                  );
                  return;
                }

                context.read<PlayersBloc>().add(
                      EditPlayer(
                        player.name,
                        _editPlayerNameController.text,
                      ),
                    );

                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Colors.green[800],
                ),
              ),
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
      _editPlayerNameController.clear();
    }

    void showPlayersSelectDialog(
      BuildContext context,
      List<String> playersUsedNames,
    ) {
      final List<String> selectedNames = [];

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              backgroundColor: Colors.grey[800],
              title: const Text(
                "Select Players",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: ListView.builder(
                  itemCount: playersUsedNames.length,
                  itemBuilder: (context, index) {
                    final name = playersUsedNames[index];
                    final isSelected = selectedNames.contains(name);

                    if (playersUsedNames.isEmpty) {
                      return const Text("You haven't any players");
                    }
                    return Slidable(
                      startActionPane: ActionPane(
                        motion: StretchMotion(),
                        children: [
                          SlidableAction(
                            icon: Icons.delete_outline,
                            backgroundColor: Colors.red[800]!,
                            onPressed: (context) async {
                              final prefs =
                                  await SharedPreferences.getInstance();

                              setState(() {
                                playersUsedNames.removeAt(index);
                              });

                              await prefs.setStringList(
                                  'player_names', playersUsedNames);
                            },
                          )
                        ],
                      ),
                      child: CheckboxListTile(
                        activeColor: Colors.green[700],
                        checkColor: Colors.white,
                        title: Text(
                          name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        value: isSelected,
                        onChanged: (value) {
                          setState(
                            () {
                              if (value == true) {
                                selectedNames.add(name);
                              } else {
                                selectedNames.remove(name);
                              }
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.red[700]),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    for (var name in selectedNames) {
                      final exists = context.read<PlayersBloc>().players.any(
                            (player) => player.name == name,
                          );
                      if (exists) {
                        Navigator.pop(context);
                        context.showErrorBar(
                            content: Text("${name} already exists."));
                        return;
                      }
                      context.read<PlayersBloc>().add(AddPlayer(name));
                    }

                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.green[700]),
                  ),
                  child: const Text(
                    'Select',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    // ignore: deprecated_member_use
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () async {
                  final names = await loadPlayerNames();
                  showPlayersSelectDialog(context, names);
                },
                icon: Icon(
                  Icons.person_add,
                  size: 30,
                  color: Colors.green[800],
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _newPlayerNameController,
                  onEditingComplete: () async {
                    if (_newPlayerNameController.text == '') {
                      context.showErrorBar(
                        content: const Text("Player name can not be empty."),
                      );
                      return;
                    }

                    if (context.read<PlayersBloc>().players.any((element) =>
                        element.name == _newPlayerNameController.text)) {
                      context.showErrorBar(
                        content: const Text("Player already exists."),
                      );
                      return;
                    }

                    context.read<PlayersBloc>().add(
                          AddPlayer(
                            _newPlayerNameController.text,
                          ),
                        );

                    await savePlayerName(_newPlayerNameController.text);

                    setState(() {
                      _newPlayerNameController.clear();
                    });

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
                  if (_newPlayerNameController.text == '') {
                    context.showErrorBar(
                      content: const Text("You should write something!"),
                    );
                    return;
                  }

                  if (context.read<PlayersBloc>().players.any((element) =>
                      element.name == _newPlayerNameController.text)) {
                    context.showErrorBar(
                      content: const Text("Player already exists."),
                    );
                    return;
                  }

                  await savePlayerName(_newPlayerNameController.text);

                  context.read<PlayersBloc>().add(
                        AddPlayer(
                          _newPlayerNameController.text,
                        ),
                      );
                  setState(() {
                    _newPlayerNameController.clear();
                  });

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
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Today\'s Play',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
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

                      return Slidable(
                        key: Key(state.players[index].name),
                        startActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) => deleteDialog(
                                context,
                                state.players[index],
                              ),
                              backgroundColor: Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                            SlidableAction(
                              onPressed: (context) => editDialog(
                                context,
                                state.players[index],
                              ),
                              backgroundColor: Color(0xFF21B7CA),
                              foregroundColor: Colors.white,
                              icon: Icons.edit_outlined,
                              label: 'Edit',
                            ),
                          ],
                        ),
                        child: Card(
                          child: CheckboxListTile(
                            value: isPlayerExist.name != '' ? true : false,
                            title: Row(
                              children: [
                                Text(
                                  state.players[index].name,
                                ),
                                SizedBox(width: 8),
                                if (state.players[index].specialWins > 0)
                                  ...stars(state.players[index].specialWins),
                              ],
                            ),
                            subtitle: Text(
                              'Games: ${state.players[index].totalGames}, Wins: ${state.players[index].winCount}, Loses: ${state.players[index].totalGames - state.players[index].winCount}, Rate: ${state.players[index].score.toStringAsFixed(2)}',
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
                                            fontWeight: FontWeight.bold,
                                          ),
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

                                              print(player.name);
                                              print(_selectedPlayers);
                                              print(_selectedWinnerPlayers);

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
                                                  ? () async {
                                                      await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              ScoreDialog(
                                                            winnerNames:
                                                                _selectedWinnerPlayers
                                                                    .map((e) =>
                                                                        e.name)
                                                                    .join(', '),
                                                            loserNames: _selectedPlayers
                                                                .where((p) =>
                                                                    !_selectedWinnerPlayers
                                                                        .contains(
                                                                            p))
                                                                .map((e) =>
                                                                    e.name)
                                                                .join(', '),
                                                            selectedPlayers:
                                                                _selectedPlayers,
                                                            selectedWinnerPlayers:
                                                                _selectedWinnerPlayers,
                                                          ),
                                                        ),
                                                      );

                                                      Navigator.pop(context);

                                                      setState(() {
                                                        _selectedPlayers
                                                            .clear();
                                                        _selectedWinnerPlayers
                                                            .clear();
                                                      });
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
                      'This will remove total games and total wins that were added today from the Play (history remains).',
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
