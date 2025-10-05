import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tennis_calculator/domain/models/player_game.dart';

part 'players_event.dart';
part 'players_state.dart';

class PlayersBloc extends Bloc<PlayersEvent, PlayersState> {
  List<Player> players = [];

  PlayersBloc() : super(PlayersInitial()) {
    on<AddPlayer>(_addPlayer);
    on<RegisterGame>(_registerGame);
    on<ClearMatches>(_clearMatches);
    on<ClearPlayers>(_cleanPlayers);
    on<RemovePlayer>(_removePlayer);
  }

  FutureOr<void> _addPlayer(
    AddPlayer event,
    Emitter<PlayersState> emit,
  ) {
    emit(PlayersLoading());
    players.add(
      Player(
        name: event.name,
        totalGames: 0,
      ),
    );
    emit(PlayersLoaded(players));
  }

  FutureOr<void> _removePlayer(
    RemovePlayer event,
    Emitter<PlayersState> emit,
  ) async {
    emit(PlayersLoading());

    int playerIndex =
        players.indexWhere((element) => element.name == event.name);

    players.removeAt(playerIndex);

    emit(PlayersLoaded(List.from(players)));
  }

  FutureOr<void> _registerGame(
    RegisterGame event,
    Emitter<PlayersState> emit,
  ) async {
    emit(PlayersLoading());

    for (var playerName in event.selectedPlayers) {
      final existingPlayer = players.firstWhere((p) => p.name == playerName);
      existingPlayer.totalGames += 1;
    }

    for (var winnerName in event.winnerNames) {
      final existingWinner = players.firstWhere((p) => p.name == winnerName);
      existingWinner.totalWins += 1;
    }

    emit(PlayersLoaded(List.from(players)));
  }

  FutureOr<void> _clearMatches(
    ClearMatches event,
    Emitter<PlayersState> emit,
  ) async {
    emit(PlayersLoading());

    for (var element in players) {
      element.totalGames = 0;
      element.totalWins = 0;
    }

    emit(PlayersLoaded(List.from(players)));
  }

  FutureOr<void> _cleanPlayers(
    ClearPlayers event,
    Emitter<PlayersState> emit,
  ) async {
    emit(PlayersLoading());

    players.clear();
    emit(PlayersLoaded(List.from(players)));
  }
}
