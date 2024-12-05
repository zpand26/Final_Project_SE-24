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
            const Divider(), // Adds a divider for clarity
            ListTile(
              title: const Text('Credits'),
              onTap: () {
                // You can show a dialog or navigate to a new screen for credits
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Data Sources & Credits'),
                      content: const Text(
                        'This app uses the following data sets:\n\n'
                            '1. Software Engineer Jobs & Salaries 2024 by Emre Öksüz, on Kaggle\n'
                            '\n'
                            '2. Jobs and Salaries in Data Science by Hummaam Qaasim on Kaggle\n'
                            '\n'
                            '\n'
                            'Thank you to all the contributors!',
                        style: TextStyle(fontSize: 14),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
      body: const SizedBox.shrink(), // Empty content for now
    );
  }
}
