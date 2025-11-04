import 'package:flutter/material.dart';

import '../models/game.dart';

class ViewGameScreen extends StatelessWidget {
  const ViewGameScreen({super.key, required this.game, required this.onEdit});

  final Game game;
  final Future<Game?> Function() onEdit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(game.title),
        actions: [
          IconButton(
            onPressed: () async {
              final updated = await onEdit();
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
            _InfoRow(label: 'Court', value: game.courtName),
            _InfoRow(label: 'Players', value: game.playerCount.toString()),
            _InfoRow(
              label: 'Court Rate',
              value: '₱${game.courtRate.toStringAsFixed(2)}',
            ),
            _InfoRow(
              label: 'Shuttle Price',
              value: '₱${game.shuttlePrice.toStringAsFixed(2)}',
            ),
            _InfoRow(
              label: 'Divide Equally',
              value: game.divideEqually ? 'Yes' : 'No',
            ),
            const SizedBox(height: 16),
            Text('Schedules', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...game.schedules.map(
              (schedule) => Card(
                child: ListTile(
                  title: Text(
                    '${schedule.courtName} • ${schedule.formattedDate}',
                  ),
                  subtitle: Text(schedule.formattedTimeRange),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _InfoRow(
              label: 'Total Cost',
              value: '₱${game.totalCostOverall.toStringAsFixed(2)}',
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
