import 'package:equatable/equatable.dart';
import 'player.dart';
import 'game_score.dart';

class MatchHistory extends Equatable {
  final DateTime createdAt;
  final List<Player> players;
  final List<GameScore> matches;

  const MatchHistory({
    required this.createdAt,
    required this.players,
    required this.matches,
  });

  Map<String, dynamic> toJson() => {
        'createdAt': createdAt.toIso8601String(),
        'players': players.map((p) => p.toJson()).toList(),
        'matches': matches.map((m) => m.toJson()).toList(),
      };

  factory MatchHistory.fromJson(Map<String, dynamic> json) => MatchHistory(
        createdAt: DateTime.parse(json['createdAt'] as String),
        players: (json['players'] as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, dynamic>))
            .toList(),
        matches: (json['matches'] as List<dynamic>)
            .map((e) => GameScore.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  List<Object?> get props => [createdAt];
}
