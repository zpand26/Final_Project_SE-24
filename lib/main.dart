import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:firebase_core/firebase_core.dart';
import 'package:permission_handler/permission_handler.dart';
import 'views/auth_page_view.dart';
import 'views/nav_bar.dart';
import 'views/alerts_page_container_view.dart';
import 'models/search_model.dart';
import 'presenters/search_presenter.dart';
import 'views/search_view.dart';
import 'models/theme_model.dart';
import 'presenters/theme_presenter.dart';
import 'views/nav_bar.dart';
import 'models/job_repository_model.dart';
import 'presenters/job_search_presenter.dart';
import 'views/job_search_view.dart';
import 'models/settings_page_model.dart';
import 'presenters/settings_page_presenter.dart';
import 'views/settings_page_view.dart';
import 'package:provider/provider.dart';
import 'package:northstars_final/models/search_repository_model.dart'; // Add this import
import 'package:northstars_final/views/goal_page_view.dart';
import 'package:northstars_final/presenters/goal_page_presenter.dart';
import 'package:northstars_final/models/goal_page_model.dart';


// Initialize the notifications plugin globally
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// Request notification permissions
Future<void> requestNotificationPermissions() async {
  final androidPlugin = flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Initialize timezone data
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('America/Chicago')); // Set your local timezone

  // Request notification permissions
  await requestNotificationPermissions();

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
  final ThemeModel _themeModel = ThemeModel();
  final searchRepository = SearchRepositoryModel();
  late final GoalPageModel goalPageModel;
  late final ThemePresenter _themePresenter;
  late final SearchPresenter _searchPresenter;
  late final JobRepository _jobRepository;
  late final JobSearchPresenter _jobSearchPresenter;

  @override
  void initState() {
    super.initState();

    // Initialize presenters
    _themePresenter = ThemePresenter(_themeModel);
    _searchPresenter = SearchPresenter(searchRepository);
    _jobRepository = JobRepository();
    _jobSearchPresenter = JobSearchPresenter(_jobRepository, _searchPresenter);
    // (data) => print(data));

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
            title: 'Job App',
            theme: ThemeData.light().copyWith(primaryColor: Colors.blue), // Light theme
            darkTheme: ThemeData.dark(), // Dark theme
            themeMode: themeModel.isDarkMode ? ThemeMode.dark : ThemeMode.light, // Use ThemeModel's themeMode
            home: const AuthPage(), // Start with AuthPage
            routes: {
              '/home': (context) => NavBar(
                themePresenter: _themePresenter,
                searchPresenter: _searchPresenter,
                jobSearchPresenter: _jobSearchPresenter,
              ),
              '/alerts': (context) => AlertsPageContainer(), // Add AlertsPage route
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
