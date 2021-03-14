import 'package:flutter/material.dart';
import 'package:gametech/models/gameDetail.dart';

class PlatformsChips extends StatelessWidget {
  final List<Platform> platforms;

  const PlatformsChips({
    required this.platforms,
  });

  @override
  Widget build(BuildContext context) {
    var colors = [
      Colors.red,
      Colors.black54,
    ];
    var index = -1;
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      alignment: WrapAlignment.center,
      children: platforms.map(
        (platform) {
          index++;
          return Tooltip(
            message: '${platform.name}',
            child: Chip(
              backgroundColor: colors[index % colors.length],
              label: Text(
                '${platform.abbreviation}',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
