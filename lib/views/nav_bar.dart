import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'settings_page_view.dart';
import '../presenters/theme_presenter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:northstars_final/views/auth_page_view.dart';

class NavBar extends StatefulWidget {
  final ThemePresenter themePresenter;

  const NavBar({super.key, required this.themePresenter});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  List<Widget> _buildPages() {
    return [
      Center(child: Text('Search Page', style: TextStyle(fontSize: 24))),
      Center(child: Text('Business Page', style: TextStyle(fontSize: 24))),
      Center(child: Text('Alerts Page', style: TextStyle(fontSize: 24))),
      Center(child: Text('Music Page', style: TextStyle(fontSize: 24))),
      SettingsPageView(themePresenter: widget.themePresenter),
    ];
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
      body: Stack(
        children: [
        _buildPages()[_selectedIndex],
          // Optional Logout Button
          Positioned(
            top: 53,
            right: 40,
            child: FloatingActionButton.small(
              onPressed: _logout,
              backgroundColor: Colors.tealAccent,
              child: const Icon(Icons.logout),
            ),
          ),
        ],
      ),
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
              _selectedIndex = index;
            });
          },
          tabs: const [
            GButton(icon: LineIcons.search),
            GButton(icon: LineIcons.suitcase),
            GButton(icon: LineIcons.clock),
            GButton(icon: LineIcons.music),
            GButton(icon: LineIcons.user),
          ],
        ),
      ),
    );
  }
}
