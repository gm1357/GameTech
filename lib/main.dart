import 'package:flutter/material.dart';
import 'package:gametech/screens/filter_screen.dart';
import 'package:gametech/screens/list_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      routes: {
        '/': (context) => ListScreen(),
        ListScreen.routeName: (context) => ListScreen(),
        FilterScreen.routeName: (context) => FilterScreen()
      },
    );
  }
}