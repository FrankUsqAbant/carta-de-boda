import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Tema visual cinematográfico con enfoque inmersivo a pantalla completa.
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDeep,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.textAccent,
        secondary: AppColors.ambientGlowGold,
        surface: AppColors.backgroundWarmTone,
        onPrimary: AppColors.backgroundDeep,
        onSurface: AppColors.textHero,
      ),
      textTheme: const TextTheme(
        // Protagonistas visuales (nombres de la pareja en pantalla completa)
        displayMedium: TextStyle(
          fontSize: 42.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 2.0,
          color: AppColors.textHero,
          height: 1.15,
          fontFamily: 'serif',
          shadows: [
            Shadow(
              color: Color(0x66DFBA8F),
              blurRadius: 24.0,
              offset: Offset(0, 4),
            ),
          ],
        ),
        // Frase introductoria narrativa
        titleSmall: TextStyle(
          fontSize: 13.0,
          fontWeight: FontWeight.w400,
          letterSpacing: 3.5,
          color: AppColors.textAccent,
          height: 1.6,
        ),
        // Fecha del enlace (detalle secundario)
        titleMedium: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 2.5,
          color: AppColors.textAccent,
          height: 1.4,
        ),
        // Frase romántica o cita
        bodyLarge: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w300,
          fontStyle: FontStyle.italic,
          letterSpacing: 0.8,
          color: AppColors.textBody,
          height: 1.6,
          fontFamily: 'serif',
        ),
        // Texto del botón
        labelLarge: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.8,
          color: AppColors.buttonText,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF1E171C),
        contentTextStyle: const TextStyle(
          color: AppColors.textHero,
          fontSize: 14.0,
          letterSpacing: 0.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
          side: const BorderSide(color: AppColors.buttonBorder, width: 0.8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
