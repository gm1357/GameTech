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
          final gameDetail = (snapshot.data as GameDetail);
          return Column(
            children: [
              SizedBox(
                height: 10,
              ),
              PlatformsChips(
                platforms: gameDetail.platforms ?? [],
              ),
              Divider(),
              gameDetail.description != null
                  ? Html(
                      data: '${gameDetail.description}',
                      onLinkTap: (path, context, attributes, element) {
                        path = path ?? '';
                        var url = path.startsWith('http') ? path : 'https://www.giantbomb.com$path';
                        _launchURL(url);
                      },
                      blacklistedElements: ['table']
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
