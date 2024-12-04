import 'package:flutter/material.dart';
import 'models/search_model.dart';
import 'presenters/search_presenter.dart';
import 'views/search_view.dart';
import 'models/theme_model.dart';
import 'presenters/theme_presenter.dart';
import 'views/nav_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeModel _themeModel = ThemeModel();
  late final ThemePresenter _themePresenter;
  late final SearchPresenter _searchPresenter;

  @override
  void initState() {
    super.initState();

    // Initialize theme presenter
    _themePresenter = ThemePresenter(_themeModel);

    // Initialize search presenter
    final searchModel = SearchModel();
    _searchPresenter = SearchPresenter(searchModel);

    // Update UI on theme changes
    _themeModel.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(primaryColor: Colors.blue),
      darkTheme: ThemeData.dark(),
      themeMode: _themeModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: '/', // Define initial route
      routes: {
        '/': (context) => NavBar(
          themePresenter: _themePresenter,
          searchPresenter: _searchPresenter, // Pass searchPresenter
        ),
        '/search': (context) => SearchView(searchPresenter: _searchPresenter),
      },
    );
  }
}
