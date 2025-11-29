import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'match_history_event.dart';
import 'match_history_state.dart';
import '../../domain/models/match_history.dart';

class MatchHistoryBloc extends Bloc<MatchHistoryEvent, MatchHistoryState> {
  final List<MatchHistory> _histories = [];

  MatchHistoryBloc() : super(const MatchHistoryInitial()) {
    on<AddHistory>(_onAddHistory);
    on<RemoveHistory>(_onRemoveHistory);
    on<ClearHistories>(_onClearHistories);
    on<LoadHistory>(_onLoadHistory);
  }

  FutureOr<void> _onAddHistory(
      AddHistory event, Emitter<MatchHistoryState> emit) async {
    _histories.add(event.history);
    await _saveToPrefs();
    emit(MatchHistoryLoaded(List.from(_histories)));
  }

  FutureOr<void> _onRemoveHistory(
      RemoveHistory event, Emitter<MatchHistoryState> emit) async {
    _histories.removeWhere((h) => h.createdAt == event.history.createdAt);
    await _saveToPrefs();
    emit(MatchHistoryLoaded(List.from(_histories)));
  }

  FutureOr<void> _onClearHistories(
      ClearHistories event, Emitter<MatchHistoryState> emit) async {
    _histories.clear();
    await _saveToPrefs();
    emit(MatchHistoryLoaded(List.from(_histories)));
  }

  FutureOr<void> _onLoadHistory(
      LoadHistory event, Emitter<MatchHistoryState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('match_history') ?? '[]';
    final List decoded = jsonDecode(raw) as List<dynamic>;
    _histories
      ..clear()
      ..addAll(decoded
          .map((e) => MatchHistory.fromJson(e as Map<String, dynamic>))
          .toList());
    emit(MatchHistoryLoaded(List.from(_histories)));
  }

  List<MatchHistory> get histories => List.unmodifiable(_histories);

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_histories.map((h) => h.toJson()).toList());
    await prefs.setString('match_history', encoded);
  }
}
