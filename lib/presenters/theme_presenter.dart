import '../models/theme_model.dart';

class ThemePresenter {
  final ThemeModel _themeModel;

  ThemePresenter(this._themeModel);

  bool get isDarkMode => _themeModel.isDarkMode;

  void toggleTheme(bool isDark) {
    _themeModel.toggleTheme(isDark);
  }
}
