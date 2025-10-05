import 'package:flutter/material.dart';

import '../data/badminton_levels.dart';

class LevelLegend extends StatelessWidget {
  const LevelLegend({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tickWidth = constraints.maxWidth / kBadmintonLevelTicks.length;
        final strengthStyle = theme.textTheme.labelSmall?.copyWith(
          fontSize: 10,
          color: theme.colorScheme.outline,
        );
        final groupStyle = theme.textTheme.labelSmall?.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.w600,
        );

        return Column(
          children: [
            SizedBox(
              height: 16,
              child: Row(
                children: [
                  for (final tick in kBadmintonLevelTicks)
                    SizedBox(
                      width: tickWidth,
                      child: Center(
                        child: Text(
                          tick.strengthShort,
                          style: strengthStyle,
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 18,
              child: Row(
                children: [
                  for (final group in kBadmintonLevelGroups)
                    SizedBox(
                      width: tickWidth * group.length,
                      child: Center(
                        child: Text(
                          group.display.toUpperCase(),
                          style: groupStyle,
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
