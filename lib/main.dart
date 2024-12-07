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
import 'models/job_repository_model.dart';
import 'presenters/job_search_presenter.dart';
import 'views/job_search_view.dart';

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
  late final JobRepository _jobRepository;
  late final JobSearchPresenter _jobSearchPresenter;

  @override
  void initState() {
    super.initState();
    _themePresenter = ThemePresenter(_themeModel);

    // Initialize search presenter
    _searchPresenter = SearchPresenter(_searchModel);

    // Initialize job search presenter
    _jobRepository = JobRepository();
    _jobSearchPresenter = JobSearchPresenter(_jobRepository, _searchPresenter);

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
                searchPresenter: _searchPresenter,
                jobSearchPresenter: _jobSearchPresenter,
              ),
              '/jobSearch': (context) => JobSearchView(
                presenter: _jobSearchPresenter,
                onNavigate: (index) {
                  Navigator.pushReplacementNamed(context, '/home'); // Navigate to NavBar with selected index
                },
              ),
              '/search': (context) => SearchView(
                searchPresenter: _searchPresenter,
                jobSearchPresenter: _jobSearchPresenter,
                onNavigate: (index) {
                  Navigator.pushReplacementNamed(context, '/home'); // Navigate to NavBar with selected index
                },
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
