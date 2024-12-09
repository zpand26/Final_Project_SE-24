import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Add provider for theme management
import 'package:firebase_core/firebase_core.dart';
import 'models/search_model.dart';
import 'views/auth_page_view.dart';
import 'models/theme_model.dart';
import 'presenters/theme_presenter.dart';
import 'views/nav_bar.dart';
import 'presenters/search_presenter.dart';
import 'views/search_view.dart';
import 'models/job_repository_model.dart';
import 'presenters/job_search_presenter.dart';
import 'views/job_search_view.dart';
import 'models/settings_page_model.dart';
import 'presenters/settings_page_presenter.dart';
import 'views/settings_page_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeModel()..loadThemePreference(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeModel _themeModel = ThemeModel(); // Retain existing ThemeModel instance
  final SearchModel _searchModel = SearchModel();
  late final ThemePresenter _themePresenter;
  late final SearchPresenter _searchPresenter;
  late final JobRepository _jobRepository;
  late final JobSearchPresenter _jobSearchPresenter;

  @override
  void initState() {
    super.initState();

    // Initialize presenters
    _themePresenter = ThemePresenter(_themeModel);
    _searchPresenter = SearchPresenter(_searchModel);
    _jobRepository = JobRepository();
    _jobSearchPresenter = JobSearchPresenter(_jobRepository);

    // Update UI on theme changes
    _themeModel.addListener(() {
      setState(() {}); // Rebuild the MaterialApp when the theme changes
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

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
            themeMode: themeModel.isDarkMode ? ThemeMode.dark : ThemeMode.light, // ThemeMode from ThemeModel
            home: AuthPage(), // Start with AuthPage
            routes: {
              '/home': (context) => NavBar(
                themePresenter: _themePresenter,
                searchPresenter: _searchPresenter,
                jobSearchPresenter: _jobSearchPresenter,
              ),
              '/jobSearch': (context) => JobSearchView(presenter: _jobSearchPresenter),
              '/search': (context) => SearchView(
                searchPresenter: _searchPresenter,
                jobSearchPresenter: _jobSearchPresenter,
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
