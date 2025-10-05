part of 'matchs_bloc.dart';

sealed class MatchesEvent extends Equatable {
  const MatchesEvent();

  @override
  List<Object> get props => [];
}

class CreateMatch extends MatchesEvent {
  final TournamentType type;
  final List<Player> players;
  CreateMatch({required this.type, required this.players});
}

class CleanMatchs extends MatchesEvent {}
