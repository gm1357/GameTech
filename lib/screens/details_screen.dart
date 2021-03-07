import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gametech/models/gameDetail.dart';
import 'package:gametech/models/gameSummary.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DetailsScreen extends StatefulWidget {
  static const routeName = '/details';
  final GameSummary game;

  DetailsScreen(this.game);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;
  Future<GameDetail> futureGameDetails;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: 2,
      vsync: this,
    );
    futureGameDetails = fetchGame(widget.game.guid);
  }

  Future<GameDetail> fetchGame(String guid) async {
    final fields =
        'developers,franchises,genres,platforms,publishers,similar_games,images';
    final url =
        'https://www.giantbomb.com/api/game/$guid/?api_key=${env['API_KEY']}&format=json&field_list=$fields';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var result = jsonDecode(response.body)['results'];
      return GameDetail.fromJson(result);
    } else {
      throw Exception('Failed to load game');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _tabs = [
      GameDescription(widget.game),
      GameGallery(futureGameDetails),
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
                    tag: '${widget.game.name}-cover',
                    child: Image.network(
                      widget.game.cover,
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

class GameGallery extends StatelessWidget {
  final Future<GameDetail> futureGameDetails;

  GameGallery(this.futureGameDetails);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureGameDetails,
      builder: (context, snapshot) {
        if (snapshot.hasData &&
            snapshot.connectionState != ConnectionState.waiting) {
          return SingleChildScrollView(
            child: GridView.count(
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              crossAxisCount: 2,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: ScrollPhysics(),
              children: snapshot.data.images
                  .map((imageUrl) => Image.network(imageUrl, fit: BoxFit.cover,))
                  .toList()
                  .cast<Widget>(),
            ),
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
}
