import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gametech/models/gameDetail.dart';
import 'package:gametech/models/gameSummary.dart';
import 'package:gametech/widgets/PlatformsChips.dart';
import 'package:url_launcher/url_launcher.dart';

class GameDescription extends StatelessWidget {
  final GameSummary? game;
  final Future<GameDetail>? futureGameDetails;

  GameDescription(
    this.game,
    this.futureGameDetails,
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureGameDetails,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState != ConnectionState.waiting) {
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              PlatformsChips(
                platforms: (snapshot.data as GameDetail).platforms ?? [],
              ),
              Divider(),
              game!.description != null
                  ? Html(
                      data: '${game!.description}',
                      onLinkTap: (relativePath, context, attributes, element) =>
                          _launchURL('https://www.giantbomb.com$relativePath'),
                    )
                  : Text('${game!.deck}'),
            ],
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('${snapshot.error}'),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
