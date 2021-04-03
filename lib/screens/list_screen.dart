import 'package:flutter/material.dart';
import 'package:gametech/models/filters.dart';
import 'package:gametech/models/gameSummary.dart';
import 'package:gametech/screens/filter_screen.dart';
import 'package:gametech/widgets/GameTile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:intl/intl.dart';

class ListScreen extends StatefulWidget {
  static const routeName = '/list';

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  static const _pageSize = 20;

  Filters? filters;
  final PagingController<int, GameSummary> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    this.filters = new Filters(
      name: '',
      platform: '',
      fromDate: formatter.format(DateTime.now().subtract(Duration(days: 365))),
      toDate: formatter.format(DateTime.now()),
    );
    _pagingController.addPageRequestListener((pageKey) {
      fetchGames(pageKey, filters: _getFilterString(this.filters!));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games'),
      ),
      body: PagedListView<int, GameSummary>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<GameSummary>(
          itemBuilder: (context, item, index) => GameTile(
            item,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: doFilter,
        child: Icon(Icons.filter_list),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> fetchGames(int page, {filters: ''}) async {
    final sort = 'original_release_date:desc';
    final url = '${env['API_URL']}/public/games/' +
        '?sort=$sort' +
        '&filters=$filters' +
        '&offset=$page';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<GameSummary> games = [];
      var results = jsonDecode(response.body)['games'];
      for (var result in results) {
        games.add(GameSummary.fromJson(result));
      }

      final isLastPage = games.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(games);
      } else {
        final nextPageKey = page + games.length;
        _pagingController.appendPage(games, nextPageKey);
      }
    } else {
      throw Exception('Failed to load games');
    }
  }

  void doFilter() async {
    final filters = await Navigator.of(context)
        .pushNamed(FilterScreen.routeName, arguments: this.filters);
    if (filters != null) {
      this.filters = filters as Filters?;
      _pagingController.refresh();
    }
  }

  String _getFilterString(Filters filters) {
    var filters = '';
    if (this.filters != null) {
      filters += this.filters!.name != '' ? 'name:${this.filters!.name},' : '';
      filters += this.filters!.fromDate != ''
          ? 'original_release_date:${this.filters!.fromDate}|${this.filters!.toDate},'
          : '';
      filters += this.filters!.platform != ''
          ? 'platforms:${this.filters!.platform}'
          : '';
    }
    return filters;
  }
}
