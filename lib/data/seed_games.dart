import 'package:flutter/material.dart';

import '../models/game.dart';
import '../models/player.dart';

GameSchedule _schedule({
  required String court,
  required DateTime date,
  required TimeOfDay start,
  required TimeOfDay end,
}) {
  final startDate = DateTime(
    date.year,
    date.month,
    date.day,
    start.hour,
    start.minute,
  );
  final endDate = DateTime(
    date.year,
    date.month,
    date.day,
    end.hour,
    end.minute,
  );
  return GameSchedule(
    courtName: court,
    start: startDate,
    end: endDate,
  );
}

List<String> resolvePlayerIds(List<Player> players, List<String> nicknames) {
  return nicknames.map((nickname) {
    for (final player in players) {
      if (player.nickname.toLowerCase() == nickname.toLowerCase()) {
        return player.id?.isNotEmpty == true ? player.id! : player.nickname;
      }
    }
    return nickname;
  }).toList();
}

List<Game> seedGames(List<Player> players) {
  final today = DateTime.now();
  final nextMonday = today.add(Duration(days: (DateTime.monday - today.weekday) % 7));
  final nextWednesday =
      today.add(Duration(days: (DateTime.wednesday - today.weekday + 7) % 7));

  final mondayPlayers = resolvePlayerIds(players, ['Ari', 'Dex', 'Mika', 'Nash']);
  final midweekPlayers =
      resolvePlayerIds(players, ['Pau', 'Rion', 'Ari', 'Dex', 'Mika', 'Nash']);

  return [
    Game(
      id: 'game-seed-1',
      title: 'Monday Smash Night',
      courtName: 'UP Diliman Gym',
      courtRate: 1200,
      shuttlePrice: 250,
      divideEqually: true,
      playerCount: mondayPlayers.length,
      schedules: [
        _schedule(
          court: 'Court A',
          date: nextMonday,
          start: const TimeOfDay(hour: 19, minute: 0),
          end: const TimeOfDay(hour: 21, minute: 0),
        ),
      ],
      playerIds: mondayPlayers,
    ),
    Game(
      id: 'game-seed-2',
      title: 'Midweek Rally',
      courtName: 'Makati Sports Hub',
      courtRate: 1500,
      shuttlePrice: 300,
      divideEqually: false,
      playerCount: midweekPlayers.length,
      schedules: [
        _schedule(
          court: 'Court 3',
          date: nextWednesday,
          start: const TimeOfDay(hour: 20, minute: 0),
          end: const TimeOfDay(hour: 22, minute: 0),
        ),
      ],
      playerIds: midweekPlayers,
    ),
  ];
}
