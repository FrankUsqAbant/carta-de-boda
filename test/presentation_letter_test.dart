import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuestra_historia/app/app.dart';
import 'package:nuestra_historia/features/shadow_theater/presentation/painters/shadow_stage_painter.dart';
import 'package:nuestra_historia/features/shadow_theater/presentation/screens/shadow_theater_play_screen.dart';
import 'package:nuestra_historia/features/welcome/presentation/presentation_letter_screen.dart';
import 'package:nuestra_historia/shared/constants/app_strings.dart';

void main() {
  group('Flujo y Contrato de la Carta de Presentación Teatral', () {
    testWidgets(
        '1. Al abrir la app aparece la Carta de Presentación con los datos y textos exactos',
        (WidgetTester tester) async {
      await tester.pumpWidget(const WeddingApp());
      await tester.pumpAndSettle();

      // Debe abrir en la Carta de Presentación
      expect(find.byType(PresentationLetterScreen), findsOneWidget);

      // Verificación exacta de textos exigidos (Nombres, Fecha y Dedicatoria)
      expect(find.text(AppStrings.coupleNames), findsOneWidget);
      expect(find.text(AppStrings.weddingDate), findsOneWidget);
      expect(find.text(AppStrings.presentationDedication), findsOneWidget);

      // Verificación del botón con forma de rosa en el vértice inferior
      expect(find.byKey(const Key('start_story_rose_button')), findsOneWidget);
    });

    testWidgets(
        '2. La obra NO empieza automáticamente detrás de la carta; tiempo en cero sin límite de lectura',
        (WidgetTester tester) async {
      await tester.pumpWidget(const WeddingApp());
      await tester.pumpAndSettle();

      // Verificar que la obra de sombras NO está montada
      expect(find.byType(ShadowTheaterPlayScreen), findsNothing);
      final masterPainterFinder = find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is MasterShadowStagePainter,
      );
      expect(masterPainterFinder, findsNothing);

      // Simular que el usuario lee la carta durante 10 minutos
      await tester.pump(const Duration(minutes: 10));

      // La obra aún NO existe ni ha consumido tiempo
      expect(find.byType(ShadowTheaterPlayScreen), findsNothing);
      expect(find.byKey(const Key('start_story_rose_button')), findsOneWidget);
    });

    testWidgets(
        '3. Al pulsar la rosa del vértice inferior, transición breve e inicio en Acto 1 con tiempo 00:00.0s',
        (WidgetTester tester) async {
      await tester.pumpWidget(const WeddingApp());
      await tester.pumpAndSettle();

      final roseButtonFinder =
          find.byKey(const Key('start_story_rose_button'));
      expect(roseButtonFinder, findsOneWidget);

      // Tocar la rosa interactiva
      await tester.tap(roseButtonFinder);
      await tester.pump(); // Desencadena la navegación
      await tester
          .pump(const Duration(milliseconds: 850)); // Completa la transición

      // Ahora se encuentra en la obra de sombras dentro del Acto 1 (Amanece)
      expect(find.byType(ShadowTheaterPlayScreen), findsOneWidget);
      expect(find.text('Acto 1: Amanece'), findsOneWidget);
      expect(find.textContaining('02:50.0s'), findsOneWidget);

      // Verificar que los controles de la obra existen y funcionan
      final pauseButtonFinder = find.byTooltip('Pausar');
      expect(pauseButtonFinder, findsOneWidget);

      // Pausar
      await tester.tap(pauseButtonFinder);
      await tester.pump();
      expect(find.byTooltip('Reproducir'), findsOneWidget);

      // Reanudar
      await tester.tap(find.byTooltip('Reproducir'));
      await tester.pump();
      expect(find.byTooltip('Pausar'), findsOneWidget);

      // Avanzar en la obra 15 segundos y verificar continuidad
      await tester.pump(const Duration(seconds: 15));
      expect(find.text('Acto 2: Ella y la flor'), findsOneWidget);

      // Reiniciar
      final restartFinder = find.byTooltip('Reiniciar fragmento');
      await tester.tap(restartFinder);
      await tester.pump();
      expect(find.text('Acto 1: Amanece'), findsOneWidget);
    });
  });
}
