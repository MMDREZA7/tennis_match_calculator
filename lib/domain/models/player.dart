import 'package:equatable/equatable.dart';
import 'game_score.dart';

class Player extends Equatable {
  final String name;
  int totalGames;
  int winCount;
  double score;
  int specialWins;
  Set<String> beatenOpponents;
  List<GameScore> matches;

  Player({
    required this.name,
    this.totalGames = 0,
    this.winCount = 0,
    this.score = 0,
    this.specialWins = 0,
    Set<String>? beatenOpponents,
    List<GameScore>? matches,
  })  : beatenOpponents = beatenOpponents ?? {},
        matches = matches ?? [];

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        name: json['name'] as String,
        totalGames: (json['totalGames'] as num?)?.toInt() ?? 0,
        winCount: (json['totalWins'] as num?)?.toInt() ?? 0,
        score: (json['rate'] as num?)?.toDouble() ?? 0,
        specialWins: (json['specialWins'] as num?)?.toInt() ?? 0,
        beatenOpponents: (json['beatenOpponents'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toSet() ??
            {},
        matches: (json['matches'] as List<dynamic>?)
                ?.map((e) => GameScore.fromJson(e as Map<String, dynamic>))
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'totalGames': totalGames,
        'totalWins': winCount,
        'rate': score,
        'specialWins': specialWins,
        'beatenOpponents': beatenOpponents.toList(),
        'matches': matches.map((m) => m.toJson()).toList(),
      };

  Player copy() {
    return Player(
      name: name,
      totalGames: totalGames,
      winCount: winCount,
      score: score,
      specialWins: specialWins,
      beatenOpponents: Set.from(beatenOpponents),
      matches: List.from(matches),
    );
  }

  Player copyWith({
    String? name,
    int? totalGames,
    int? winCount,
    double? score,
    int? specialWins,
    Set<String>? beatenOpponents,
    List<GameScore>? matches,
  }) {
    return Player(
      name: name ?? this.name,
      totalGames: totalGames ?? this.totalGames,
      winCount: winCount ?? this.winCount,
      score: score ?? this.score,
      specialWins: specialWins ?? this.specialWins,
      beatenOpponents: beatenOpponents ?? Set.from(this.beatenOpponents),
      matches: matches ?? List.from(this.matches),
    );
  }

  @override
  List<Object?> get props => [name];
}
