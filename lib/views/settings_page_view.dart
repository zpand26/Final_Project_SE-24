import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../presenters/theme_presenter.dart';
import 'auth_page_view.dart';

class SettingsPageView extends StatefulWidget {
  final ThemePresenter themePresenter;

  const SettingsPageView({super.key, required this.themePresenter});

  @override
  _SettingsPageViewState createState() => _SettingsPageViewState();
}

class _SettingsPageViewState extends State<SettingsPageView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      key: _scaffoldKey, // Assign the key to the Scaffold
      appBar: AppBar(
        title: const Text('Settings Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, size: 30),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer(); // Open the drawer
            },
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: const Text(
                'Appearance Settings',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            // Dark mode switch
            ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: widget.themePresenter.isDarkMode,
                onChanged: (isDark) {
                  widget.themePresenter.toggleTheme(isDark); // Update theme
                  setState(() {}); // Rebuild for immediate effect
                },
              ),
            ),
            // Logout button

            const SizedBox(height:20), //vertical space

            ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout, color: Colors.red),
              onTap: _logout, // Call logout function
            ),
          ],
        ),
      ),
      body: const SizedBox.shrink(), // Empty content
    );
  }
}
