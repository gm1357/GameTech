import 'package:flutter/material.dart';
import 'package:gametech/models/gameSummary.dart';
import 'package:gametech/screens/details_screen.dart';

class GameTile extends StatelessWidget {
  final GameSummary game;

  const GameTile(
    this.game, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Tooltip(
          message: '${game.name}',
          child: ListTile(
            title: Text(
              '${game.name}',
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text('${game.deck}'),
            leading: Hero(
              child: Container(
                width: 50,
                height: 50,
                child: Image.network(
                  '${game.cover}',
                  fit: BoxFit.cover,
                ),
              ),
              tag: '${game.name}-cover',
            ),
            onTap: () => Navigator.of(context)
                .pushNamed(DetailsScreen.routeName, arguments: game),
          ),
        ),
        Divider(),
      ],
    );
  }
}