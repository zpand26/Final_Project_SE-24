import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import '../presenters/theme_presenter.dart';
import '../views/theme_view.dart';

class NavBar extends StatefulWidget {
  final ThemePresenter themePresenter;

  const NavBar({super.key, required this.themePresenter});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('')),
    Center(child: Text('')),
    Center(child: Text('')),
    Center(child: Text('')),
    Center(child: Text('')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 4 // Navigate to ThemeView for Profile tab
          ? ThemeView(themePresenter: widget.themePresenter)
          : _pages[_selectedIndex],
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
            GButton(icon: LineIcons.search, text: ''),
            GButton(icon: LineIcons.suitcase, text: ''),
            GButton(icon: LineIcons.clock, text: ''),
            GButton(icon: LineIcons.music, text: ''),
            GButton(icon: LineIcons.user, text: ''),
          ],
        ),
      ),
    );
  }
}
