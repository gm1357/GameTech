import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gametech/models/game.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailsScreen extends StatelessWidget {
  static const routeName = '/details';

  @override
  Widget build(BuildContext context) {
    final Game game = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(game.name),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Hero(
              child: IntrinsicWidth(
                child: Container(
                  color: Colors.black,
                  height: 200,
                  child: Image.network(
                    '${game.imageDetail}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              tag: '${game.name}-cover',
            ),
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Html(
                  data: '${game.description}',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
