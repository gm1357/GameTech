import 'package:flutter/material.dart';
import 'package:gametech/models/filters.dart';
import 'package:gametech/models/game.dart';
import 'package:gametech/screens/details_screen.dart';
import 'package:gametech/screens/filter_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListScreen extends StatefulWidget {
  static const routeName = '/list';

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  Future<List<Game>> futureGames;
  Filters filters;

  @override
  void initState() {
    super.initState();
    futureGames = fetchGames();
    this.filters = new Filters(name: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games'),
      ),
      body: FutureBuilder<List<Game>>(
        future: futureGames,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState != ConnectionState.waiting) {
            return GamesList(snapshot.data);
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: doFilter,
        child: Icon(Icons.filter_list),
      ),
    );
  }

  Future<List<Game>> fetchGames({filters: ''}) async {
    final apiKey = '925e2f4bd14e8305dd5ee8fc765d0294d64120a3';
    final sort = 'original_release_date:desc';
    final fields = 'name,deck,image,description';
    final url =
        'https://www.giantbomb.com/api/games/?api_key=$apiKey&format=json&sort=$sort&field_list=$fields&filter=$filters';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<Game> games = [];
      var results = jsonDecode(response.body)['results'];
      for (var result in results) {
        games.add(Game.fromJson(result));
      }
      return games;
    } else {
      throw Exception('Failed to load games');
    }
  }

  void doFilter() async {
    final filters = await Navigator.of(context)
        .pushNamed(FilterScreen.routeName, arguments: this.filters);
    this.filters = filters;
    final filterString = 'name:${this.filters.name}';

    setState(() {
      futureGames = fetchGames(filters: filterString);
    });
  }
}

class GamesList extends StatelessWidget {
  final List<Game> games;

  const GamesList(this.games, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: games.isNotEmpty
          ? ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) => GameTile(games[index]),
            )
          : Center(
              child: Text('No results :(\nTry different fields'),
            ),
    );
  }
}

class GameTile extends StatelessWidget {
  final Game game;

  const GameTile(
    this.game, {
    Key key,
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
                  '${game.imageDetail}',
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
