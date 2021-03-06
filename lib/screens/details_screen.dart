import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gametech/models/game.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsScreen extends StatefulWidget {
  static const routeName = '/details';

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Game game = ModalRoute.of(context).settings.arguments;
    final _tabs = [
      GameDescription(game),
      GameGallery(),
    ];

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: '${game.name}-cover',
                    child: Image.network(
                      game.imageDetail,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                bottom: TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.description)),
                    Tab(icon: Icon(Icons.photo)),
                  ],
                  controller: controller,
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: controller,
          children: _tabs.map((Widget widget) {
            return SafeArea(
              top: false,
              bottom: false,
              child: Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    key: PageStorageKey<String>(widget.key.toString()),
                    slivers: <Widget>[
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                            context),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(8.0),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([widget]),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class GameDescription extends StatelessWidget {
  final Game game;

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

class GameGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text('teste')],
    );
  }
}
