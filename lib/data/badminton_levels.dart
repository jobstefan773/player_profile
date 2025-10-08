import 'package:flutter/material.dart';

const List<BadmintonLevelTick> kBadmintonLevelTicks = [
  BadmintonLevelTick(
    group: 'Beginners',
    groupShort: 'Beginners',
    strength: 'Weak',
    strengthShort: 'W',
  ),
  BadmintonLevelTick(
    group: 'Beginners',
    groupShort: 'Beginners',
    strength: 'Mid',
    strengthShort: 'M',
  ),
  BadmintonLevelTick(
    group: 'Beginners',
    groupShort: 'Beginners',
    strength: 'Strong',
    strengthShort: 'S',
  ),
  BadmintonLevelTick(
    group: 'Intermediate',
    groupShort: 'Intermediate',
    strength: 'Weak',
    strengthShort: 'W',
  ),
  BadmintonLevelTick(
    group: 'Intermediate',
    groupShort: 'Intermediate',
    strength: 'Mid',
    strengthShort: 'M',
  ),
  BadmintonLevelTick(
    group: 'Intermediate',
    groupShort: 'Intermediate',
    strength: 'Strong',
    strengthShort: 'S',
  ),
  BadmintonLevelTick(
    group: 'Level G',
    groupShort: 'Level G',
    strength: 'Weak',
    strengthShort: 'W',
  ),
  BadmintonLevelTick(
    group: 'Level G',
    groupShort: 'Level G',
    strength: 'Mid',
    strengthShort: 'M',
  ),
  BadmintonLevelTick(
    group: 'Level G',
    groupShort: 'Level G',
    strength: 'Strong',
    strengthShort: 'S',
  ),
  BadmintonLevelTick(
    group: 'Level F',
    groupShort: 'Level F',
    strength: 'Weak',
    strengthShort: 'W',
  ),
  BadmintonLevelTick(
    group: 'Level F',
    groupShort: 'Level F',
    strength: 'Mid',
    strengthShort: 'M',
  ),
  BadmintonLevelTick(
    group: 'Level F',
    groupShort: 'Level F',
    strength: 'Strong',
    strengthShort: 'S',
  ),
  BadmintonLevelTick(
    group: 'Level E',
    groupShort: 'Level E',
    strength: 'Weak',
    strengthShort: 'W',
  ),
  BadmintonLevelTick(
    group: 'Level E',
    groupShort: 'Level E',
    strength: 'Mid',
    strengthShort: 'M',
  ),
  BadmintonLevelTick(
    group: 'Level E',
    groupShort: 'Level E',
    strength: 'Strong',
    strengthShort: 'S',
  ),
  BadmintonLevelTick(
    group: 'Level D',
    groupShort: 'Level D',
    strength: 'Weak',
    strengthShort: 'W',
  ),
  BadmintonLevelTick(
    group: 'Level D',
    groupShort: 'Level D',
    strength: 'Mid',
    strengthShort: 'M',
  ),
  BadmintonLevelTick(
    group: 'Level D',
    groupShort: 'Level D',
    strength: 'Strong',
    strengthShort: 'S',
  ),
  BadmintonLevelTick(
    group: 'Open',
    groupShort: 'Open',
    strength: 'Weak',
    strengthShort: 'W',
  ),
  BadmintonLevelTick(
    group: 'Open',
    groupShort: 'Open',
    strength: 'Mid',
    strengthShort: 'M',
  ),
  BadmintonLevelTick(
    group: 'Open',
    groupShort: 'Open',
    strength: 'Strong',
    strengthShort: 'S',
  ),
];

const List<LevelGroup> kBadmintonLevelGroups = [
  LevelGroup(name: 'Beginners', display: 'Beg', startIndex: 0, endIndex: 2),
  LevelGroup(
    name: 'Intermediate',
    display: 'Inter',
    startIndex: 3,
    endIndex: 5,
  ),
  LevelGroup(name: 'Level G', display: 'Level G', startIndex: 6, endIndex: 8),
  LevelGroup(name: 'Level F', display: 'Level F', startIndex: 9, endIndex: 11),
  LevelGroup(name: 'Level E', display: 'Level E', startIndex: 12, endIndex: 14),
  LevelGroup(name: 'Level D', display: 'Level D', startIndex: 15, endIndex: 17),
  LevelGroup(name: 'Open', display: 'Open', startIndex: 18, endIndex: 20),
];

String levelLabelForIndex(int index) {
  final safeIndex = index.clamp(0, kBadmintonLevelTicks.length - 1);
  final tick = kBadmintonLevelTicks[safeIndex];
  return '${tick.strength} ${tick.groupShort}';
}

String describeLevelRange(RangeValues range) {
  final startLabel = levelLabelForIndex(range.start.round());
  final endLabel = levelLabelForIndex(range.end.round());
  if (startLabel == endLabel) {
    return startLabel;
  }
  return '$startLabel, $endLabel';
}

class BadmintonLevelTick {
  const BadmintonLevelTick({
    required this.group,
    required this.groupShort,
    required this.strength,
    required this.strengthShort,
  });

  final String group;
  final String groupShort;
  final String strength;
  final String strengthShort;
}

class LevelGroup {
  const LevelGroup({
    required this.name,
    required this.display,
    required this.startIndex,
    required this.endIndex,
  });

  final String name;
  final String display;
  final int startIndex;
  final int endIndex;

  int get length => endIndex - startIndex + 1;
}
