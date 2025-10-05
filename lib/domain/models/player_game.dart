class Player {
  final String name;
  int totalGames;
  int totalWins;

  Player({
    required this.name,
    this.totalGames = 0,
    this.totalWins = 0,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] as String,
      totalGames: (json['totalGames'] as num?)?.toInt() ?? 0,
      totalWins: (json['totalWins'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'totalGames': totalGames,
      'totalWins': totalWins,
    };
  }

  Player copy() {
    return Player(name: name, totalGames: totalGames, totalWins: totalWins);
  }
}

class GameRecord {
  final DateTime playedAt;
  final List<String> opponents;
  final bool isWinner;

  GameRecord({
    required this.playedAt,
    required this.opponents,
    required this.isWinner,
  });
}
