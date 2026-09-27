import 'package:flutter/material.dart';

/// Paleta de colores cinematográfica: tonos profundos, cálidos, iluminación difusa y contrastes nobles.
class AppColors {
  AppColors._();

  // Fondo cinematográfico profundo
  static const Color backgroundDeep = Color(0xFF0C0A0D);
  static const Color backgroundWarmTone = Color(0xFF161014);
  static const Color backgroundVignette = Color(0xFF060507);

  // Luces difusas y halos cálidos
  static const Color ambientGlowGold = Color(0xFFD4AF87);
  static const Color ambientGlowAmber = Color(0xFFC87D55);
  static const Color ambientGlowRose = Color(0xFF8E4B55);

  // Tipografía cinematográfica
  static const Color textHero = Color(0xFFFAF7F2); // Blanco marfil cálido
  static const Color textAccent = Color(0xFFDFBA8F); // Oro suave champán
  static const Color textBody = Color(0xFFC7BBB2); // Tono cálido legible
  static const Color textMuted = Color(0xFF8E837B); // Detalle secundario

  // Botón integrado e interactivo (estilo translúcido con brillo de borde)
  static const Color buttonSurface =
      Color(0x26FFFFFF); // 15% blanco translúcido
  static const Color buttonBorder =
      Color(0x66DFBA8F); // Borde dorado suave al 40%
  static const Color buttonText = Color(0xFFFAF7F2);
  static const Color buttonGlow = Color(0x33DFBA8F);
}
