import 'package:flutter/material.dart';
import 'package:northstars_final/models/search_model.dart';
import 'views/auth_page_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'models/search_model.dart';
import 'presenters/search_presenter.dart';
import 'views/search_view.dart';
import 'models/theme_model.dart';
import 'presenters/theme_presenter.dart';
import 'views/nav_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeModel _themeModel = ThemeModel();
  final SearchModel _searchModel = SearchModel();
  late final ThemePresenter _themePresenter;
  late final SearchPresenter _searchPresenter;

  @override
  void initState() {
    super.initState();
    _themePresenter = ThemePresenter(_themeModel);

    // Initialize search presenter
    final searchModel = SearchModel();
    _searchPresenter = SearchPresenter(searchModel);

    // Update UI on theme changes
    _themeModel.addListener(() {
      setState(() {}); // Rebuild the MaterialApp when the theme changes
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          // Show an error screen if Firebase initialization fails
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: Text("Couldn't connect to Firebase")),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          // Once Firebase is initialized, show the app with the theme
          return MaterialApp(
            theme: ThemeData.light().copyWith(primaryColor: Colors.blue), // Light theme
            darkTheme: ThemeData.dark(), // Dark theme
            themeMode: _themeModel.isDarkMode ? ThemeMode.dark : ThemeMode.light, // ThemeMode from ThemeModel
            home: AuthPage(), // Start with AuthPage
            routes: {
              '/home': (context) => NavBar(
                themePresenter: _themePresenter,
                searchPresenter: _searchPresenter, // Pass ThemePresenter and SearchPresenter to NavBar
              ),
            },
          );
        }

        // Show a loading indicator while Firebase initializes
        return const MaterialApp(
          home: Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}
