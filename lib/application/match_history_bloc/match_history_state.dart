import 'package:equatable/equatable.dart';
import '../../domain/models/match_history.dart';

abstract class MatchHistoryState extends Equatable {
  const MatchHistoryState();
  @override
  List<Object?> get props => [];
}

class MatchHistoryInitial extends MatchHistoryState {
  const MatchHistoryInitial();
}

class MatchHistoryLoaded extends MatchHistoryState {
  final List<MatchHistory> histories;
  MatchHistoryLoaded(this.histories);
  @override
  List<Object?> get props => [histories];
}
