part of 'players_bloc.dart';

class PlayersEvent extends Equatable {
  const PlayersEvent();

  @override
  List<Object> get props => [];
}

class AddPlayer extends PlayersEvent {
  final String name;
  const AddPlayer(this.name);
}

class RemovePlayer extends PlayersEvent {
  final String name;
  const RemovePlayer(this.name);
}

class ClearMatches extends PlayersEvent {}

class RegisterGame extends PlayersEvent {
  final List<String> selectedPlayers;
  final List<String> winnerNames;

  RegisterGame(this.selectedPlayers, this.winnerNames);
}

class ClearPlayers extends PlayersEvent {}
