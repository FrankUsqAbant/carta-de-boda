import 'package:flutter/material.dart';
import '../features/welcome/presentation/presentation_letter_screen.dart';
import '../shared/constants/app_strings.dart';
import '../shared/theme/app_theme.dart';

/// Raíz de la aplicación con tema cinematográfico.
/// Abre inicialmente con la Carta de Presentación antes de iniciar el Teatro de Sombras.
class WeddingApp extends StatelessWidget {
  final Widget? initialHome;

  const WeddingApp({super.key, this.initialHome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: initialHome ?? const PresentationLetterScreen(),
    );
  }
}
