import 'package:flutter/material.dart';

import '../models/player.dart';

/// Initial set of players to populate the app.
final List<Player> seedPlayers = [
  Player(
    id: 'seed-1',
    nickname: 'Ari',
    fullName: 'Ariana Cruz',
    contactNumber: '09170001111',
    email: 'ari.cruz@example.com',
    address: 'Las Piñas City',
    remarks: 'Calm baseliner with strong defense.',
    levelRange: const RangeValues(7, 9),
  ),
  Player(
    id: 'seed-2',
    nickname: 'Dex',
    fullName: 'Dexter Villanueva',
    contactNumber: '09172223333',
    email: 'dex.villanueva@example.com',
    address: 'Mandaluyong City',
    remarks: 'Powerful smasher who loves mixed doubles.',
    levelRange: const RangeValues(10, 12),
  ),
  Player(
    id: 'seed-3',
    nickname: 'Mika',
    fullName: 'Mikaela Yu',
    contactNumber: '09175554444',
    email: 'mika.yu@example.com',
    address: 'Quezon City',
    remarks: 'Reliable setter with quick reflexes.',
    levelRange: const RangeValues(8, 9),
  ),
  Player(
    id: 'seed-4',
    nickname: 'Nash',
    fullName: 'Ignacio Manansala',
    contactNumber: '09178889999',
    email: 'nash.manansala@example.com',
    address: 'San Juan City',
    remarks: 'Offensive-minded left-hander.',
    levelRange: const RangeValues(11, 13),
  ),
  Player(
    id: 'seed-5',
    nickname: 'Pau',
    fullName: 'Pauline Santiago',
    contactNumber: '09176667777',
    email: 'pau.santiago@example.com',
    address: 'Marikina City',
    remarks: 'Strategist who studies opponents closely.',
    levelRange: const RangeValues(6, 7),
  ),
  Player(
    id: 'seed-6',
    nickname: 'Rion',
    fullName: 'Rion Mercado',
    contactNumber: '09179998888',
    email: 'rion.mercado@example.com',
    address: 'Pasay City',
    remarks: 'Energetic net player with fearless dives.',
    levelRange: const RangeValues(12, 14),
  ),
];
