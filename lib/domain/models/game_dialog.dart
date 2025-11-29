String gameDialog({
  required int playerScore,
  required int opponentScore,
}) {
  String scoreText(int score) {
    switch (score) {
      case 0:
        return 'L 0 v e';
      case 1:
        return '15';
      case 2:
        return '30';
      case 3:
        return '40';
      case 4:
        return '50';
      default:
        return '0';
    }
  }

  String extra = '';
  if (playerScore >= 3 && opponentScore >= 3) {
    if (playerScore == opponentScore) {
      extra = '(Deuce)';
    } else if (playerScore > opponentScore) {
      extra = '(Advantage Player)';
    } else {
      extra = '(Advantage Opponent)';
    }
  }

  return 'Player: ${scoreText(playerScore)}, Opponent: ${scoreText(opponentScore)} $extra';
}
