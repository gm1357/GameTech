import 'package:flutter/material.dart';
import 'package:gametech/models/game.dart';
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

  @override
  void initState() {
    super.initState();
    futureGames = fetchGames();
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
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            return GamesList(snapshot.data);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: doFilter,
        child: Icon(Icons.filter_list),
      ),
    );
  }

  Future<List<Game>> fetchGames({filter: ''}) async {
    final apiKey = '925e2f4bd14e8305dd5ee8fc765d0294d64120a3';
    final sort = 'original_release_date:desc';
    final fields = 'name,deck,image';
    final url =
        'https://www.giantbomb.com/api/games/?api_key=$apiKey&format=json&sort=$sort&field_list=$fields&filter=$filter';
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
    final filter = await Navigator.of(context).pushNamed(FilterScreen.routeName);
    setState(() {
      futureGames = fetchGames(filter: filter);
    });
  }
}

class GamesList extends StatelessWidget {
  final List<Game> games;

  const GamesList(this.games, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: games.length,
        itemBuilder: (context, index) => GameTile(games[index]),
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
        ListTile(
          title: Text('${game.name}'),
          subtitle: Text('${game.deck}'),
          leading: Image.network('${game.imageIcon}'),
        ),
        Divider(),
      ],
    );
  }
}
