import 'package:flutter/material.dart';
import 'models/theme_model.dart';
import 'presenters/theme_presenter.dart';
import 'models/se_compare_model.dart';
import 'presenters/se_compare_presenter.dart';
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
  final SECompareModel _seCompareModel = SECompareModel();
  late final SEComparePresenter _seComparePresenter;

  @override
  void initState() {
    super.initState();
    _themePresenter = ThemePresenter(_themeModel);
    _themeModel.addListener(() {
      setState(() {});
    });
    _seComparePresenter = SEComparePresenter(_seCompareModel, (data) => print(data));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(primaryColor: Colors.blue,),
      darkTheme: ThemeData.dark().copyWith(),
      themeMode: _themeModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: NavBar(themePresenter: _themePresenter,
      seComparePresenter: _seComparePresenter,),
    );
  }
}
