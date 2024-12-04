import 'package:flutter/material.dart';
import '../presenters/theme_presenter.dart';

class SettingsPageView extends StatefulWidget {
  final ThemePresenter themePresenter;

  const SettingsPageView({super.key, required this.themePresenter});

  @override
  _SettingsPageViewState createState() => _SettingsPageViewState();
}

class _SettingsPageViewState extends State<SettingsPageView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
              _scaffoldKey.currentState?.openEndDrawer(); // Use the key to open the drawer
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
            ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: widget.themePresenter.isDarkMode,
                onChanged: (isDark) {
                  setState(() {
                    widget.themePresenter.toggleTheme(isDark); // Toggle the theme
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: const SizedBox.shrink(), // Empty content for now
    );
  }
}
