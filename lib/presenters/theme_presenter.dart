import '../models/theme_model.dart';

class ThemePresenter {
  final ThemeModel _themeModel;

  ThemePresenter(this._themeModel);

  bool get isDarkMode => _themeModel.isDarkMode;

  Future<void> toggleTheme() async {
    await _themeModel.toggleTheme(); // No argument needed
  }

  Future<void> loadThemePreference() async {
    await _themeModel.loadThemePreference();
  }
}
