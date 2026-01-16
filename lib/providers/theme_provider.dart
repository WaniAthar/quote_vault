import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

enum AppTheme { orange, nature, ocean, minimal }

class ThemeProvider with ChangeNotifier {
  static const String _themeModeKey = 'theme_mode';
  static const String _fontSizeKey = 'font_size';
  static const String _selectedThemeKey = 'selected_theme';

  ThemeMode _themeMode = ThemeMode.system;
  double _fontSize = 16.0;
  AppTheme _selectedTheme = AppTheme.orange;

  ThemeMode get themeMode => _themeMode;
  double get fontSize => _fontSize;
  AppTheme get selectedTheme => _selectedTheme;

  bool get isDarkMode => _themeMode == ThemeMode.dark;
  bool get isLightMode => _themeMode == ThemeMode.light;

  ThemeProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt(_themeModeKey) ?? 0;
    _themeMode = ThemeMode.values[themeModeIndex];
    _fontSize = prefs.getDouble(_fontSizeKey) ?? 16.0;
    final themeIndex = prefs.getInt(_selectedThemeKey) ?? 0;
    if (themeIndex < AppTheme.values.length) {
      _selectedTheme = AppTheme.values[themeIndex];
    } else {
      _selectedTheme = AppTheme.orange;
    }
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
  }

  Future<void> setSelectedTheme(AppTheme theme) async {
    _selectedTheme = theme;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_selectedThemeKey, theme.index);
  }

  Future<void> setFontSize(double size) async {
    _fontSize = size;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, size);
  }

  Color get _primaryColor {
    switch (_selectedTheme) {
      case AppTheme.orange:
        return const Color(0xFFFF6B35);
      case AppTheme.nature:
        return const Color(0xFF2D6A4F);
      case AppTheme.ocean:
        return const Color(0xFF0077B6);
      case AppTheme.minimal:
        return const Color(0xFF1A1A1A);
    }
  }

  Color get _secondaryColor {
    switch (_selectedTheme) {
      case AppTheme.orange:
        return const Color(0xFFFF8F65);
      case AppTheme.nature:
        return const Color(0xFF52B788);
      case AppTheme.ocean:
        return const Color(0xFF00B4D8);
      case AppTheme.minimal:
        return const Color(0xFF757575);
    }
  }

  TextTheme _buildTextTheme(Color textColor) {
    final baseTextTheme = GoogleFonts.interTextTheme();
    return baseTextTheme.copyWith(
      displayLarge: baseTextTheme.displayLarge?.copyWith(
        fontSize: _fontSize + 40,
        fontWeight: FontWeight.w800,
        color: textColor,
        letterSpacing: -1.5,
      ),
      displayMedium: baseTextTheme.displayMedium?.copyWith(
        fontSize: _fontSize + 30,
        fontWeight: FontWeight.w800,
        color: textColor,
        letterSpacing: -0.5,
      ),
      displaySmall: baseTextTheme.displaySmall?.copyWith(
        fontSize: _fontSize + 20,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),
      headlineLarge: baseTextTheme.headlineLarge?.copyWith(
        fontSize: _fontSize + 16,
        fontWeight: FontWeight.w700,
        color: textColor,
        letterSpacing: -0.5,
      ),
      headlineMedium: baseTextTheme.headlineMedium?.copyWith(
        fontSize: _fontSize + 8,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      headlineSmall: baseTextTheme.headlineSmall?.copyWith(
        fontSize: _fontSize + 4,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: baseTextTheme.titleLarge?.copyWith(
        fontSize: _fontSize + 2,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleMedium: baseTextTheme.titleMedium?.copyWith(
        fontSize: _fontSize,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyLarge: baseTextTheme.bodyLarge?.copyWith(
        fontSize: _fontSize,
        fontWeight: FontWeight.w400,
        color: textColor,
        height: 1.5,
      ),
      bodyMedium: baseTextTheme.bodyMedium?.copyWith(
        fontSize: _fontSize - 2,
        fontWeight: FontWeight.w400,
        color: textColor.withOpacity(0.8),
        height: 1.5,
      ),
      labelLarge: baseTextTheme.labelLarge?.copyWith(
        fontSize: _fontSize - 2,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0.5,
      ),
    );
  }

  ThemeData get lightTheme {
    final primary = _primaryColor;
    final secondary = _secondaryColor;
    final colorScheme = ColorScheme.light(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: primary.withOpacity(0.1),
      onPrimaryContainer: primary,
      secondary: secondary,
      onSecondary: Colors.white,
      secondaryContainer: secondary.withOpacity(0.1),
      onSecondaryContainer: secondary,
      surface: const Color(0xFFFAFAFA),
      onSurface: const Color(0xFF1A1A1A),
      outline: const Color(0xFFE0E0E0),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      textTheme: _buildTextTheme(const Color(0xFF1A1A1A)),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  ThemeData get darkTheme {
    final primary = _selectedTheme == AppTheme.minimal
        ? Colors.white
        : _primaryColor;
    final secondary = _selectedTheme == AppTheme.minimal
        ? const Color(0xFFE0E0E0)
        : _secondaryColor;

    final colorScheme = ColorScheme.dark(
      primary: primary,
      onPrimary: _selectedTheme == AppTheme.minimal
          ? Colors.black
          : Colors.black,
      primaryContainer: primary.withOpacity(0.2),
      onPrimaryContainer: primary,
      secondary: secondary,
      onSecondary: Colors.black,
      secondaryContainer: secondary.withOpacity(0.2),
      onSecondaryContainer: secondary,
      surface: const Color(0xFF121212),
      onSurface: const Color(0xFFF5F5F5),
      outline: const Color(0xFF333333),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF000000),
      textTheme: _buildTextTheme(const Color(0xFFF5F5F5)),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1C1C1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
