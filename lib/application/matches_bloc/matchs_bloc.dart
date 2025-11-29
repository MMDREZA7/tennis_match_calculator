import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tennis_calculator/domain/models/player.dart';
import 'package:tennis_calculator/domain/models/tournament.dart';

part 'matchs_event.dart';
part 'matchs_state.dart';

class MatchsBloc extends Bloc<MatchesEvent, MatchesState> {
  final List<List<Player>> _games = [];

  MatchsBloc() : super(MatchesInitial()) {
    on<CreateMatch>(_createMatch);
    on<CleanMatchs>(_cleanMatch);
  }

  FutureOr<void> _createMatch(
    CreateMatch event,
    Emitter<MatchesState> emit,
  ) async {
    emit(MatchesLoading());

    _games.clear();
    if (event.type == TournamentType.League) {
      _games.addAll(generateFairLeague(event.players));
    } else {
      _games.addAll(generateCupGames(event.players));
    }

    emit(MatchesLoaded(List.unmodifiable(_games)));
  }

  FutureOr<void> _cleanMatch(
    CleanMatchs event,
    Emitter<MatchesState> emit,
  ) async {
    emit(MatchesLoading());
    _games.clear();
    emit(MatchesLoaded(List.unmodifiable(_games)));
  }

  List<List<Player>> get games => List.unmodifiable(_games);
}

List<List<Player>> generateFairLeague(List<Player> players) {
  List<List<Player>> schedule = [];
  int n = players.length;
  bool hasBye = false;

  if (n % 2 != 0) {
    players = List.from(players);
    players.add(Player(name: "BYE"));
    n++;
    hasBye = true;
  }

  List<Player> rotation = List.from(players);

  for (int round = 0; round < n - 1; round++) {
    for (int i = 0; i < n ~/ 2; i++) {
      final p1 = rotation[i];
      final p2 = rotation[n - 1 - i];
      if (p1.name != "BYE" && p2.name != "BYE") {
        schedule.add([p1, p2]);
      }
    }
    final first = rotation.removeAt(1);
    rotation.add(first);
  }

  return schedule;
}

List<List<Player>> generateCupGames(List<Player> players) {
  List<List<Player>> games = [];
  List<Player> currentRound = List.from(players);

  while (currentRound.length > 1) {
    List<Player> nextRound = [];
    for (int i = 0; i < currentRound.length; i += 2) {
      if (i + 1 < currentRound.length) {
        games.add([currentRound[i], currentRound[i + 1]]);
        nextRound.add(currentRound[i]);
      } else {
        nextRound.add(currentRound[i]);
      }
    }
    currentRound = nextRound;
  }

  return games;
}
