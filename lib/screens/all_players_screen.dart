import 'package:flutter/material.dart';

import '../data/badminton_levels.dart';
import '../models/player.dart';
import 'player_form_page.dart';

class AllPlayersScreen extends StatefulWidget {
  const AllPlayersScreen({
    super.key,
    required this.players,
    required this.onAddPlayer,
    required this.onUpdatePlayer,
    required this.onDeletePlayer,
  });

  final List<Player> players;
  final ValueChanged<Player> onAddPlayer;
  final ValueChanged<Player> onUpdatePlayer;
  final ValueChanged<Player> onDeletePlayer;

  @override
  State<AllPlayersScreen> createState() => _AllPlayersScreenState();
}

class _AllPlayersScreenState extends State<AllPlayersScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchTerm = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Player> get _filteredPlayers {
    if (_searchTerm.isEmpty) {
      return widget.players;
    }
    final query = _searchTerm.toLowerCase();
    return widget.players.where((player) {
      return player.nickname.toLowerCase().contains(query) ||
          player.fullName.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> _openAddPlayer() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayerFormPage(
          title: 'Add New Player',
          onSubmit: widget.onAddPlayer,
        ),
      ),
    );
  }

  Future<void> _openEditPlayer(Player player) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PlayerFormPage(
          title: 'Edit Player Profile',
          initialPlayer: player,
          onSubmit: widget.onUpdatePlayer,
          onDelete: (playerToDelete) {
            widget.onDeletePlayer(playerToDelete);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${playerToDelete.nickname} deleted.')),
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool?> _confirmDelete(Player player) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Player'),
          content: Text(
            'Delete ${player.nickname}? This action cannot be undone.',
          ),
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredPlayers = _filteredPlayers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Players'),
        actions: [
          IconButton(
            onPressed: _openAddPlayer,
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add New Player',
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
                  hintText: 'Search by name or nickname',
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
                            setState(() {
                              _searchTerm = '';
                            });
                          },
                          icon: const Icon(Icons.clear),
                          tooltip: 'Clear search',
                        ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchTerm = value.trim();
                  });
                },
              ),
            ),
            Expanded(
              child: filteredPlayers.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          widget.players.isEmpty
                              ? 'No player profiles yet. Tap the add button to create one.'
                              : 'No players found for "$_searchTerm".',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemBuilder: (context, index) {
                        final player = filteredPlayers[index];
                        return Dismissible(
                          key: ValueKey(player.id ?? player.nickname),
                          direction: DismissDirection.endToStart,
                          confirmDismiss: (_) async {
                            final messenger = ScaffoldMessenger.of(context);
                            final shouldDelete = await _confirmDelete(player);
                            if (!mounted) {
                              return false;
                            }
                            if (shouldDelete == true) {
                              widget.onDeletePlayer(player);
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text('${player.nickname} deleted.'),
                                ),
                              );
                            }
                            return shouldDelete == true;
                          },
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
                              onTap: () => _openEditPlayer(player),
                              leading: CircleAvatar(
                                radius: 26,
                                backgroundColor: _avatarColorFor(
                                  player.nickname,
                                ),
                                child: Text(
                                  player.nickname.isEmpty
                                      ? '?'
                                      : player.nickname.characters.first
                                            .toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                player.nickname,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(player.fullName),
                                    Text(describeLevelRange(player.levelRange)),
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
                      itemCount: filteredPlayers.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _avatarColorFor(String name) {
  if (name.isEmpty) {
    return Colors.grey;
  }
  var code = 0;
  for (final rune in name.runes) {
    code += rune;
  }
  final colors = Colors.primaries;
  return colors[code % colors.length];
}
