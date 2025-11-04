class GameSchedule {
  const GameSchedule({
    required this.courtName,
    required this.start,
    required this.end,
  });

  final String courtName;
  final DateTime start;
  final DateTime end;

  String get formattedDate => '${start.month}/${start.day}/${start.year}';
  String get formattedTimeRange =>
      '${_formatTime(start)} - ${_formatTime(end)}';

  static String _formatTime(DateTime time) {
    final hour = time.hour % 12 == 0 ? 12 : time.hour % 12;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  GameSchedule copyWith({String? courtName, DateTime? start, DateTime? end}) {
    return GameSchedule(
      courtName: courtName ?? this.courtName,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }
}

class Game {
  const Game({
    this.id,
    required this.title,
    required this.courtName,
    required this.courtRate,
    required this.shuttlePrice,
    required this.divideEqually,
    required this.playerCount,
    required this.schedules,
  });

  final String? id;
  final String title;
  final String courtName;
  final double courtRate;
  final double shuttlePrice;
  final bool divideEqually;
  final int playerCount;
  final List<GameSchedule> schedules;

  double get totalCostPerGame => courtRate + shuttlePrice;
  double get totalCostOverall => totalCostPerGame * schedules.length;

  Game copyWith({
    String? id,
    String? title,
    String? courtName,
    double? courtRate,
    double? shuttlePrice,
    bool? divideEqually,
    int? playerCount,
    List<GameSchedule>? schedules,
  }) {
    return Game(
      id: id ?? this.id,
      title: title ?? this.title,
      courtName: courtName ?? this.courtName,
      courtRate: courtRate ?? this.courtRate,
      shuttlePrice: shuttlePrice ?? this.shuttlePrice,
      divideEqually: divideEqually ?? this.divideEqually,
      playerCount: playerCount ?? this.playerCount,
      schedules: schedules ?? this.schedules,
    );
  }
}
