import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/game.dart';
import '../models/player.dart';

class ViewGameScreen extends StatefulWidget {
  const ViewGameScreen({
    super.key,
    required this.game,
    required this.players,
    required this.onEdit,
  });

  final Game game;
  final List<Player> players;
  final Future<Game?> Function() onEdit;

  @override
  State<ViewGameScreen> createState() => _ViewGameScreenState();
}

class _ViewGameScreenState extends State<ViewGameScreen> {
  late Set<String> _selectedPlayerIds;
  late final List<Player> _sortedPlayers;

  int get _maxSelectable => widget.game.playerCount;

  @override
  void initState() {
    super.initState();
    _selectedPlayerIds = widget.game.playerIds.toSet();
    _sortedPlayers = List<Player>.from(widget.players)
      ..sort(
        (a, b) => a.nickname.toLowerCase().compareTo(b.nickname.toLowerCase()),
      );
    _selectedPlayerIds.removeWhere((id) => id.isEmpty);
  }

  String _playerIdentity(Player player) {
    return player.id?.isNotEmpty == true ? player.id! : player.nickname;
  }

  void _togglePlayer(Player player, bool selected) {
    final playerId = _playerIdentity(player);
    if (selected && _selectedPlayerIds.length >= _maxSelectable) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Only $_maxSelectable players can be selected for this game.',
          ),
        ),
      );
      return;
    }
    setState(() {
      if (selected) {
        _selectedPlayerIds.add(playerId);
      } else {
        _selectedPlayerIds.remove(playerId);
      }
    });
  }

  void _removeMissingPlayer(String id) {
    setState(() {
      _selectedPlayerIds.remove(id);
    });
  }

  bool get _selectionChanged =>
      !setEquals(_selectedPlayerIds, widget.game.playerIds.toSet());

  void _saveSelection() {
    final updated = widget.game.copyWith(
      playerIds: _selectedPlayerIds.toList(),
    );
    Navigator.of(context).pop(GameViewResult.updated(updated));
  }

  @override
  Widget build(BuildContext context) {
    final int rawRemaining = _maxSelectable - _selectedPlayerIds.length;
    final int remainingSlots = rawRemaining <= 0 ? 0 : rawRemaining;
    final knownIds = _sortedPlayers.map(_playerIdentity).toSet();
    final removedPlayers = _selectedPlayerIds
        .where((id) => !knownIds.contains(id))
        .toList();
    final canSelectPlayers = _maxSelectable > 0;
    final exceedsLimit = _selectedPlayerIds.length > _maxSelectable;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.title),
        actions: [
          IconButton(
            onPressed: () async {
              final updated = await widget.onEdit();
              if (context.mounted && updated != null) {
                Navigator.of(context).pop(GameViewResult.updated(updated));
              }
            },
            icon: const Icon(Icons.edit),
            tooltip: 'Edit Game',
          ),
          IconButton(
            onPressed: () async {
              final shouldDelete = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Game'),
                  content: Text(
                    'Delete ${widget.game.title}? This cannot be undone.',
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
                ),
              );
              if (shouldDelete == true && context.mounted) {
                Navigator.of(context).pop(GameViewResult.deleted());
              }
            },
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Delete Game',
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _InfoRow(label: 'Court', value: widget.game.courtName),
            _InfoRow(
              label: 'Players',
              value: '${_selectedPlayerIds.length} / $_maxSelectable',
            ),
            _InfoRow(
              label: 'Court Rate',
              value: '₱${widget.game.courtRate.toStringAsFixed(2)}',
            ),
            _InfoRow(
              label: 'Shuttle Price',
              value: '₱${widget.game.shuttlePrice.toStringAsFixed(2)}',
            ),
            _InfoRow(
              label: 'Divide Equally',
              value: widget.game.divideEqually ? 'Yes' : 'No',
            ),
            const SizedBox(height: 16),
            Text('Schedules', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...widget.game.schedules.map(
              (schedule) => Card(
                child: ListTile(
                  title: Text(
                    '${schedule.courtName} • ${schedule.formattedDate}',
                  ),
                  subtitle: Text(schedule.formattedTimeRange),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Assign Players',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              exceedsLimit
                  ? 'Too many players selected. Reduce to $_maxSelectable before saving.'
                  : canSelectPlayers
                  ? 'Select up to $_maxSelectable players. $remainingSlots slot${remainingSlots == 1 ? '' : 's'} remaining.'
                  : 'Set the number of players for this game before assigning participants.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(
                  context,
                ).textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                for (final player in _sortedPlayers)
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: CheckboxListTile(
                      value: _selectedPlayerIds.contains(
                        _playerIdentity(player),
                      ),
                      onChanged: (value) =>
                          _togglePlayer(player, value ?? false),
                      title: Text(player.nickname),
                      subtitle: player.fullName.trim().isEmpty
                          ? null
                          : Text(player.fullName),
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
              ],
            ),
            if (removedPlayers.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'Removed players',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Column(
                children: removedPlayers
                    .map(
                      (id) => Card(
                        color: Theme.of(context).colorScheme.errorContainer,
                        child: ListTile(
                          title: Text(
                            'Removed player ($id)',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Theme.of(
                                context,
                              ).colorScheme.onErrorContainer,
                            ),
                            onPressed: () => _removeMissingPlayer(id),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
            const SizedBox(height: 24),
            _InfoRow(
              label: 'Total Cost',
              value: '₱${widget.game.totalCostOverall.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: (_selectionChanged && !exceedsLimit)
                  ? _saveSelection
                  : null,
              icon: const Icon(Icons.save),
              label: const Text('Save Player Selection'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(value),
        ],
      ),
    );
  }
}

class GameViewResult {
  const GameViewResult._({this.updatedGame, required this.isDeleted});

  final Game? updatedGame;
  final bool isDeleted;

  static GameViewResult deleted() => const GameViewResult._(isDeleted: true);
  static GameViewResult updated(Game game) =>
      GameViewResult._(updatedGame: game, isDeleted: false);
}
