import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../presenters/theme_presenter.dart';
import '../models/theme_model.dart';

class ThemeView extends StatelessWidget {
  final ThemePresenter presenter;

  const ThemeView({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    final themeModel = Provider.of<ThemeModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: themeModel.isDarkMode,
              onChanged: (isDark) async {
                // Toggle theme without passing an argument
                await presenter.toggleTheme();
              },
            ),
          ),
        ],
      ),
    );
  }
}
