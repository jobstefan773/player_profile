import 'package:flutter/material.dart';

import 'data/default_user_settings.dart';
import 'data/seed_games.dart';
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
  late final List<Player> _players;
  late List<Game> _games;
  UserSettings _settings = defaultUserSettings;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _players = List<Player>.from(seedPlayers);
    _games = seedGames(_players);
  }

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
      players: _players,
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
        child: PhysicalModel(
          color: Colors.transparent,
          elevation: 12,
          borderRadius: BorderRadius.circular(40),
          shadowColor: Colors.black.withValues(alpha: 0.12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              height: 72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _NavButton(
                    icon: Icons.people_alt_outlined,
                    activeIcon: Icons.people_alt,
                    label: 'Players',
                    selected: _currentIndex == 0,
                    onTap: () => _onPageChanged(0),
                  ),
                  _NavButton(
                    icon: Icons.event_note_outlined,
                    activeIcon: Icons.event_note,
                    label: 'Games',
                    selected: _currentIndex == 1,
                    onTap: () => _onPageChanged(1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  static const _inkBorderRadius = BorderRadius.all(Radius.circular(40));
  const _NavButton({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color iconColor = selected
        ? colorScheme.onPrimaryContainer
        : colorScheme.onPrimaryContainer.withValues(alpha: 0.6);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: _inkBorderRadius,
          splashColor: iconColor.withValues(alpha: 0.12),
          highlightColor: iconColor.withValues(alpha: 0.05),
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(selected ? activeIcon : icon, color: iconColor),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: iconColor,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
