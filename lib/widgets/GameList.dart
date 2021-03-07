import 'package:flutter/material.dart';
import 'package:gametech/models/gameSummary.dart';
import 'package:gametech/widgets/GameTile.dart';

class GamesList extends StatelessWidget {
  final List<GameSummary> games;

  const GamesList(this.games, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: games.isNotEmpty
          ? ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) => GameTile(games[index]),
            )
          : Center(
              child: Text('No results :(\nTry different fielters'),
            ),
    );
  }
}