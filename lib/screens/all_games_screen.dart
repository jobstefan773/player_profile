import 'package:flutter/material.dart';

import '../models/game.dart';
import '../models/user_settings.dart';
import 'game_form_page.dart';
import 'user_settings_screen.dart';
import 'view_game_screen.dart';

class AllGamesScreen extends StatefulWidget {
  const AllGamesScreen({
    super.key,
    required this.initialGames,
    required this.initialSettings,
    required this.onSettingsUpdated,
    required this.onGamesChanged,
  });

  final List<Game> initialGames;
  final UserSettings initialSettings;
  final ValueChanged<UserSettings> onSettingsUpdated;
  final ValueChanged<List<Game>> onGamesChanged;

  @override
  State<AllGamesScreen> createState() => _AllGamesScreenState();
}

class _AllGamesScreenState extends State<AllGamesScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<Game> _games;
  late UserSettings _settings;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _games = List<Game>.from(widget.initialGames);
    _settings = widget.initialSettings;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Game> get _filteredGames {
    if (_searchTerm.isEmpty) {
      return _games;
    }
    final query = _searchTerm.toLowerCase();
    return _games.where((game) {
      final titleMatch = game.title.toLowerCase().contains(query);
      final dateMatch = game.schedules.any(
        (schedule) => schedule.formattedDate.toLowerCase().contains(query),
      );
      return titleMatch || dateMatch;
    }).toList();
  }

  Future<void> _openSettings() async {
    final updated = await Navigator.of(context).push<UserSettings>(
      MaterialPageRoute(
        builder: (_) => UserSettingsScreen(initialSettings: _settings),
      ),
    );
    if (updated != null) {
      setState(() => _settings = updated);
      widget.onSettingsUpdated(updated);
    }
  }

  Future<void> _addGame() async {
    final newGame = await Navigator.of(context).push<Game>(
      MaterialPageRoute(
        builder: (_) => GameFormPage(
          title: 'Add New Game',
          userSettings: _settings,
          existingGames: _games,
        ),
      ),
    );
    if (newGame != null) {
      setState(() {
        final withId = newGame.copyWith(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
        );
        _games = List<Game>.from(_games)..add(withId);
      });
      widget.onGamesChanged(_games);
    }
  }

  Future<void> _viewGame(Game game) async {
    final result = await Navigator.of(context).push<GameViewResult>(
      MaterialPageRoute(
        builder: (_) => ViewGameScreen(
          game: game,
          onEdit: () async {
            final updatedGame = await Navigator.of(context).push<Game>(
              MaterialPageRoute(
                builder: (_) => GameFormPage(
                  title: 'Edit Game',
                  userSettings: _settings,
                  existingGames: _games,
                  initialGame: game,
                ),
              ),
            );
            return updatedGame;
          },
        ),
      ),
    );

    if (result == null) {
      return;
    }

    if (result.isDeleted) {
      setState(() {
        _games = List<Game>.from(_games)..removeWhere((g) => g.id == game.id);
      });
      widget.onGamesChanged(_games);
    } else if (result.updatedGame != null) {
      setState(() {
        final index = _games.indexWhere((g) => g.id == result.updatedGame!.id);
        if (index != -1) {
          _games[index] = result.updatedGame!;
        }
      });
      widget.onGamesChanged(_games);
    }
  }

  Future<bool> _confirmDelete(Game game) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Game'),
        content: Text('Delete ${game.title}? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (shouldDelete == true) {
      setState(() {
        _games = List<Game>.from(_games)..removeWhere((g) => g.id == game.id);
      });
      widget.onGamesChanged(_games);
    }
    return shouldDelete ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Games'),
        actions: [
          IconButton(
            onPressed: _openSettings,
            icon: const Icon(Icons.settings),
            tooltip: 'User Settings',
          ),
          IconButton(
            onPressed: _addGame,
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add New Game',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by game name or date',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  suffixIcon: _searchTerm.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchTerm = '');
                          },
                          icon: const Icon(Icons.clear),
                        ),
                ),
                onChanged: (value) {
                  setState(() => _searchTerm = value.trim());
                },
              ),
            ),
            Expanded(
              child: _filteredGames.isEmpty
                  ? const Center(
                      child: Text(
                        'No games found. Tap add to schedule a game.',
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemBuilder: (context, index) {
                        final game = _filteredGames[index];
                        return Dismissible(
                          key: ValueKey(game.id ?? index),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) => _confirmDelete(game),
                          background: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.errorContainer,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.delete,
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
                            ),
                          ),
                          child: Card(
                            margin: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: ListTile(
                              onTap: () => _viewGame(game),
                              title: Text(game.title),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${game.schedules.first.formattedDate} • ${game.schedules.first.courtName}',
                                    ),
                                    Text(
                                      '${game.playerCount} players • ₱${game.totalCostOverall.toStringAsFixed(2)} total',
                                    ),
                                  ],
                                ),
                              ),
                              trailing: const Icon(Icons.chevron_right),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 12),
                      itemCount: _filteredGames.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
