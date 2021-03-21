import 'package:flutter/material.dart';
import 'package:gametech/models/detailsArguments.dart';
import 'package:gametech/models/filters.dart';
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
    ListScreen.routeName: (context) => ListScreen()
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
          final DetailsArguments? arguments = settings.arguments as DetailsArguments?;
          return MaterialPageRoute(
            builder: (context) {
              return DetailsScreen(arguments?.game, arguments?.tabIndex ?? 0);
            },
          );
        } else if (settings.name == FilterScreen.routeName) {
          final Filters? filters = settings.arguments as Filters;
          return MaterialPageRoute(
            builder: (context) {
              return FilterScreen(filters);
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
