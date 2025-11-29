import 'package:equatable/equatable.dart';
import 'package:tennis_calculator/domain/models/player.dart';
import 'package:tennis_calculator/domain/models/tournament.dart';

abstract class PlayersEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddPlayer extends PlayersEvent {
  final String name;
  AddPlayer(this.name);
  @override
  List<Object?> get props => [name];
}

class RemovePlayer extends PlayersEvent {
  final String name;
  RemovePlayer(this.name);
  @override
  List<Object?> get props => [name];
}

class EditPlayer extends PlayersEvent {
  final String name;
  final String newName;
  EditPlayer(
    this.name,
    this.newName,
  );
  @override
  List<Object?> get props => [name, newName];
}

class RegisterGame extends PlayersEvent {
  final List<String> selectedPlayers;
  final List<String> winnerNames;
  final Map<String, Map<String, int>>? scores;
  RegisterGame({
    required this.selectedPlayers,
    required this.winnerNames,
    this.scores,
  });

  @override
  List<Object?> get props => [selectedPlayers, winnerNames];
}

class RecordGame extends PlayersEvent {
  final List<Player> selectedPlayers;
  final List<Player> winnerPlayers;
  final TournamentType? tournamentType;

  RecordGame({
    required this.selectedPlayers,
    required this.winnerPlayers,
    this.tournamentType,
  });
}

class ClearMatches extends PlayersEvent {}

class ClearPlayers extends PlayersEvent {}
