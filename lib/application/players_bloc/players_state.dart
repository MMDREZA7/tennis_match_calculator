import 'package:equatable/equatable.dart';
import '../../domain/models/player.dart';

abstract class PlayersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PlayersInitial extends PlayersState {}

class PlayersLoading extends PlayersState {}

class PlayersLoaded extends PlayersState {
  final List<Player> players;
  PlayersLoaded(this.players);
  @override
  List<Object?> get props => [players];
}
