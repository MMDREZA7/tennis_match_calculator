part of 'matchs_bloc.dart';

sealed class MatchesState extends Equatable {
  const MatchesState();

  @override
  List<Object> get props => [];
}

final class MatchesInitial extends MatchesState {}

class MatchesLoaded extends MatchesState {
  final List<List<Player>> games;
  const MatchesLoaded(this.games);
}

class MatchesLoading extends MatchesState {}
