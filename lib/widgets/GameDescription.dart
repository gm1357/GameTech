import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gametech/models/gameSummary.dart';
import 'package:url_launcher/url_launcher.dart';

class GameDescription extends StatelessWidget {
  final GameSummary game;

  GameDescription(this.game);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        game.description != null
            ? Html(
                data: '${game.description}',
                onLinkTap: (String relativePath) async =>
                    await _launchURL('https://www.giantbomb.com$relativePath'))
            : Text('${game.deck}'),
      ],
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