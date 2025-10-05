import 'package:equatable/equatable.dart';
import 'package:tennis_calculator/domain/models/match_history.dart';

abstract class HistoryEvent extends Equatable {
  const HistoryEvent();

  @override
  List<Object?> get props => [];
}

class AddHistory extends HistoryEvent {
  final MatchHistory history;
  const AddHistory(this.history);

  @override
  List<Object?> get props => [history];
}

class RemoveHistory extends HistoryEvent {
  final MatchHistory history;
  const RemoveHistory(this.history);

  @override
  List<Object?> get props => [history];
}

class ClearHistory extends HistoryEvent {
  const ClearHistory();
}

class LoadHistory extends HistoryEvent {
  const LoadHistory();
}
