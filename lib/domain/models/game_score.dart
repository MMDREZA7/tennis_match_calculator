class GameScore {
  final String winnerPlayerName;
  final String LoserPlayerName;
  final int playerScore;
  final int opponentScore;
  final DateTime date;
  final bool? isDeuce;

  GameScore({
    required this.winnerPlayerName,
    required this.LoserPlayerName,
    required this.playerScore,
    required this.opponentScore,
    this.isDeuce,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'playerName': winnerPlayerName,
        'opponentName': LoserPlayerName,
        'playerScore': playerScore,
        'opponentScore': opponentScore,
        'isDeuce': isDeuce,
        'date': date.toIso8601String(),
      };

  factory GameScore.fromJson(Map<String, dynamic> json) => GameScore(
        winnerPlayerName: json['playerName'] as String,
        LoserPlayerName: json['opponentName'] as String,
        playerScore: (json['playerScore'] as num).toInt(),
        opponentScore: (json['opponentScore'] as num).toInt(),
        isDeuce: (json['isDeuce'] as bool?),
        date: DateTime.parse(json['date'] as String),
      );
}
