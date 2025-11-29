import 'package:shared_preferences/shared_preferences.dart';

Future<void> savePlayerName(String name) async {
  final prefs = await SharedPreferences.getInstance();
  final existing = prefs.getStringList('player_names') ?? [];
  if (!existing.contains(name)) {
    existing.add(name);
    await prefs.setStringList('player_names', existing);
  }
}

Future<List<String>> loadPlayerNames() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('player_names') ?? [];
}
