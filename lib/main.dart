import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tennis_calculator/application/match_history_bloc/match_history_bloc.dart';
import 'package:tennis_calculator/application/matches_bloc/matchs_bloc.dart';
import 'package:tennis_calculator/application/players_bloc/players_bloc.dart';
import 'package:tennis_calculator/presentation/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    TennisApp(),
  );
}

class TennisApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final baseGreen = const Color(0xFF2E7D32);
    final tennisYellow = const Color(0xFFFDD835);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PlayersBloc(),
        ),
        BlocProvider(
          create: (context) => MatchsBloc(),
        ),
        BlocProvider(
          create: (_) => MatchHistoryBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Tennis Match App',
        theme: ThemeData(
          primaryColor: baseGreen,
          colorScheme:
              ColorScheme.fromSwatch().copyWith(secondary: tennisYellow),
          appBarTheme: AppBarTheme(
            backgroundColor: baseGreen,
            foregroundColor: Colors.white,
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: tennisYellow,
            foregroundColor: Colors.black,
          ),
          scaffoldBackgroundColor: const Color(0xFFF3F8F2),
        ),
        home: HomePage(),
      ),
    );
  }
}
