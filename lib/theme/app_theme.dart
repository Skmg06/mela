import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the social commerce application.
class AppTheme {
  AppTheme._();

  // Color Specifications based on Warm Neutral Foundation
  static const Color primaryLight = Color(0xFFF8F6F3); // Warm white base
  static const Color secondaryLight = Color(0xFFE8E2DB); // Soft beige
  static const Color accentLight = Color(0xFF2D2A26); // Deep charcoal
  static const Color successLight = Color(0xFF4A7C59); // Muted forest green
  static const Color warningLight = Color(0xFFB8860B); // Sophisticated gold
  static const Color errorLight = Color(0xFFA0522D); // Warm sienna
  static const Color infoLight = Color(0xFF5F7A8A); // Soft blue-gray
  static const Color surfaceLight = Color(0xFFFEFDFB); // Pure warm white
  static const Color borderLight = Color(0xFFD4CFC7); // Subtle warm gray
  static const Color overlayLight =
      Color(0x802D2A26); // Semi-transparent charcoal

  // Dark theme variations maintaining warm undertones
  static const Color primaryDark =
      Color(0xFF2D2A26); // Deep charcoal as primary
  static const Color secondaryDark = Color(0xFF3A3530); // Darker warm gray
  static const Color accentDark = Color(0xFFF8F6F3); // Warm white for text
  static const Color successDark = Color(0xFF5A8C69); // Brighter forest green
  static const Color warningDark = Color(0xFFC8960B); // Brighter gold
  static const Color errorDark = Color(0xFFB0623D); // Brighter sienna
  static const Color infoDark = Color(0xFF6F8A9A); // Brighter blue-gray
  static const Color surfaceDark = Color(0xFF1A1816); // Dark warm surface
  static const Color borderDark = Color(0xFF3A3530); // Dark warm border
  static const Color overlayDark =
      Color(0x80F8F6F3); // Semi-transparent warm white

  // Text colors with proper emphasis levels
  static const Color textHighEmphasisLight = Color(0xFF2D2A26); // 100% opacity
  static const Color textMediumEmphasisLight = Color(0x99000000); // 60% opacity
  static const Color textDisabledLight = Color(0x61000000); // 38% opacity

  static const Color textHighEmphasisDark = Color(0xFFF8F6F3); // 100% opacity
  static const Color textMediumEmphasisDark = Color(0x99FFFFFF); // 60% opacity
  static const Color textDisabledDark = Color(0x61FFFFFF); // 38% opacity

  /// Light theme optimized for social commerce
  static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: primaryLight,
          onPrimary: accentLight,
          primaryContainer: secondaryLight,
          onPrimaryContainer: accentLight,
          secondary: secondaryLight,
          onSecondary: accentLight,
          secondaryContainer: borderLight,
          onSecondaryContainer: accentLight,
          tertiary: warningLight,
          onTertiary: surfaceLight,
          tertiaryContainer: warningLight.withValues(alpha: 0.1),
          onTertiaryContainer: accentLight,
          error: errorLight,
          onError: surfaceLight,
          surface: surfaceLight,
          onSurface: accentLight,
          onSurfaceVariant: textMediumEmphasisLight,
          outline: borderLight,
          outlineVariant: borderLight.withValues(alpha: 0.5),
          shadow: accentLight.withValues(alpha: 0.1),
          scrim: overlayLight,
          inverseSurface: accentLight,
          onInverseSurface: primaryLight,
          inversePrimary: accentDark),
      scaffoldBackgroundColor: surfaceLight,
      cardColor: primaryLight,
      dividerColor: borderLight,

      // AppBar theme for content-aware navigation
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: accentLight,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: accentLight,
              letterSpacing: -0.5),
          iconTheme: const IconThemeData(color: accentLight, size: 24),
          actionsIconTheme: const IconThemeData(color: accentLight, size: 24)),

      // Card theme with adaptive elevation
      cardTheme: CardTheme(
          color: primaryLight,
          elevation: 0,
          shadowColor: accentLight.withValues(alpha: 0.08),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),

      // Bottom navigation optimized for video commerce
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: surfaceLight,
          selectedItemColor: accentLight,
          unselectedItemColor: textMediumEmphasisLight,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: GoogleFonts.inter(
              fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.4),
          unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4)),

      // Floating action button for contextual actions
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: accentLight,
          foregroundColor: primaryLight,
          elevation: 8,
          focusElevation: 12,
          hoverElevation: 12,
          highlightElevation: 16,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),

      // Button themes with micro-interaction feedback
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: primaryLight,
              backgroundColor: accentLight,
              elevation: 2,
              shadowColor: accentLight.withValues(alpha: 0.2),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1),
              animationDuration: const Duration(milliseconds: 200))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor: accentLight,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              side: BorderSide(color: borderLight, width: 1.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1),
              animationDuration: const Duration(milliseconds: 200))),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: accentLight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1),
              animationDuration: const Duration(milliseconds: 150))),

      // Typography using Inter and Roboto for optimal mobile readability
      textTheme: _buildTextTheme(isLight: true),

      // Input decoration for form elements
      inputDecorationTheme: InputDecorationTheme(
          fillColor: primaryLight,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: borderLight, width: 1.0)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: borderLight, width: 1.0)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: accentLight, width: 2.0)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: errorLight, width: 1.0)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: errorLight, width: 2.0)),
          labelStyle: GoogleFonts.inter(color: textMediumEmphasisLight, fontSize: 16, fontWeight: FontWeight.w400),
          hintStyle: GoogleFonts.inter(color: textDisabledLight, fontSize: 16, fontWeight: FontWeight.w400),
          prefixIconColor: textMediumEmphasisLight,
          suffixIconColor: textMediumEmphasisLight),

      // Interactive elements
      switchTheme: SwitchThemeData(thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentLight;
        }
        return borderLight;
      }), trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentLight.withValues(alpha: 0.3);
        }
        return borderLight.withValues(alpha: 0.5);
      })),
      checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return accentLight;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(primaryLight),
          side: BorderSide(color: borderLight, width: 1.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
      radioTheme: RadioThemeData(fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentLight;
        }
        return borderLight;
      })),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: accentLight, linearTrackColor: borderLight, circularTrackColor: borderLight),
      sliderTheme: SliderThemeData(activeTrackColor: accentLight, thumbColor: accentLight, overlayColor: accentLight.withValues(alpha: 0.2), inactiveTrackColor: borderLight, trackHeight: 4),

      // Tab bar theme for content navigation
      tabBarTheme: TabBarTheme(labelColor: accentLight, unselectedLabelColor: textMediumEmphasisLight, indicatorColor: accentLight, indicatorSize: TabBarIndicatorSize.label, labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1), unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1)),
      tooltipTheme: TooltipThemeData(decoration: BoxDecoration(color: accentLight.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(8)), textStyle: GoogleFonts.inter(color: primaryLight, fontSize: 12, fontWeight: FontWeight.w400), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      snackBarTheme: SnackBarThemeData(backgroundColor: accentLight, contentTextStyle: GoogleFonts.inter(color: primaryLight, fontSize: 14, fontWeight: FontWeight.w400), actionTextColor: warningLight, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),

      // Bottom sheet theme for contextual actions
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: surfaceLight, elevation: 8, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), clipBehavior: Clip.antiAliasWithSaveLayer),

      // Dialog theme
      dialogTheme: DialogTheme(backgroundColor: surfaceLight, elevation: 8, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), titleTextStyle: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: accentLight), contentTextStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: textHighEmphasisLight)));

  /// Dark theme optimized for social commerce
  static ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: primaryDark,
          onPrimary: accentDark,
          primaryContainer: secondaryDark,
          onPrimaryContainer: accentDark,
          secondary: secondaryDark,
          onSecondary: accentDark,
          secondaryContainer: borderDark,
          onSecondaryContainer: accentDark,
          tertiary: warningDark,
          onTertiary: primaryDark,
          tertiaryContainer: warningDark.withValues(alpha: 0.2),
          onTertiaryContainer: accentDark,
          error: errorDark,
          onError: primaryDark,
          surface: surfaceDark,
          onSurface: accentDark,
          onSurfaceVariant: textMediumEmphasisDark,
          outline: borderDark,
          outlineVariant: borderDark.withValues(alpha: 0.5),
          shadow: Colors.black.withValues(alpha: 0.2),
          scrim: overlayDark,
          inverseSurface: accentDark,
          onInverseSurface: primaryDark,
          inversePrimary: accentLight),
      scaffoldBackgroundColor: surfaceDark,
      cardColor: primaryDark,
      dividerColor: borderDark,

      // AppBar theme for content-aware navigation
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: accentDark,
          elevation: 0,
          scrolledUnderElevation: 0,
          titleTextStyle: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: accentDark,
              letterSpacing: -0.5),
          iconTheme: const IconThemeData(color: accentDark, size: 24),
          actionsIconTheme: const IconThemeData(color: accentDark, size: 24)),

      // Card theme with adaptive elevation
      cardTheme: CardTheme(
          color: primaryDark,
          elevation: 0,
          shadowColor: Colors.black.withValues(alpha: 0.2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),

      // Bottom navigation optimized for video commerce
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: surfaceDark,
          selectedItemColor: accentDark,
          unselectedItemColor: textMediumEmphasisDark,
          type: BottomNavigationBarType.fixed,
          elevation: 8,
          selectedLabelStyle: GoogleFonts.inter(
              fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.4),
          unselectedLabelStyle: GoogleFonts.inter(
              fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4)),

      // Floating action button for contextual actions
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: accentDark,
          foregroundColor: primaryDark,
          elevation: 8,
          focusElevation: 12,
          hoverElevation: 12,
          highlightElevation: 16,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),

      // Button themes with micro-interaction feedback
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              foregroundColor: primaryDark,
              backgroundColor: accentDark,
              elevation: 2,
              shadowColor: Colors.black.withValues(alpha: 0.3),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1),
              animationDuration: const Duration(milliseconds: 200))),
      outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
              foregroundColor: accentDark,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              side: BorderSide(color: borderDark, width: 1.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.1),
              animationDuration: const Duration(milliseconds: 200))),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              foregroundColor: accentDark,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              textStyle: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.1),
              animationDuration: const Duration(milliseconds: 150))),

      // Typography using Inter and Roboto for optimal mobile readability
      textTheme: _buildTextTheme(isLight: false),

      // Input decoration for form elements
      inputDecorationTheme: InputDecorationTheme(
          fillColor: primaryDark,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: borderDark, width: 1.0)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: borderDark, width: 1.0)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: accentDark, width: 2.0)),
          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: errorDark, width: 1.0)),
          focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide(color: errorDark, width: 2.0)),
          labelStyle: GoogleFonts.inter(color: textMediumEmphasisDark, fontSize: 16, fontWeight: FontWeight.w400),
          hintStyle: GoogleFonts.inter(color: textDisabledDark, fontSize: 16, fontWeight: FontWeight.w400),
          prefixIconColor: textMediumEmphasisDark,
          suffixIconColor: textMediumEmphasisDark),

      // Interactive elements
      switchTheme: SwitchThemeData(thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentDark;
        }
        return borderDark;
      }), trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentDark.withValues(alpha: 0.3);
        }
        return borderDark.withValues(alpha: 0.5);
      })),
      checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return accentDark;
            }
            return Colors.transparent;
          }),
          checkColor: WidgetStateProperty.all(primaryDark),
          side: BorderSide(color: borderDark, width: 1.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4))),
      radioTheme: RadioThemeData(fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return accentDark;
        }
        return borderDark;
      })),
      progressIndicatorTheme: ProgressIndicatorThemeData(color: accentDark, linearTrackColor: borderDark, circularTrackColor: borderDark),
      sliderTheme: SliderThemeData(activeTrackColor: accentDark, thumbColor: accentDark, overlayColor: accentDark.withValues(alpha: 0.2), inactiveTrackColor: borderDark, trackHeight: 4),

      // Tab bar theme for content navigation
      tabBarTheme: TabBarTheme(labelColor: accentDark, unselectedLabelColor: textMediumEmphasisDark, indicatorColor: accentDark, indicatorSize: TabBarIndicatorSize.label, labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1), unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.1)),
      tooltipTheme: TooltipThemeData(decoration: BoxDecoration(color: accentDark.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(8)), textStyle: GoogleFonts.inter(color: primaryDark, fontSize: 12, fontWeight: FontWeight.w400), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8)),
      snackBarTheme: SnackBarThemeData(backgroundColor: accentDark, contentTextStyle: GoogleFonts.inter(color: primaryDark, fontSize: 14, fontWeight: FontWeight.w400), actionTextColor: warningDark, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),

      // Bottom sheet theme for contextual actions
      bottomSheetTheme: const BottomSheetThemeData(backgroundColor: surfaceDark, elevation: 8, shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))), clipBehavior: Clip.antiAliasWithSaveLayer),

      // Dialog theme
      dialogTheme: DialogTheme(backgroundColor: surfaceDark, elevation: 8, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), titleTextStyle: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: accentDark), contentTextStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: textHighEmphasisDark)));

  /// Helper method to build text theme based on brightness
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textHighEmphasis =
        isLight ? textHighEmphasisLight : textHighEmphasisDark;
    final Color textMediumEmphasis =
        isLight ? textMediumEmphasisLight : textMediumEmphasisDark;
    final Color textDisabled = isLight ? textDisabledLight : textDisabledDark;

    return TextTheme(
        // Display styles for hero content
        displayLarge: GoogleFonts.inter(
            fontSize: 57,
            fontWeight: FontWeight.w400,
            color: textHighEmphasis,
            letterSpacing: -0.25,
            height: 1.12),
        displayMedium: GoogleFonts.inter(
            fontSize: 45,
            fontWeight: FontWeight.w400,
            color: textHighEmphasis,
            letterSpacing: 0,
            height: 1.16),
        displaySmall: GoogleFonts.inter(
            fontSize: 36,
            fontWeight: FontWeight.w400,
            color: textHighEmphasis,
            letterSpacing: 0,
            height: 1.22),

        // Headline styles for seller names and product titles
        headlineLarge: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.w600,
            color: textHighEmphasis,
            letterSpacing: 0,
            height: 1.25),
        headlineMedium: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: textHighEmphasis,
            letterSpacing: 0,
            height: 1.29),
        headlineSmall: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: textHighEmphasis,
            letterSpacing: 0,
            height: 1.33),

        // Title styles for section headers
        titleLarge: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: textHighEmphasis,
            letterSpacing: 0,
            height: 1.27),
        titleMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textHighEmphasis,
            letterSpacing: 0.15,
            height: 1.50),
        titleSmall: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textHighEmphasis,
            letterSpacing: 0.1,
            height: 1.43),

        // Body styles for product descriptions and content
        bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textHighEmphasis,
            letterSpacing: 0.5,
            height: 1.50),
        bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textHighEmphasis,
            letterSpacing: 0.25,
            height: 1.43),
        bodySmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: textMediumEmphasis,
            letterSpacing: 0.4,
            height: 1.33),

        // Label styles for buttons and metadata
        labelLarge: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textHighEmphasis,
            letterSpacing: 0.1,
            height: 1.43),
        labelMedium: GoogleFonts.roboto(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textMediumEmphasis,
            letterSpacing: 0.5,
            height: 1.33),
        labelSmall: GoogleFonts.roboto(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: textDisabled,
            letterSpacing: 0.5,
            height: 1.45));
  }
}
