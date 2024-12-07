import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'search_view.dart';
import 'job_search_view.dart';
import 'settings_page_view.dart';
import '../presenters/theme_presenter.dart';
import '../presenters/search_presenter.dart';
import '../presenters/job_search_presenter.dart';
import 'auth_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NavBar extends StatefulWidget {
  final ThemePresenter themePresenter;
  final SearchPresenter searchPresenter;
  final JobSearchPresenter jobSearchPresenter;

  const NavBar({
    super.key,
    required this.themePresenter,
    required this.searchPresenter,
    required this.jobSearchPresenter,
  });

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  bool _isSearchView = true; // Toggle between SearchView and JobSearchView

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildSearchTab(), // Index 0: Search Tab
      Center(child: Text('Business Page', style: TextStyle(fontSize: 24))), // Index 1
      Center(child: Text('Alerts Page', style: TextStyle(fontSize: 24))), // Index 2
      Center(child: Text('Music Page', style: TextStyle(fontSize: 24))), // Index 3
      SettingsPageView(themePresenter: widget.themePresenter), // Index 4
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
          tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)],
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
            GButton(icon: LineIcons.suitcase), // Business Tab
            GButton(icon: LineIcons.clock), // Alerts Tab
            GButton(icon: LineIcons.music), // Music Tab
            GButton(icon: LineIcons.user), // Profile/Settings Tab
          ],
        ),
      ),
    );
  }
}
