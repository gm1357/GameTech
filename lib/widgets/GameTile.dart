import 'package:flutter/material.dart';
import 'package:gametech/models/detailsArguments.dart';
import 'package:gametech/models/gameSummary.dart';
import 'package:gametech/screens/details_screen.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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
          child: Slidable(
            actionPane: SlidableScrollActionPane(),
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
              onTap: () => Navigator.of(context).pushNamed(
                DetailsScreen.routeName,
                arguments: new DetailsArguments(game, 0),
              ),
            ),
            secondaryActions: getActions(context),
            actions: getActions(context),
          ),
        ),
        Divider(),
      ],
    );
  }

  getActions(BuildContext context) {
    return <Widget>[
      IconSlideAction(
        caption: 'Description',
        color: Colors.black45,
        icon: Icons.description,
        onTap: () => Navigator.of(context).pushNamed(
          DetailsScreen.routeName,
          arguments: new DetailsArguments(game, 0),
        ),
      ),
      IconSlideAction(
        caption: 'Gallery',
        color: Theme.of(context).primaryColor,
        icon: Icons.image,
        onTap: () => Navigator.of(context).pushNamed(
          DetailsScreen.routeName,
          arguments: new DetailsArguments(game, 1),
        ),
      ),
    ];
  }
}
