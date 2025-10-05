import 'package:flutter/material.dart';

import 'models/player.dart';
import 'screens/all_players_screen.dart';

void main() {
  runApp(const PlayerProfilesApp());
}

class PlayerProfilesApp extends StatelessWidget {
  const PlayerProfilesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Player Profiles',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
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
  final List<Player> _players = [];

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

  @override
  Widget build(BuildContext context) {
    return AllPlayersScreen(
      players: _players,
      onAddPlayer: _addPlayer,
      onUpdatePlayer: _updatePlayer,
      onDeletePlayer: _deletePlayer,
    );
  }
}
