import 'package:flutter/material.dart';
import 'package:gametech/models/filters.dart';
import 'package:intl/intl.dart';

class FilterScreen extends StatelessWidget {
  static const routeName = '/filters';

  final _nameController = new TextEditingController();
  final _fromDateController = new TextEditingController();
  final _toDateController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Filters filters = ModalRoute.of(context)!.settings.arguments as Filters;
    _nameController.text = filters.name;
    _fromDateController.text = filters.fromDate;
    _toDateController.text = filters.toDate;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Filters'),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
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
            Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(Filters(
                name: _nameController.text,
                fromDate: _fromDateController.text,
                toDate: _toDateController.text,
              )),
              child: Text('Apply'),
            ),
            TextButton(
              onPressed: () => _nameController.clear(),
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
    final DateTime date = await (showDatePicker(
      context: context,
      helpText: label,
      initialDate: DateTime.now(),
      firstDate: DateTime(1960),
      lastDate: DateTime(2030),
    )) ?? DateTime.parse(controller.text);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    controller.text = formatter.format(date);
  }
}
