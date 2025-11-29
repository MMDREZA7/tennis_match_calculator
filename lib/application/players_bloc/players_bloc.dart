import 'dart:async';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:tennis_calculator/application/matches_bloc/matchs_bloc.dart';
import 'package:tennis_calculator/domain/models/tournament.dart';
import 'players_event.dart';
import 'players_state.dart';
import '../../domain/models/player.dart';
import '../../domain/models/game_score.dart';

class PlayersBloc extends Bloc<PlayersEvent, PlayersState> {
  List<Player> players = [];

  PlayersBloc() : super(PlayersInitial()) {
    on<AddPlayer>(_addPlayer);
    on<RemovePlayer>(_removePlayer);
    on<RegisterGame>(_registerGame);
    on<EditPlayer>(_editPlayer);
    on<RecordGame>(_recordGame);
    on<ClearMatches>(_clearMatches);
    on<ClearPlayers>(_clearPlayers);
  }

  void _updateRatesAndSort() {
    for (var p in players) {
      p.score =
          calculateScore(p.winCount, p.totalGames - p.winCount, p.totalGames);
    }
    players.sort((a, b) => b.winCount.compareTo(a.winCount));
  }

  double calculateScore(int wins, int losses, int matchesPlayed) {
    if (matchesPlayed == 0) return 0;

    double ratio = wins / (losses + 1);
    double score = ratio * log(matchesPlayed + 1);

    return score;
  }

  void _emitSorted(Emitter<PlayersState> emit) {
    _updateRatesAndSort();
    emit(PlayersLoaded(List.from(players)));
  }

  FutureOr<void> _addPlayer(AddPlayer event, Emitter<PlayersState> emit) {
    emit(PlayersLoading());
    players.add(Player(name: event.name));
    _emitSorted(emit);
  }

  FutureOr<void> _removePlayer(RemovePlayer event, Emitter<PlayersState> emit) {
    emit(PlayersLoading());
    players.removeWhere((p) => p.name == event.name);
    _emitSorted(emit);
  }

  FutureOr<void> _editPlayer(EditPlayer event, Emitter<PlayersState> emit) {
    emit(PlayersLoading());

    final index = players.indexWhere((p) => p.name == event.name);

    final updatedPlayer = players[index].copyWith(name: event.newName);

    players[index] = updatedPlayer;

    _emitSorted(emit);
  }

  FutureOr<void> _registerGame(RegisterGame event, Emitter<PlayersState> emit) {
    emit(PlayersLoading());

    final totalPlayers = players.length;

    for (var playerName in event.selectedPlayers) {
      final player = players.firstWhere((p) => p.name == playerName);
      player.totalGames += 1;
    }

    for (var winnerName in event.winnerNames) {
      final winner = players.firstWhere((p) => p.name == winnerName);
      winner.winCount += 1;

      for (var opponentName in event.selectedPlayers) {
        if (opponentName != winnerName) {
          winner.beatenOpponents.add(opponentName);
        }
      }

      if (event.selectedPlayers.length == 2 &&
          winner.beatenOpponents.length == totalPlayers - 1) {
        winner.specialWins += 1;
        winner.beatenOpponents.clear();
      }
    }

    for (var playerName in event.selectedPlayers) {
      if (!event.winnerNames.contains(playerName)) {
        final loser = players.firstWhere((p) => p.name == playerName);
        loser.beatenOpponents.clear();
      }
    }

    for (var playerName in event.selectedPlayers) {
      final player = players.firstWhere((p) => p.name == playerName);
      String opponentName = event.selectedPlayers
          .firstWhere((n) => n != playerName, orElse: () => '');
      int playerScore = 0;
      int opponentScore = 0;
      bool won = event.winnerNames.contains(playerName);

      if (event.scores != null && event.scores!.containsKey(playerName)) {
        final sc = event.scores![playerName]!;
        playerScore = sc['playerScore'] ?? playerScore;
        opponentScore = sc['opponentScore'] ?? opponentScore;
      } else {
        if (opponentName.isNotEmpty) {
          // final opp = players.firstWhere((p) => p.name == opponentName);
          playerScore = won ? 4 : 2;
          opponentScore = won ? 2 : 4;
        } else {
          playerScore = won ? 4 : 0;
          opponentScore = won ? 0 : 4;
        }
      }

      player.matches.add(GameScore(
        winnerPlayerName: playerName,
        LoserPlayerName: opponentName,
        playerScore: playerScore,
        opponentScore: opponentScore,
        date: DateTime.now(),
      ));
    }

    _emitSorted(emit);
  }

  FutureOr<void> _recordGame(
    RecordGame event,
    Emitter<PlayersState> emit,
  ) async {
    emit(PlayersLoading());

    if (event.tournamentType != null) {
      List<List<Player>> games = [];
      if (event.tournamentType == TournamentType.League) {
        games = generateFairLeague(event.selectedPlayers);
      } else {
        games = generateCupGames(event.selectedPlayers);
      }

      for (var match in games) {
        for (var player in match) {
          final p = players.firstWhere((pl) => pl.name == player.name);
          p.totalGames += 1;
          if (event.winnerPlayers.any((w) => w.name == p.name)) {
            p.winCount += 1;
          }
        }
      }
    } else {
      for (var player in event.selectedPlayers) {
        final p = players.firstWhere((pl) => pl.name == player.name);
        p.totalGames += 1;
        if (event.winnerPlayers.contains(player)) {
          p.winCount += 1;
        }
      }
    }

    _emitSorted(emit);
  }

  FutureOr<void> _clearMatches(
    ClearMatches event,
    Emitter<PlayersState> emit,
  ) async {
    emit(PlayersLoading());
    for (var p in players) {
      p.totalGames = 0;
      p.winCount = 0;
      p.score = 0;
      p.specialWins = 0;
      p.beatenOpponents.clear();
      p.matches.clear();
    }
    _emitSorted(emit);
  }

  FutureOr<void> _clearPlayers(
      ClearPlayers event, Emitter<PlayersState> emit) async {
    emit(PlayersLoading());
    players.clear();
    _emitSorted(emit);
  }
}
