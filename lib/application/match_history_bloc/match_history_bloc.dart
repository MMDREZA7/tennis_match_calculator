import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tennis_calculator/application/match_history_bloc/match_history_event.dart';
import 'package:tennis_calculator/application/match_history_bloc/match_history_state.dart';
import 'package:tennis_calculator/domain/models/match_history.dart';

class MatchHistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final List<MatchHistory> _histories = [];

  MatchHistoryBloc() : super(const HistoryInitial()) {
    on<AddHistory>(_onAddHistory);
    on<RemoveHistory>(_onRemoveHistory);
    on<ClearHistory>(_onClearHistory);
    on<LoadHistory>(_onLoadHistory);
  }

  FutureOr<void> _onAddHistory(
      AddHistory event, Emitter<HistoryState> emit) async {
    _histories.add(event.history);
    await _saveToPrefs();
    emit(HistoryLoaded(List.from(_histories)));
  }

  FutureOr<void> _onRemoveHistory(
      RemoveHistory event, Emitter<HistoryState> emit) async {
    _histories.removeWhere(
      (h) => h.createdAt == event.history.createdAt, // حذف بر اساس تاریخ یکتا
    );
    await _saveToPrefs();
    emit(HistoryLoaded(List.from(_histories)));
  }

  FutureOr<void> _onClearHistory(
      ClearHistory event, Emitter<HistoryState> emit) async {
    _histories.clear();
    await _saveToPrefs();
    emit(HistoryLoaded(List.from(_histories)));
  }

  FutureOr<void> _onLoadHistory(
      LoadHistory event, Emitter<HistoryState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('match_history') ?? '[]';
    final List decoded = jsonDecode(raw);
    _histories
      ..clear()
      ..addAll(decoded.map((e) => MatchHistory.fromJson(e)).toList());
    emit(HistoryLoaded(List.from(_histories)));
  }

  List<MatchHistory> get histories => List.unmodifiable(_histories);

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_histories.map((h) => h.toJson()).toList());
    await prefs.setString('match_history', encoded);
  }
}
