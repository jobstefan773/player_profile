import 'package:flutter/material.dart';

import '../models/player.dart';

/// Initial set of players to populate the app.
final List<Player> seedPlayers = [
  Player(
    id: 'seed-1',
    nickname: 'Harriette',
    fullName: 'Harriette Cabigao',
    contactNumber: '09171234567',
    email: 'harriette@example.com',
    address: 'Quezon City',
    remarks: 'Team captain and strategist.',
    levelRange: const RangeValues(13, 14),
  ),
  Player(
    id: 'seed-2',
    nickname: 'Marcel',
    fullName: 'Marcel Salmorin',
    contactNumber: '09179876543',
    email: 'marcel@example.com',
    address: 'Makati City',
    remarks: 'Prefers doubles matches.',
    levelRange: const RangeValues(9, 11),
  ),
  Player(
    id: 'seed-3',
    nickname: 'Krom',
    fullName: 'Kromyko Cruzado',
    contactNumber: '09171239876',
    email: 'krom@example.com',
    address: 'Pasig City',
    remarks: 'Intermediate all-rounder.',
    levelRange: const RangeValues(5, 5),
  ),
  Player(
    id: 'seed-4',
    nickname: 'Bea',
    fullName: 'Bea Lim',
    contactNumber: '09173334444',
    email: 'bea@example.com',
    address: 'Taguig City',
    remarks: 'Left-handed power smasher.',
    levelRange: const RangeValues(8, 10),
  ),
  Player(
    id: 'seed-5',
    nickname: 'Jies',
    fullName: 'Jiescotniel Bacaro',
    contactNumber: '09175556666',
    email: 'jies@example.com',
    address: 'Manila City',
    remarks: 'Court coverage specialist.',
    levelRange: const RangeValues(12, 14),
  ),
];
