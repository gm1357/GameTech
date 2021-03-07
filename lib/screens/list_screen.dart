import 'package:flutter/material.dart';
import 'package:gametech/models/filters.dart';
import 'package:gametech/models/gameSummary.dart';
import 'package:gametech/screens/filter_screen.dart';
import 'package:gametech/widgets/GameList.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class ListScreen extends StatefulWidget {
  static const routeName = '/list';

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  Future<List<GameSummary>> futureGames;
  Filters filters;

  @override
  void initState() {
    super.initState();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    this.filters = new Filters(
      name: '',
      fromDate: formatter.format(DateTime.now().subtract(Duration(days: 365))),
      toDate: formatter.format(DateTime.now()),
    );
    futureGames = fetchGames(filters: _getFilterString(this.filters));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games'),
      ),
      body: FutureBuilder<List<GameSummary>>(
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

  Future<List<GameSummary>> fetchGames({filters: ''}) async {
    final sort = 'original_release_date:desc';
    final fields = 'name,deck,image,description,guid';
    final url =
        'https://www.giantbomb.com/api/games/?api_key=${env['API_KEY']}&format=json&sort=$sort&field_list=$fields&filter=$filters';
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<GameSummary> games = [];
      var results = jsonDecode(response.body)['results'];
      for (var result in results) {
        games.add(GameSummary.fromJson(result));
      }
      return games;
    } else {
      throw Exception('Failed to load games');
    }
  }

  void doFilter() async {
    final filters = await Navigator.of(context)
        .pushNamed(FilterScreen.routeName, arguments: this.filters);
    if (filters != null) {
      this.filters = filters;

      setState(() {
        futureGames = fetchGames(filters: _getFilterString(filters));
      });
    }
  }

  String _getFilterString(Filters filters) {
    return 'name:${this.filters.name},original_release_date:${filters.fromDate}|${filters.toDate}';
  }
}