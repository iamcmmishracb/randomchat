import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF00D4C8);
  static const Color primaryDark = Color(0xFF00A89E);
  static const Color primaryLight = Color(0xFF4DFFE8);
  static const Color accent = Color(0xFFFF5C7A);
  static const Color accentOrange = Color(0xFFFF8C42);

  // Dark theme
  static const Color background = Color(0xFF0A0E1A);
  static const Color surface = Color(0xFF111827);
  static const Color surfaceCard = Color(0xFF1A2235);
  static const Color surfaceElevated = Color(0xFF1E2A40);
  static const Color bubbleSent = Color(0xFF00C4B4);
  static const Color bubbleReceived = Color(0xFF1E2A40);
  static const Color textPrimary = Color(0xFFEBF4FF);
  static const Color textSecondary = Color(0xFF8FA3C0);
  static const Color textMuted = Color(0xFF4A6080);
  static const Color border = Color(0xFF1E2D45);
  static const Color divider = Color(0xFF162030);

  // Light theme
  static const Color lightBackground = Color(0xFFF0F4F8);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceCard = Color(0xFFFFFFFF);
  static const Color lightSurfaceElevated = Color(0xFFF5F8FA);
  static const Color lightBubbleSent = Color(0xFF00C4B4);
  static const Color lightBubbleReceived = Color(0xFFEFF2F7);
  static const Color lightTextPrimary = Color(0xFF0D1525);
  static const Color lightTextSecondary = Color(0xFF4A6080);
  static const Color lightTextMuted = Color(0xFF8FA3C0);
  static const Color lightBorder = Color(0xFFDDE3EE);
  static const Color lightDivider = Color(0xFFEAEFF7);

  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color online = Color(0xFF22C55E);
  static const Color male = Color(0xFF3B82F6);
  static const Color female = Color(0xFFEC4899);
  static const Color other = Color(0xFF8B5CF6);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00D4C8), Color(0xFF0080FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFF0A0E1A), Color(0xFF0D1525)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient lightBackgroundGradient = LinearGradient(
    colors: [Color(0xFFF0F4F8), Color(0xFFE8EFF8)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF5C7A), Color(0xFFFF8C42)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static TextTheme _buildTextTheme(TextTheme base, Color primaryText, Color secondaryText, Color mutedText) {
    return GoogleFonts.dmSansTextTheme(base).copyWith(
      displayLarge: GoogleFonts.spaceGrotesk(fontSize: 42, fontWeight: FontWeight.w700, color: primaryText, letterSpacing: -1.5),
      displayMedium: GoogleFonts.spaceGrotesk(fontSize: 32, fontWeight: FontWeight.w700, color: primaryText, letterSpacing: -1.0),
      headlineLarge: GoogleFonts.spaceGrotesk(fontSize: 26, fontWeight: FontWeight.w700, color: primaryText, letterSpacing: -0.5),
      headlineMedium: GoogleFonts.spaceGrotesk(fontSize: 22, fontWeight: FontWeight.w600, color: primaryText),
      headlineSmall: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w600, color: primaryText),
      titleLarge: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w600, color: primaryText),
      titleMedium: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w500, color: primaryText),
      bodyLarge: GoogleFonts.dmSans(fontSize: 16, fontWeight: FontWeight.w400, color: primaryText, height: 1.6),
      bodyMedium: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w400, color: secondaryText, height: 1.5),
      bodySmall: GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w400, color: mutedText),
      labelLarge: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600, color: primaryText, letterSpacing: 0.3),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary, secondary: AppColors.accent,
        surface: AppColors.surface, background: AppColors.background,
        onPrimary: Color(0xFF001A18), onSecondary: Colors.white,
        onSurface: AppColors.textPrimary, onBackground: AppColors.textPrimary,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _buildTextTheme(base.textTheme, AppColors.textPrimary, AppColors.textSecondary, AppColors.textMuted),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface, foregroundColor: AppColors.textPrimary, elevation: 0, centerTitle: true,
        titleTextStyle: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(color: AppColors.surfaceCard, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.border))),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: AppColors.surfaceElevated,
        hintStyle: GoogleFonts.dmSans(color: AppColors.textMuted, fontSize: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.border)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary, foregroundColor: const Color(0xFF001A18), elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600),
      )),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      )),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: AppColors.primary)),
      dividerTheme: const DividerThemeData(color: AppColors.divider, thickness: 1),
      iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 22),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceElevated,
        contentTextStyle: GoogleFonts.dmSans(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((s) => s.contains(MaterialState.selected) ? AppColors.primary : Colors.grey),
        trackColor: MaterialStateProperty.resolveWith((s) => s.contains(MaterialState.selected) ? AppColors.primary.withOpacity(0.4) : Colors.grey.withOpacity(0.3)),
      ),
    );
  }

  static ThemeData get lightTheme {
    final base = ThemeData.light();
    return base.copyWith(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary, secondary: AppColors.accent,
        surface: AppColors.lightSurface, background: AppColors.lightBackground,
        onPrimary: Color(0xFF001A18), onSecondary: Colors.white,
        onSurface: AppColors.lightTextPrimary, onBackground: AppColors.lightTextPrimary,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.lightBackground,
      textTheme: _buildTextTheme(base.textTheme, AppColors.lightTextPrimary, AppColors.lightTextSecondary, AppColors.lightTextMuted),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightSurface, foregroundColor: AppColors.lightTextPrimary, elevation: 0, centerTitle: true,
        titleTextStyle: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.lightTextPrimary),
        systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
        iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
      ),
      cardTheme: CardThemeData(color: AppColors.lightSurfaceCard, elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: AppColors.lightBorder))),
      inputDecorationTheme: InputDecorationTheme(
        filled: true, fillColor: AppColors.lightSurfaceElevated,
        hintStyle: GoogleFonts.dmSans(color: AppColors.lightTextMuted, fontSize: 15),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.lightBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 2)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.error)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary, foregroundColor: const Color(0xFF001A18), elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w600),
      )),
      outlinedButtonTheme: OutlinedButtonThemeData(style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary, side: const BorderSide(color: AppColors.primary, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      )),
      textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: AppColors.primary)),
      dividerTheme: const DividerThemeData(color: AppColors.lightDivider, thickness: 1),
      iconTheme: const IconThemeData(color: AppColors.lightTextSecondary, size: 22),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightSurfaceCard,
        contentTextStyle: GoogleFonts.dmSans(color: AppColors.lightTextPrimary),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        behavior: SnackBarBehavior.floating,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((s) => s.contains(MaterialState.selected) ? AppColors.primary : Colors.grey),
        trackColor: MaterialStateProperty.resolveWith((s) => s.contains(MaterialState.selected) ? AppColors.primary.withOpacity(0.4) : Colors.grey.withOpacity(0.3)),
      ),
    );
  }
}
