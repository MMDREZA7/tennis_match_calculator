import 'package:flutter/material.dart';
import '../domain/models/match_history.dart';
import '../domain/models/game_score.dart';

class HistoryDetailScreen extends StatefulWidget {
  final MatchHistory history;
  const HistoryDetailScreen({super.key, required this.history});

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  String selectedPlayer = 'all';

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

  String scoreLabel(int s) {
    switch (s) {
      case 0:
        return 'Love';
      case 1:
        return '15';
      case 2:
        return '30';
      case 3:
        return '40';
      case 4:
        return '50';
      default:
        return s.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "History - ${widget.history.createdAt.toLocal().toString().split(' ').first}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Players:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ...widget.history.players.map((p) => Container(
                  margin: const EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(15)),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPlayer = p.name;
                      });
                    },
                    child: ListTile(
                      leading: const Icon(Icons.person, size: 25),
                      title: Row(
                        children: [
                          Text(p.name,
                              style: const TextStyle(color: Colors.black)),
                          if (p.specialWins > 0) ...stars(p.specialWins),
                        ],
                      ),
                      subtitle: Text(
                          "Games: ${p.totalGames}, Wins: ${p.winCount}, Loses: ${p.totalGames - p.winCount}, Rate: ${p.score.toStringAsFixed(2)}%"),
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            const Divider(color: Colors.black, height: 25),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${selectedPlayer == 'all' ? 'All games' : "${selectedPlayer[0].toUpperCase() + selectedPlayer.substring(1)}'s games"}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPlayer = 'all';
                      });
                    },
                    child: Text("View All"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  final filteredMatches = selectedPlayer == 'all'
                      ? widget.history.matches
                      : widget.history.matches
                          .where((m) => m.winnerPlayerName == selectedPlayer)
                          .toList();

                  if (filteredMatches.isEmpty) {
                    return Center(
                      child: Text(
                        selectedPlayer == 'all'
                            ? "No matches recorded yet."
                            : "${selectedPlayer[0].toUpperCase() + selectedPlayer.substring(1)} doesn't have any matches.",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredMatches.length,
                    itemBuilder: (context, index) {
                      final GameScore g = filteredMatches[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(child: Text("${index + 1}")),
                          title: Text(
                            "${g.winnerPlayerName} vs ${g.LoserPlayerName}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            "Score: ${scoreLabel(g.playerScore)} - ${scoreLabel(g.opponentScore)}",
                          ),
                          // isThreeLine: true,
                          trailing: Text(
                            g.date.toLocal().toString().split(' ').first,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
