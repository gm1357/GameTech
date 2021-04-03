import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gametech/models/filters.dart';
import 'package:gametech/models/platform.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FilterScreen extends StatefulWidget {
  static const routeName = '/filters';
  final Filters? filters;

  const FilterScreen(this.filters);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final DateFormat _formatter = DateFormat('yyyy-MM-dd');
  final _nameController = new TextEditingController();
  final _fromDateController = new TextEditingController();
  final _toDateController = new TextEditingController();
  String _platformSelected = '';
  Future<List<Platform>>? futurePlatforms;

  @override
  void initState() {
    super.initState();
    futurePlatforms = _fetchPlatforms();
    _nameController.text = widget.filters?.name ?? '';
    _fromDateController.text = widget.filters?.fromDate ??
        _formatter.format(DateTime.now().subtract(Duration(days: 365)));
    _toDateController.text =
        widget.filters?.toDate ?? _formatter.format(DateTime.now());
    _platformSelected = widget.filters?.platform ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Filters'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              controller: _nameController,
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Release date from'),
                    controller: _fromDateController,
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    onTap: () =>
                        _selectDate(context, _fromDateController, 'From:'),
                  ),
                ),
                SizedBox(width: 30),
                Flexible(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Release date to'),
                    controller: _toDateController,
                    keyboardType: TextInputType.datetime,
                    readOnly: true,
                    onTap: () => _selectDate(context, _toDateController, 'To:'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Text('Platforms'),
            FutureBuilder(
              future: futurePlatforms,
              builder: (context, snapshot) {
                if (snapshot.hasData &&
                    snapshot.connectionState != ConnectionState.waiting) {
                  final platforms = (snapshot.data as List<Platform>);
                  return DropdownButton(
                    isExpanded: true,
                    value: _platformSelected != ''
                        ? _platformSelected
                        : '${platforms.first.id}',
                    elevation: 16,
                    onChanged: (Object? newValue) {
                      setState(() {
                        _platformSelected = newValue.toString();
                      });
                    },
                    items: platforms
                        .map(
                          (platform) => DropdownMenuItem(
                            child: Text(
                                platform.name ?? platform.abbreviation ?? ''),
                            value: '${platform.id}',
                          ),
                        )
                        .toList(),
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
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(
                Filters(
                  name: _nameController.text,
                  fromDate: _fromDateController.text,
                  toDate: _toDateController.text,
                  platform: _platformSelected,
                ),
              ),
              child: Text('Apply'),
            ),
            TextButton(
              onPressed: () => _resetFilters(),
              child: Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }

  void _selectDate(
    BuildContext context,
    TextEditingController controller,
    String label,
  ) async {
    final DateTime date = await showDatePicker(
          context: context,
          helpText: label,
          initialDate: DateTime.now(),
          firstDate: DateTime(1960),
          lastDate: DateTime(2030),
        ) ??
        DateTime.parse(controller.text);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    controller.text = formatter.format(date);
  }

  Future<List<Platform>> _fetchPlatforms() async {
    final url = '${env['API_URL']}/public/platforms';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<Platform> platforms = [];
      var results = jsonDecode(response.body)['platforms'];

      for (var result in results) {
        platforms.add(Platform.fromJson(result));
      }
      return platforms;
    } else {
      throw Exception('Failed to load platforms');
    }
  }

  void _resetFilters() {
    _nameController.clear();
    _fromDateController.text =
        _formatter.format(DateTime.now().subtract(Duration(days: 365)));
    _toDateController.text = _formatter.format(DateTime.now());
    setState(() {
      _platformSelected = '';
    });
  }
}
