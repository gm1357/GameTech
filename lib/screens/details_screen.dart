import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gametech/models/gameDetail.dart';
import 'package:gametech/models/gameSummary.dart';
import 'package:gametech/widgets/GameDescription.dart';
import 'package:gametech/widgets/GameGallery.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DetailsScreen extends StatefulWidget {
  static const routeName = '/details';
  final GameSummary? game;
  final int tabIndex;

  DetailsScreen(this.game, this.tabIndex);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen>
    with SingleTickerProviderStateMixin {
  TabController? controller;
  Future<GameDetail>? futureGameDetails;

  @override
  void initState() {
    super.initState();
    controller = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.tabIndex
    );
    futureGameDetails = fetchGame(widget.game!.guid);
  }

  Future<GameDetail> fetchGame(String? guid) async {
    final fields =
        'developers,franchises,genres,platforms,publishers,similar_games,images';
    final url =
        'https://www.giantbomb.com/api/game/$guid/?api_key=${env['API_KEY']}&format=json&field_list=$fields';
    final response = await http.get(Uri.parse(url));

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
      GameDescription(widget.game, futureGameDetails),
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
                    tag: '${widget.game!.name}-cover',
                    child: Image.network(
                      widget.game!.cover!,
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