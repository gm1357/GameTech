import 'package:flutter/material.dart';
import 'package:gametech/models/gameSummary.dart';
import 'package:gametech/screens/details_screen.dart';
import 'package:gametech/screens/filter_screen.dart';
import 'package:gametech/screens/list_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

Future main() async {
  await DotEnv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = {
    '/': (context) => ListScreen(),
    ListScreen.routeName: (context) => ListScreen(),
    FilterScreen.routeName: (context) => FilterScreen()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.red,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == DetailsScreen.routeName) {
          final GameSummary? gameSummary = settings.arguments as GameSummary?;
          return MaterialPageRoute(
            builder: (context) {
              return DetailsScreen(gameSummary);
            },
          );
        } else {
          final Route route = MaterialPageRoute(
              settings: settings,
              builder: (context) => routes[settings.name!]!(context));
          return route;
        }
      },
    );
  }
}
