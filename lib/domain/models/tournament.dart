import 'package:tennis_calculator/domain/models/player_game.dart';

enum TournamentType { League, Cup }

class Tournament {
  final TournamentType type;
  final List<Player> players;

  Tournament({required this.type, required this.players});
}
