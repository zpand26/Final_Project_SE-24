import 'package:flutter/material.dart';
import '../presenters/theme_presenter.dart';

class SettingsPageView extends StatelessWidget {
  final ThemePresenter themePresenter;

  const SettingsPageView({super.key, required this.themePresenter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Appearance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dark Mode', style: TextStyle(fontSize: 16)),
                Switch(
                  value: themePresenter.isDarkMode,
                  onChanged: (isDark) {
                    themePresenter.toggleTheme(isDark);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
