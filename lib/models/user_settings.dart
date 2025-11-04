class UserSettings {
  const UserSettings({
    required this.defaultCourtName,
    required this.defaultCourtRate,
    required this.defaultShuttlePrice,
    required this.divideEqually,
  });

  final String defaultCourtName;
  final double defaultCourtRate;
  final double defaultShuttlePrice;
  final bool divideEqually;

  UserSettings copyWith({
    String? defaultCourtName,
    double? defaultCourtRate,
    double? defaultShuttlePrice,
    bool? divideEqually,
  }) {
    return UserSettings(
      defaultCourtName: defaultCourtName ?? this.defaultCourtName,
      defaultCourtRate: defaultCourtRate ?? this.defaultCourtRate,
      defaultShuttlePrice: defaultShuttlePrice ?? this.defaultShuttlePrice,
      divideEqually: divideEqually ?? this.divideEqually,
    );
  }
}
