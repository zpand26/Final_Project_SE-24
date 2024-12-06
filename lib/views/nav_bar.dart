import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:northstars_final/views/search_view.dart';
import 'settings_page_view.dart';
import '../presenters/theme_presenter.dart';
//import '../presenters/search_presenter.dart';
//import 'search_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_page_view.dart';
import '../presenters/search_presenter.dart';
import '../presenters/job_search_presenter.dart';


class NavBar extends StatefulWidget {
  final ThemePresenter themePresenter;
  // final SearchPresenter searchPresenter;
  final SearchPresenter searchPresenter;
  final JobSearchPresenter jobSearchPresenter;

  const NavBar({super.key, required this.themePresenter, required this.searchPresenter,required this.jobSearchPresenter, });

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  // Define the pages for each tab
  List<Widget> _buildPages() {
    return [
      SearchView(
        searchPresenter: widget.searchPresenter,
        jobSearchPresenter: widget.jobSearchPresenter,
      ),
      //Center(child: Text('Search Page', style: TextStyle(fontSize: 24))),
      Center(child: Text('Business Page', style: TextStyle(fontSize: 24))),
      Center(child: Text('Alerts Page', style: TextStyle(fontSize: 24))),
      Center(child: Text('Music Page', style: TextStyle(fontSize: 24))),
      SettingsPageView(themePresenter: widget.themePresenter),
    ];
  }

  // Logout function
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
      body: _buildPages()[_selectedIndex],
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
          onTabChange: (index) {
            setState(() {
              _selectedIndex = index; // Update the selected tab index
            });
          },
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
