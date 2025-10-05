import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:player_profile/main.dart';

void main() {
  testWidgets('All Players screen renders search and list', (tester) async {
    await tester.pumpWidget(const PlayerProfilesApp());

    expect(find.text('All Players'), findsOneWidget);
    expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
    expect(find.textContaining('Search by name or nickname'), findsOneWidget);
  });
}
