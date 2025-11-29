import 'package:equatable/equatable.dart';
import '../../domain/models/match_history.dart';

abstract class MatchHistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddHistory extends MatchHistoryEvent {
  final MatchHistory history;
  AddHistory(this.history);
  @override
  List<Object?> get props => [history];
}

class RemoveHistory extends MatchHistoryEvent {
  final MatchHistory history;
  RemoveHistory(this.history);
  @override
  List<Object?> get props => [history];
}

class ClearHistories extends MatchHistoryEvent {}

class LoadHistory extends MatchHistoryEvent {}
