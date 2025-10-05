import 'package:equatable/equatable.dart';
import 'package:tennis_calculator/domain/models/match_history.dart';

abstract class HistoryState extends Equatable {
  const HistoryState();

  @override
  List<Object?> get props => [];
}

class HistoryInitial extends HistoryState {
  const HistoryInitial();
}

class HistoryLoaded extends HistoryState {
  final List<MatchHistory> histories;

  const HistoryLoaded(this.histories);

  @override
  List<Object?> get props => [histories];
}
