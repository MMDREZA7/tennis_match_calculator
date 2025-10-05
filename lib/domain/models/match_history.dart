import 'package:equatable/equatable.dart';
import 'player_game.dart';

class MatchHistory extends Equatable {
  final DateTime createdAt;
  final List<Player> players;
  final List<List<Player>> matches;

  const MatchHistory({
    required this.createdAt,
    required this.players,
    required this.matches,
  });

  Map<String, dynamic> toJson() => {
        'createdAt': createdAt.toIso8601String(),
        'players': players.map((p) => p.toJson()).toList(),
        'matches':
            matches.map((m) => m.map((p) => p.toJson()).toList()).toList(),
      };

  factory MatchHistory.fromJson(Map<String, dynamic> json) => MatchHistory(
        createdAt: DateTime.parse(json['createdAt']),
        players:
            (json['players'] as List).map((e) => Player.fromJson(e)).toList(),
        matches: (json['matches'] as List)
            .map((m) => (m as List).map((e) => Player.fromJson(e)).toList())
            .toList(),
      );

  @override
  List<Object?> get props => [createdAt];
}
