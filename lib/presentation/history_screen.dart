import 'package:flutter/material.dart';

import '../domain/models/match_history.dart';

class HistoryDetailScreen extends StatelessWidget {
  final MatchHistory history;

  const HistoryDetailScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History - ${history.createdAt.toLocal()}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Players:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            ...history.players.map(
              (p) => Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: Icon(
                    Icons.person,
                    size: 25,
                  ),
                  title: Text(
                    "Players: ${p.name}",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  subtitle:
                      Text("Games: ${p.totalGames}, Wins: ${p.totalWins}"),
                ),
              ),
            ),
            // const Divider(),
            // const Text(
            //   "Matches:",
            //   style: TextStyle(
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: history.matches.length,
            //     itemBuilder: (context, index) {
            //       final match = history.matches[index];
            //       return ListTile(
            //         title: Text("${match[0].name} vs ${match[1].name}"),
            //       );
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
