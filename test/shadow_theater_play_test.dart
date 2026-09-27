import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nuestra_historia/app/app.dart';
import 'package:nuestra_historia/features/shadow_theater/core/models/theater_scene.dart';
import 'package:nuestra_historia/features/shadow_theater/presentation/painters/shadow_stage_painter.dart';
import 'package:nuestra_historia/features/shadow_theater/presentation/screens/shadow_theater_play_screen.dart';

void main() {
  group('Contrato Maestro de Tiempos del Teatro de Sombras (14 Escenas)', () {
    test('El guion maestro contiene exactamente 14 escenas continuas', () {
      expect(MasterTheaterScript.fullScript.length, equals(14));
    });

    test(
        'La duración total planificada es exactamente 170.0 segundos y nunca excede 180s',
        () {
      final totalScriptSeconds = MasterTheaterScript.fullScript.fold<double>(
        0.0,
        (acc, s) => acc + s.durationSeconds,
      );
      expect(totalScriptSeconds, equals(170.0));
      expect(MasterTheaterScript.totalPlannedSeconds, equals(170.0));
      expect(MasterTheaterScript.totalPlannedSeconds, lessThanOrEqualTo(180.0));
    });

    test(
        'Continuidad estricta sin solapamientos ni huecos de tiempo entre las 14 escenas',
        () {
      double expectedStart = 0.0;
      for (final scene in MasterTheaterScript.fullScript) {
        expect(
          scene.startSeconds,
          equals(expectedStart),
          reason:
              'La escena ${scene.id} debe iniciar exactamente al terminar la anterior.',
        );
        expect(scene.endSeconds,
            equals(scene.startSeconds + scene.durationSeconds));
        expectedStart = scene.endSeconds;
      }
      expect(expectedStart, equals(170.0));
    });

    test('Los rótulos exactos pertenecen a las escenas 9, 11 y 13', () {
      expect(MasterTheaterScript.fullScript[8].title,
          contains('Ocho años después'));
      expect(MasterTheaterScript.fullScript[10].title,
          contains('Once años después'));
      expect(MasterTheaterScript.fullScript[12].title,
          contains('Cuatro años después, picnic'));
    });
  });

  group('Pruebas de UI y Renderizado de la Obra Completa (0 a 170s)', () {
    testWidgets(
        'Monta a pantalla completa con MasterShadowStagePainter y controles discretos',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(const WeddingApp(initialHome: ShadowTheaterPlayScreen()));

      expect(find.byType(ShadowTheaterPlayScreen), findsOneWidget);
      final painterFinder = find.byWidgetPredicate(
        (widget) =>
            widget is CustomPaint && widget.painter is MasterShadowStagePainter,
      );
      expect(painterFinder, findsOneWidget);

      expect(find.text('«Bajo el mismo cielo»'), findsOneWidget);
      expect(find.text('Acto 1: Amanece'), findsOneWidget);
    });

    testWidgets('Transición narrativa a lo largo de las escenas de la historia',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(const WeddingApp(initialHome: ShadowTheaterPlayScreen()));

      // Inicio: Acto 1 (Amanece: 0s-10s)
      expect(find.text('Acto 1: Amanece'), findsOneWidget);

      // Avanzar a 12s -> Acto 2: Ella y la flor (10s a 22s)
      await tester.pump(const Duration(seconds: 12));
      expect(find.text('Acto 2: Ella y la flor'), findsOneWidget);

      // Avanzar a 25s (+13s) -> Acto 3: Encuentro casual (22s a 36s)
      await tester.pump(const Duration(seconds: 13));
      expect(find.text('Acto 3: Encuentro casual'), findsOneWidget);

      // Avanzar a 40s (+15s) -> Acto 4: La rosa (36s a 48s)
      await tester.pump(const Duration(seconds: 15));
      expect(find.text('Acto 4: La rosa'), findsOneWidget);

      // Avanzar a 52s (+12s) -> Acto 5: Primer baile (48s a 60s)
      await tester.pump(const Duration(seconds: 12));
      expect(find.text('Acto 5: Primer baile'), findsOneWidget);

      // Avanzar a 64s (+12s) -> Acto 6: Hogar compartido (60s a 71s)
      await tester.pump(const Duration(seconds: 12));
      expect(find.text('Acto 6: Hogar compartido'), findsOneWidget);

      // Avanzar a 76s (+12s) -> Acto 7: Primer hijo (71s a 83s)
      await tester.pump(const Duration(seconds: 12));
      expect(find.text('Acto 7: Primer hijo'), findsOneWidget);

      // Avanzar a 86s (+10s) -> Acto 8: Baile de tres (83s a 93s)
      await tester.pump(const Duration(seconds: 10));
      expect(find.text('Acto 8: Baile de tres'), findsOneWidget);

      // Avanzar a 96s (+10s) -> Acto 9: Ocho años después (93s a 103s)
      await tester.pump(const Duration(seconds: 10));
      expect(find.text('Acto 9: Ocho años después'), findsOneWidget);

      // Avanzar a 106s (+10s) -> Acto 10: Segundo bebé (103s a 114s)
      await tester.pump(const Duration(seconds: 10));
      expect(find.text('Acto 10: Segundo bebé'), findsOneWidget);

      // Avanzar a 118s (+12s) -> Acto 11: Once años después (114s a 125s)
      await tester.pump(const Duration(seconds: 12));
      expect(find.text('Acto 11: Once años después'), findsOneWidget);

      // Avanzar a 128s (+10s) -> Acto 12: Tercer bebé (125s a 136s)
      await tester.pump(const Duration(seconds: 10));
      expect(find.text('Acto 12: Tercer bebé'), findsOneWidget);

      // Avanzar a 140s (+12s) -> Acto 13: Cuatro años después, picnic (136s a 150s)
      await tester.pump(const Duration(seconds: 12));
      expect(find.text('Acto 13: Cuatro años después, picnic'), findsOneWidget);

      // Avanzar a 155s (+15s) -> Acto 14: Bajo la luna (150s a 170s)
      await tester.pump(const Duration(seconds: 15));
      expect(find.text('Acto 14: Bajo la luna'), findsOneWidget);

      // Probar botón de reiniciar
      final restartButtonFinder = find.byTooltip('Reiniciar fragmento');
      expect(restartButtonFinder, findsOneWidget);
      await tester.tap(restartButtonFinder);
      await tester.pump();
      expect(find.text('Acto 1: Amanece'), findsOneWidget);
    });
  });
}
