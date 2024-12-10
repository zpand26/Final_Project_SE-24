import 'package:flutter/material.dart';
import 'package:northstars_final/models/software_job_model.dart';
import 'package:northstars_final/presenters/search_presenter.dart';
import 'package:northstars_final/views/nav_bar.dart';
import 'package:northstars_final/presenters/auth_page_presenter.dart';
import 'package:northstars_final/presenters/theme_presenter.dart';
import 'package:northstars_final/models/theme_model.dart';
import 'package:northstars_final/models/data_job_repository_model.dart'; // Add this import
import 'package:northstars_final/presenters/job_search_presenter.dart'; // Add this import
import 'package:northstars_final/models/software_job_repository_model.dart'; // Add this import
import 'package:northstars_final/views/goal_page_view.dart';
import 'package:northstars_final/presenters/goal_page_presenter.dart';
import 'package:northstars_final/models/goal_page_model.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> implements AuthViewContract {
  late AuthPresenter _presenter;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;

  @override
  void initState() {
    super.initState();
    _presenter = AuthPresenter(this);
  }

  void _authenticate() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (_isLogin) {
      _presenter.login(email, password);
    } else {
      _presenter.signUp(email, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/images/guiding_hand_logo.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Welcome to Guiding Hand',
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white70),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    obscureText: true,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _authenticate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      _isLogin ? 'Login' : 'Sign Up',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      _presenter.googleSignIn();
                    },
                    icon: Image.asset(
                      'lib/assets/images/google_logo.jpg',
                      height: 24,
                      width: 24,
                    ),
                    label: const Text("Sign in with Google"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin ? 'Create an account' : 'Have an account? Log in',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void navigateToHome() {
    final themeModel = ThemeModel();
    final searchRepository = SearchRepositoryModel();
    final themePresenter = ThemePresenter(themeModel);
    final searchPresenter = SearchPresenter(searchRepository);
    final jobRepository = JobRepository(); // Add this
    final jobSearchPresenter = JobSearchPresenter(jobRepository,searchPresenter); // Add this
    final goalPagePresenter = GoalPagePresenter(GoalPageModel(), (data) => print(data));

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => NavBar(
          themePresenter: themePresenter,
          searchPresenter: searchPresenter,
          jobSearchPresenter: jobSearchPresenter,
          goalPagePresenter: goalPagePresenter,// Pass the new parameter
        ),
      ),
    );
  }
}
