import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _themePresenter = ThemePresenter(_themeModel);
    _themeModel.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(primaryColor: Colors.blue,),
      darkTheme: ThemeData.dark().copyWith(),
      themeMode: _themeModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: NavBar(themePresenter: _themePresenter),
    );
  }
}
