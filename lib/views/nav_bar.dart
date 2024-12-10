import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'search_view.dart';
import 'job_search_view.dart';
import 'settings_page_view.dart';
import '../views/search_view.dart';
import '../views/settings_page_view.dart';
import '../models/settings_page_model.dart';
import '../presenters/settings_page_presenter.dart';
import '../presenters/theme_presenter.dart';
import '../presenters/search_presenter.dart';
import '../presenters/job_search_presenter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_page_view.dart';
import 'package:northstars_final/views/alerts_page_container_view.dart';
import '../views/sound_view.dart'; // Import the music page
import 'package:northstars_final/views/goal_page_view.dart';
import 'package:northstars_final/presenters/goal_page_presenter.dart';
import 'package:northstars_final/models/goal_page_model.dart';

class NavBar extends StatefulWidget {
  final ThemePresenter themePresenter;
  final SearchPresenter searchPresenter;
  final JobSearchPresenter jobSearchPresenter;
  final GoalPagePresenter goalPagePresenter;

  const NavBar({
    super.key,
    required this.themePresenter,
    required this.searchPresenter,
    required this.jobSearchPresenter,
    required this.goalPagePresenter,
  });

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  bool _isSearchView = true; // Toggle between SearchView and JobSearchView
  late final SettingsPagePresenter _settingsPagePresenter;
  late final GoalPagePresenter _goalPagePresenter;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // Initialize SettingsPagePresenter
    _settingsPagePresenter = SettingsPagePresenter(SettingsPageModel());
    _goalPagePresenter = GoalPagePresenter(GoalPageModel(), (data) => print(data));

    // Initialize pages
    _pages = [
      _buildSearchTab(),
      GoalPageView(_goalPagePresenter), //Center(child: Text('Business Page', style: TextStyle(fontSize: 24))),
      AlertsPageContainer(),
      MP3PlayerApp(), // Link the music page here
      SettingsPageView(presenter: _settingsPagePresenter),
    ];
  }

  Widget _buildSearchTab() {
    return _isSearchView
        ? SearchView(
      searchPresenter: widget.searchPresenter,
      jobSearchPresenter: widget.jobSearchPresenter,
      onNavigate: (index) {
        setState(() {
          _isSearchView = false; // Switch to JobSearchView
        });
      },
    )
        : JobSearchView(
      presenter: widget.jobSearchPresenter,
      onNavigate: (index) {
        setState(() {
          _isSearchView = true; // Switch back to SearchView
        });
      },
    );
  }

  void _onNavigate(int index) {
    setState(() {
      _selectedIndex = index; // Update selected tab index
    });
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0 ? _buildSearchTab() : _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: GNav(
          rippleColor: Colors.grey[300]!,
          hoverColor: Colors.grey[100]!,
          haptic: true,
          tabBorderRadius: 15,
          tabActiveBorder: Border.all(color: Colors.black, width: 1),
          tabShadow: [
            BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8),
          ],
          curve: Curves.easeOutExpo,
          duration: const Duration(milliseconds: 200),
          gap: 8,
          color: Colors.grey[800],
          activeColor: Colors.blue,
          iconSize: 24,
          tabBackgroundColor: Colors.blue.withOpacity(0.1),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          selectedIndex: _selectedIndex,
          onTabChange: _onNavigate,
          tabs: const [
            GButton(icon: LineIcons.search), // Search Tab
            GButton(icon: LineIcons.check), // Goals Tab
            GButton(icon: LineIcons.clock), // Alerts Tab
            GButton(icon: LineIcons.music), // Music Tab
            GButton(icon: LineIcons.user), // Profile/Settings Tab
          ],
        ),
      ),
    );
  }
}
