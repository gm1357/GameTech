import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gametech/models/game.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatelessWidget {
  static const routeName = '/details';

  @override
  Widget build(BuildContext context) {
    final Game game = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                game.name,
                overflow: TextOverflow.ellipsis,
              ),
              background: Hero(
                tag: '${game.name}-cover',
                child: Image.network(
                  game.imageDetail,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10),
              game.description != null
                  ? Html(
                      data: '${game.description}',
                      onLinkTap: (String relativePath) async =>
                          await _launchURL(
                              'https://www.giantbomb.com$relativePath'))
                  : Text('${game.deck}'),
            ]),
          ),
        ],
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
