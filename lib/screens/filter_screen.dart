import 'package:flutter/material.dart';
import 'package:gametech/models/filters.dart';

class FilterScreen extends StatelessWidget {
  static const routeName = '/filters';

  final _nameController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Filters filters = ModalRoute.of(context).settings.arguments;
    _nameController.text = filters.name;
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              controller: _nameController,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pop(Filters(name: _nameController.text)),
        child: Icon(Icons.filter_list),
      ),
    );
  }
}
