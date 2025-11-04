import 'package:flutter/material.dart';

import 'data/default_user_settings.dart';
import 'data/seed_players.dart';
import 'models/game.dart';
import 'models/player.dart';
import 'models/user_settings.dart';
import 'screens/all_games_screen.dart';
import 'screens/all_players_screen.dart';

void main() {
  runApp(const PlayerProfilesApp());
}

class PlayerProfilesApp extends StatelessWidget {
  const PlayerProfilesApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(seedColor: const Color(0xFF1616FF))
        .copyWith(
          primary: const Color(0xFF00008B),
          onPrimary: Colors.white,
          primaryContainer: const Color(0xFF00005A),
          onPrimaryContainer: Colors.white,
        );

    return MaterialApp(
      title: 'Player Profiles',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          centerTitle: true,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
          ),
        ),
      ),
      home: const PlayerProfilesHome(),
    );
  }
}

class PlayerProfilesHome extends StatefulWidget {
  const PlayerProfilesHome({super.key});

  @override
  State<PlayerProfilesHome> createState() => _PlayerProfilesHomeState();
}

class _PlayerProfilesHomeState extends State<PlayerProfilesHome> {
  final List<Player> _players = List<Player>.from(seedPlayers);
  List<Game> _games = const [];
  UserSettings _settings = defaultUserSettings;
  int _currentIndex = 0;

  void _addPlayer(Player player) {
    final withId = player.copyWith(
      id: player.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
    );
    setState(() {
      _players.add(withId);
    });
  }

  void _updatePlayer(Player player) {
    final index = _players.indexWhere((element) => element.id == player.id);
    if (index == -1) {
      return;
    }
    setState(() {
      _players[index] = player;
    });
  }

  void _deletePlayer(Player player) {
    setState(() {
      _players.removeWhere((element) => element.id == player.id);
    });
  }

  Widget _buildCurrentPage() {
    if (_currentIndex == 0) {
      return AllPlayersScreen(
        players: _players,
        onAddPlayer: _addPlayer,
        onUpdatePlayer: _updatePlayer,
        onDeletePlayer: _deletePlayer,
        onOpenGames: () => setState(() => _currentIndex = 1),
      );
    }

    return AllGamesScreen(
      initialGames: _games,
      initialSettings: _settings,
      onSettingsUpdated: (settings) {
        setState(() {
          _settings = settings;
        });
      },
      onGamesChanged: (games) {
        setState(() {
          _games = List<Game>.from(games);
        });
      },
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildCurrentPage(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _onPageChanged,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            selectedItemColor: Theme.of(context).colorScheme.onPrimaryContainer,
            unselectedItemColor: Theme.of(
              context,
            ).colorScheme.onPrimaryContainer.withValues(alpha: 0.6),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.people_alt_outlined),
                activeIcon: Icon(Icons.people_alt),
                label: 'Players',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event_note_outlined),
                activeIcon: Icon(Icons.event_note),
                label: 'Games',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
