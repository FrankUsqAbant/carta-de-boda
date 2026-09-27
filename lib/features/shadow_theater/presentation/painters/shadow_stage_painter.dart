import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'human_silhouette_painter.dart';
import 'props_painter.dart';

/// Pintor principal del Teatro de Sombras para la obra completa «Bajo el mismo cielo»
/// (14 escenas continuas, 170 segundos planificados, máximo estricto: 180s).
class MasterShadowStagePainter extends CustomPainter {
  final double currentSeconds;

  MasterShadowStagePainter({required this.currentSeconds});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final groundY = h * 0.72;
    final scale = (w / 380.0).clamp(0.85, 1.25);

    // Pinturas base de siluetas
    const shadowColor = Color(0xFF09070B);
    final shadowPaint = Paint()
      ..color = shadowColor
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 0.75);

    final crispShadowPaint = Paint()
      ..color = shadowColor
      ..style = PaintingStyle.fill;

    // 1. ILUMINACIÓN Y CICLO DÍA / ATARDECER / NOCHE
    _drawLightingAndCelestialBodies(canvas, w, h, groundY);

    // Si estamos en la oscuridad inicial (< 1.2s) o en la oscuridad total final (> 167s)
    if (currentSeconds < 1.2 || currentSeconds >= 168.5) {
      return;
    }

    // 2. PAISAJE NATURAL (Árboles, suelo vivo, casa sencilla bajo los árboles)
    _drawScenicLandscape(
        canvas, w, h, groundY, scale, shadowPaint, crispShadowPaint);

    // 3. COREOGRAFÍA Y ACCIÓN DE LAS 14 ESCENAS
    _drawMasterStoryChoreography(canvas, w, h, groundY, scale, shadowPaint);

    // 4. RÓTULOS DE SALTOS TEMPORALES (Escenas 9, 11 y 13)
    _drawTemporalCaptions(canvas, w, h);
  }

  /// 1. Iluminación difusa, sol, puesta de sol, luna y oscuridad final
  void _drawLightingAndCelestialBodies(
      Canvas canvas, double w, double h, double groundY) {
    final t = currentSeconds;

    if (t <= 1.0 || t >= 168.5) {
      // Oscuridad absoluta
      canvas.drawRect(
          Rect.fromLTWH(0, 0, w, h), Paint()..color = const Color(0xFF000000));
      return;
    }

    // Factor de luz ambiental (amanecer 1s-8s, atardecer 48s-71s, noche 148s-168s)
    double daylightIntensity = 1.0;
    if (t < 8.0) {
      daylightIntensity =
          Curves.easeInOutCubic.transform(((t - 1.0) / 7.0).clamp(0.0, 1.0));
    } else if (t > 48.0 && t < 71.0) {
      // Atardecer cálido de tonos dorados/ámbar
      daylightIntensity = 0.95;
    } else if (t >= 148.0) {
      // Pasa a noche y luego oscuridad total final
      final fadeToNight = ((168.5 - t) / 20.5).clamp(0.0, 1.0);
      daylightIntensity = Curves.easeInOut.transform(fadeToNight);
    }

    // POSICIÓN DEL SOL (Asciende en escena 1, desciende en escena 5 y se oculta antes de escena 14)
    bool showSun = t < 145.0; // El sol se oculta por completo antes de la luna
    final sunX = w * 0.46;
    double sunY;

    if (t < 10.0) {
      // Ascenso matutino
      final p = ((t - 2.0) / 6.0).clamp(0.0, 1.0);
      final elevation = Curves.easeOutCubic.transform(p);
      sunY = (groundY + 40.0) + (h * 0.26 - (groundY + 40.0)) * elevation;
    } else if (t < 48.0) {
      // Sol matutino pleno
      sunY = h * 0.26;
    } else if (t < 75.0) {
      // Descenso del sol en el primer baile y hogar compartido
      final p = ((t - 48.0) / 27.0).clamp(0.0, 1.0);
      sunY = (h * 0.26) +
          ((groundY - 15.0) - (h * 0.26)) * Curves.easeInOutQuad.transform(p);
    } else {
      // Ocultamiento gradual tras el horizonte
      final p = ((t - 75.0) / 65.0).clamp(0.0, 1.0);
      sunY = (groundY - 15.0) + 70.0 * p;
      if (sunY > groundY + 45.0) showSun = false;
    }

    // Colores de la tela según el acto
    Color cCenter, cMid, cEdge;
    if (t < 48.0) {
      // Día cálido de sombras
      cCenter = const Color(0xFFFFF6DF);
      cMid = const Color(0xFFE5C89F);
      cEdge = const Color(0xFFA66E44);
    } else if (t < 148.0) {
      // Tarde dorada / crepúsculo de familia
      cCenter = const Color(0xFFFFECC4);
      cMid = const Color(0xFFD6A275);
      cEdge = const Color(0xFF75432B);
    } else {
      // Noche íntima bajo la luna (azul noche sepia cálido)
      cCenter = const Color(0xFF38313A);
      cMid = const Color(0xFF1E1720);
      cEdge = const Color(0xFF0C090E);
    }

    final backlightGradient = RadialGradient(
      center: Alignment(
        (sunX / w) * 2.0 - 1.0,
        (showSun ? (sunY / h) * 2.0 - 1.0 : -0.2),
      ),
      radius: 0.95,
      colors: [
        cCenter.withValues(alpha: 0.96 * daylightIntensity),
        cMid.withValues(alpha: 0.85 * daylightIntensity),
        cEdge.withValues(alpha: 0.55 * daylightIntensity),
        const Color(0xFF160E18).withValues(alpha: 0.40 * daylightIntensity),
        const Color(0xFF000000),
      ],
      stops: const [0.0, 0.32, 0.62, 0.85, 1.0],
    );

    canvas.drawRect(
      Rect.fromLTWH(0, 0, w, h),
      Paint()
        ..shader = backlightGradient.createShader(Rect.fromLTWH(0, 0, w, h)),
    );

    // Dibujar el sol si aún no se ha ocultado por completo
    if (showSun && sunY < groundY + 15.0) {
      final sunGlow = Paint()
        ..color =
            const Color(0xFFFFECC2).withValues(alpha: 0.40 * daylightIntensity)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24.0);
      canvas.drawCircle(Offset(sunX, sunY), 38.0, sunGlow);

      final sunDisc = Paint()
        ..color =
            const Color(0xFFFFF9EA).withValues(alpha: 0.90 * daylightIntensity);
      canvas.drawCircle(Offset(sunX, sunY), 22.0, sunDisc);
    }

    // Dibujar la LUNA (Escena 14: t >= 150s, el sol ya está oculto)
    if (t >= 150.0 && !showSun) {
      final moonRise = ((t - 150.0) / 4.0).clamp(0.0, 1.0);
      final moonIntensity =
          daylightIntensity * Curves.easeOut.transform(moonRise);
      PropsPainter.drawMoon(
        canvas: canvas,
        cx: w * 0.72,
        cy: h * 0.24,
        radius: 20.0,
        intensity: moonIntensity,
      );
    }

    // Viñeta teatral de embocadura
    final vignette = Paint()
      ..shader = RadialGradient(
        radius: 1.15,
        colors: [
          Colors.transparent,
          Colors.black.withValues(alpha: 0.35),
          Colors.black.withValues(alpha: 0.80),
        ],
        stops: const [0.65, 0.88, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), vignette);
  }

  /// 2. Paisaje recurrente: suelo, dos árboles y casa sencilla
  void _drawScenicLandscape(
    Canvas canvas,
    double w,
    double h,
    double groundY,
    double scale,
    Paint shadowPaint,
    Paint crispShadowPaint,
  ) {
    final t = currentSeconds;
    final windTime = t * 2.2;
    final windSway = math.sin(windTime) * 0.05;

    // Suelo recortado de papel
    final floorPath = Path()
      ..moveTo(0, groundY)
      ..cubicTo(w * 0.25, groundY - 3.0, w * 0.70, groundY + 3.0, w, groundY)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(floorPath, crispShadowPaint);

    // Briznas de hierba
    for (int i = 0; i < 14; i++) {
      final gx = (w * 0.04) + (i * (w * 0.072));
      final grassHeight = 6.0 + (math.sin(i * 1.5) * 3.5);
      final grassSway = math.sin(windTime + (i * 0.8)) * 3.0;

      final blade = Path()
        ..moveTo(gx, groundY)
        ..quadraticBezierTo(gx + 1.5, groundY - (grassHeight * 0.6),
            gx + grassSway, groundY - grassHeight)
        ..lineTo(gx + 2.0, groundY)
        ..close();
      canvas.drawPath(blade, shadowPaint);
    }

    // Árbol izquierdo
    _drawStylizedTree(
      canvas: canvas,
      rootX: w * 0.12,
      groundY: groundY,
      scale: 0.95,
      isFlipped: false,
      windSway: windSway,
      paint: shadowPaint,
    );

    // Árbol derecho
    _drawStylizedTree(
      canvas: canvas,
      rootX: w * 0.88,
      groundY: groundY,
      scale: 1.05,
      isFlipped: true,
      windSway: -windSway * 0.8,
      paint: shadowPaint,
    );

    // CASA SENCILLA (Aparece en Escena 6 en t=60s y permanece como fondo)
    if (t >= 60.0) {
      final houseP = ((t - 60.0) / 4.0).clamp(0.0, 1.0);
      final houseOpacity = Curves.easeOut.transform(houseP);
      PropsPainter.drawHouseSilhouette(
        canvas: canvas,
        centerX: w * 0.50,
        groundY: groundY,
        scale: scale * 0.95,
        opacity: houseOpacity,
        shadowPaint: shadowPaint,
      );
    }
  }

  void _drawStylizedTree({
    required Canvas canvas,
    required double rootX,
    required double groundY,
    required double scale,
    required bool isFlipped,
    required double windSway,
    required Paint paint,
  }) {
    canvas.save();
    canvas.translate(rootX, groundY);
    if (isFlipped) {
      canvas.scale(-scale, scale);
    } else {
      canvas.scale(scale, scale);
    }

    final trunk = Path()
      ..moveTo(-18.0, 0)
      ..quadraticBezierTo(-10.0, -40.0, -12.0 + (windSway * 15.0), -110.0)
      ..quadraticBezierTo(-4.0, -160.0, 0 + (windSway * 25.0), -210.0)
      ..lineTo(14.0 + (windSway * 25.0), -205.0)
      ..quadraticBezierTo(10.0, -150.0, 16.0 + (windSway * 15.0), -100.0)
      ..quadraticBezierTo(12.0, -35.0, 22.0, 0)
      ..close();
    canvas.drawPath(trunk, paint);

    final branch1 = Path()
      ..moveTo(-10.0, -95.0)
      ..cubicTo(-28.0, -115.0, -55.0, -125.0, -75.0 + (windSway * 30.0), -145.0)
      ..lineTo(-70.0 + (windSway * 30.0), -150.0)
      ..cubicTo(-50.0, -132.0, -22.0, -120.0, -6.0, -110.0)
      ..close();
    canvas.drawPath(branch1, paint);

    final branch2 = Path()
      ..moveTo(12.0, -125.0)
      ..cubicTo(35.0, -145.0, 60.0, -155.0, 78.0 + (windSway * 25.0), -175.0)
      ..lineTo(74.0 + (windSway * 25.0), -180.0)
      ..cubicTo(54.0, -162.0, 28.0, -150.0, 8.0, -135.0)
      ..close();
    canvas.drawPath(branch2, paint);

    final foliageCenter = Offset(0 + (windSway * 25.0), -220.0);
    canvas.drawOval(
      Rect.fromCenter(center: foliageCenter, width: 95.0, height: 60.0),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(foliageCenter.dx - 45.0, foliageCenter.dy + 35.0),
          width: 75.0,
          height: 50.0),
      paint,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(foliageCenter.dx + 48.0, foliageCenter.dy + 25.0),
          width: 70.0,
          height: 48.0),
      paint,
    );

    canvas.restore();
  }

  /// 3. Coreografía de las 14 escenas
  void _drawMasterStoryChoreography(
    Canvas canvas,
    double w,
    double h,
    double groundY,
    double scale,
    Paint shadowPaint,
  ) {
    final t = currentSeconds;

    // --- PROPS DE LAS ESCENAS 1 A 4 ---
    if (t < 13.5) {
      PropsPainter.drawWildFlowerOnGround(
        canvas: canvas,
        x: w * 0.38,
        groundY: groundY,
        swayAngle: math.sin(t * 2.2) * 0.08,
        paint: shadowPaint,
      );
    }
    if (t < 38.0) {
      PropsPainter.drawRoseOnGround(
        canvas: canvas,
        x: w * 0.76,
        groundY: groundY,
        swayAngle: math.sin(t * 2.2) * 0.08,
        paint: shadowPaint,
      );
    }

    // Pétalos cayendo en escena 2
    if (t >= 15.5 && t < 26.0) {
      PropsPainter.drawFallingPetal(
        canvas: canvas,
        startPos: Offset(w * 0.38 + 18.0, groundY - 65.0),
        groundY: groundY - 2.0,
        elapsedSinceDetach: t - 15.5,
        fallDuration: 2.2,
        horizontalDrift: 24.0,
        paint: shadowPaint,
      );
    }
    if (t >= 17.2 && t < 26.0) {
      PropsPainter.drawFallingPetal(
        canvas: canvas,
        startPos: Offset(w * 0.38 + 18.0, groundY - 65.0),
        groundY: groundY - 2.0,
        elapsedSinceDetach: t - 17.2,
        fallDuration: 2.3,
        horizontalDrift: 38.0,
        paint: shadowPaint,
      );
    }
    if (t >= 18.9 && t < 26.0) {
      PropsPainter.drawFallingPetal(
        canvas: canvas,
        startPos: Offset(w * 0.38 + 18.0, groundY - 65.0),
        groundY: groundY - 2.0,
        elapsedSinceDetach: t - 18.9,
        fallDuration: 2.0,
        horizontalDrift: 16.0,
        paint: shadowPaint,
      );
    }

    // Tallo caído en escena 4
    if (t >= 41.5 && t < 48.0) {
      PropsPainter.drawFallingPetal(
        canvas: canvas,
        startPos: Offset(w * 0.42 + 8.0, groundY - 55.0),
        groundY: groundY - 2.0,
        elapsedSinceDetach: t - 41.5,
        fallDuration: 1.5,
        horizontalDrift: 8.0,
        paint: shadowPaint,
      );
    }

    // MANTA DE PICNIC (Escena 13: 136s a 150s, y recogida en 150s-153s)
    if (t >= 136.0 && t < 153.0) {
      final matOpacity =
          (t < 150.0) ? 1.0 : ((153.0 - t) / 3.0).clamp(0.0, 1.0);
      PropsPainter.drawPicnicMatAndBasket(
        canvas: canvas,
        centerX: w * 0.50,
        groundY: groundY,
        scale: scale,
        opacity: matOpacity,
        shadowPaint: shadowPaint,
      );
    }

    // --- PERSONAJES PRINCIPALES (ELLA Y ÉL) ---
    _renderMasterCouple(canvas, w, groundY, scale, shadowPaint, t);

    // --- LOS TRES HIJOS SEGÚN CADA ESCENA ---
    _renderChildren(canvas, w, groundY, scale, shadowPaint, t);
  }

  /// Renderiza a Ella y a Él a través de las 14 escenas sin teletransportaciones
  void _renderMasterCouple(
    Canvas canvas,
    double w,
    double groundY,
    double scale,
    Paint shadowPaint,
    double t,
  ) {
    double femaleX = w * 0.42;
    double maleX = w * 0.58;
    double femaleWalkCycle = 0.0;
    double maleWalkCycle = 0.0;
    double bendProgress = 0.0;
    double pluckingProgress = 0.0;
    double surpriseTilt = 0.0;
    double receiveRoseProgress = 0.0;
    double holdHandProgress = 0.0;
    double pregnancyProfile = 0.0;
    double holdBabyProgress = 0.0;
    double sittingProgress = 0.0;
    double maleCaressBaby = 0.0;
    double maleHandOnChild = 0.0;
    int remainingPetals = 0;
    const femaleFacingRight = true;
    bool maleFacingLeft = true;
    bool maleHoldingRose = false;
    bool drawBabyInArms = false;
    Offset babyPos = Offset.zero;

    // ESCENAS 1 a 4 (0s a 48s)
    if (t < 13.5) {
      final p = ((t - 10.0) / 3.5).clamp(0.0, 1.0);
      femaleX = (-w * 0.15) +
          (w * 0.38 - (-w * 0.15)) * Curves.easeInOutQuad.transform(p);
      femaleWalkCycle = math.sin(p * math.pi * 8.0);
      remainingPetals = 4;
    } else if (t < 15.0) {
      femaleX = w * 0.38;
      bendProgress = math.sin(((t - 13.5) / 1.5).clamp(0.0, 1.0) * math.pi);
      remainingPetals = 4;
    } else if (t < 22.0) {
      femaleX = w * 0.38;
      if (t < 17.2) {
        remainingPetals = (t < 15.5) ? 4 : 3;
        pluckingProgress = ((t - 15.0) / 2.0).clamp(0.0, 1.0);
      } else if (t < 18.9) {
        remainingPetals = 2;
        pluckingProgress = ((t - 17.2) / 1.7).clamp(0.0, 1.0);
      } else if (t < 20.5) {
        remainingPetals = 1;
        pluckingProgress = ((t - 18.9) / 1.6).clamp(0.0, 1.0);
      } else {
        remainingPetals = 1;
        surpriseTilt =
            Curves.easeOut.transform(((t - 20.5) / 1.5).clamp(0.0, 1.0)) * 0.4;
      }
    } else if (t < 36.0) {
      // Escena 3: Encuentro casual
      if (t < 28.0) {
        femaleX = w * 0.38;
        surpriseTilt = 0.5;
      } else if (t < 30.5) {
        final p = ((t - 28.0) / 2.5).clamp(0.0, 1.0);
        femaleX = (w * 0.38) - (w * 0.03 * Curves.easeInOutCubic.transform(p));
        surpriseTilt = 0.8;
      } else if (t < 33.0) {
        femaleX = w * 0.35;
        surpriseTilt = 0.6;
      } else {
        final p = ((t - 33.0) / 3.0).clamp(0.0, 1.0);
        femaleX = (w * 0.35) + (w * 0.07 * Curves.easeInOutCubic.transform(p));
        femaleWalkCycle = math.sin(p * math.pi * 3.0) * 0.7;
        surpriseTilt = 0.3;
      }
      remainingPetals = 1;
    } else if (t < 48.0) {
      // Escena 4: La rosa
      femaleX = w * 0.42;
      if (t < 41.5) {
        remainingPetals = 1;
      } else if (t < 44.5) {
        receiveRoseProgress =
            Curves.easeOutCubic.transform(((t - 41.5) / 3.0).clamp(0.0, 1.0));
      } else {
        receiveRoseProgress = 1.0;
        holdHandProgress =
            Curves.easeInOutCubic.transform(((t - 44.5) / 2.5).clamp(0.0, 1.0));
      }
    }
    // ESCENA 5 (48s a 60s): Primer baile
    else if (t < 60.0) {
      final danceTime = (t - 48.0);
      final sway = math.sin(danceTime * math.pi * 0.5) * 16.0;
      femaleX = w * 0.46 + sway;
      maleX = w * 0.54 + sway;
      femaleWalkCycle = math.sin(danceTime * math.pi * 1.0) * 0.5;
      maleWalkCycle = -femaleWalkCycle;
      holdHandProgress = 1.0;
      receiveRoseProgress = 0.8;
    }
    // ESCENA 6 (60s a 71s): Hogar compartido (entran y se sientan juntos)
    else if (t < 71.0) {
      final p = ((t - 60.0) / 4.0).clamp(0.0, 1.0);
      femaleX =
          (w * 0.46) + (w * 0.48 - w * 0.46) * Curves.easeInOut.transform(p);
      maleX =
          (w * 0.54) + (w * 0.52 - w * 0.54) * Curves.easeInOut.transform(p);
      if (t > 65.0) {
        final sitP = ((t - 65.0) / 4.0).clamp(0.0, 1.0);
        sittingProgress = Curves.easeOutCubic.transform(sitP);
      }
      holdHandProgress = 1.0;
    }
    // ESCENA 7 (71s a 83s): Primer hijo
    else if (t < 83.0) {
      femaleX = w * 0.43;
      maleX = w * 0.57;
      holdBabyProgress = 1.0;
      drawBabyInArms = true;
      babyPos = Offset(femaleX + 16.0 * scale, groundY - 68.0 * scale);
      if (t > 74.0) {
        maleCaressBaby =
            Curves.easeInOut.transform(((t - 74.0) / 4.0).clamp(0.0, 1.0));
      }
    }
    // ESCENA 8 (83s a 93s): Baile de tres
    else if (t < 93.0) {
      final danceP = (t - 83.0);
      femaleX = w * 0.38 + math.sin(danceP * math.pi * 0.6) * 10.0;
      maleX = w * 0.62 - math.sin(danceP * math.pi * 0.6) * 10.0;
      holdHandProgress = 0.9;
    }
    // ESCENA 9 (93s a 103s): Ocho años después (embarazo visible)
    else if (t < 103.0) {
      femaleX = w * 0.41;
      maleX = w * 0.59;
      pregnancyProfile = 1.0; // Vientre de gestación visible
      holdHandProgress = 1.0;
    }
    // ESCENA 10 (103s a 114s): Segundo bebé
    else if (t < 114.0) {
      femaleX = w * 0.40;
      maleX = w * 0.60;
      holdBabyProgress = 1.0;
      drawBabyInArms = true;
      babyPos = Offset(femaleX + 16.0 * scale, groundY - 68.0 * scale);
      maleHandOnChild = 1.0; // Mano en hombro del hijo mayor
    }
    // ESCENA 11 (114s a 125s): Once años después (tercer embarazo y ronda en círculo)
    else if (t < 125.0) {
      final circleP = (t - 114.0);
      femaleX = w * 0.42 + math.sin(circleP * math.pi * 0.5) * 8.0;
      maleX = w * 0.58 - math.sin(circleP * math.pi * 0.5) * 8.0;
      pregnancyProfile = 1.0; // Nuevo embarazo
      holdHandProgress = 1.0;
    }
    // ESCENA 12 (125s a 136s): Tercer bebé
    else if (t < 136.0) {
      femaleX = w * 0.42;
      maleX = w * 0.56;
      holdBabyProgress = 1.0;
      drawBabyInArms = true;
      babyPos = Offset(femaleX + 16.0 * scale, groundY - 68.0 * scale);
    }
    // ESCENA 13 (136s a 150s): Cuatro años después, picnic de cinco
    else if (t < 150.0) {
      femaleX = w * 0.42;
      maleX = w * 0.58;
      sittingProgress = 0.8;
      holdHandProgress = 1.0;
    }
    // ESCENA 14 (150s a 170s): Bajo la luna (pareja sola)
    else {
      femaleX = w * 0.44;
      maleX = w * 0.56;
      holdHandProgress = 1.0;
      sittingProgress = 0.0;
    }

    // MOVIMIENTO DE ÉL EN ESCENAS 3 Y 4
    if (t >= 22.0 && t < 48.0) {
      if (t < 26.0) {
        final p = ((t - 22.0) / 4.0).clamp(0.0, 1.0);
        maleX = (w * 1.08) -
            ((w * 1.08 - w * 0.72) * Curves.easeInOutQuad.transform(p));
        maleWalkCycle = math.sin(p * math.pi * 9.0);
      } else if (t < 28.0) {
        maleX = w * 0.72;
      } else if (t < 30.5) {
        final p = ((t - 28.0) / 2.5).clamp(0.0, 1.0);
        maleX = (w * 0.72) + (w * 0.03 * Curves.easeInOutCubic.transform(p));
      } else if (t < 33.0) {
        maleX = w * 0.75;
      } else if (t < 36.0) {
        final p = ((t - 33.0) / 3.0).clamp(0.0, 1.0);
        maleX = (w * 0.75) - (w * 0.07 * Curves.easeInOutCubic.transform(p));
        maleWalkCycle = math.sin(p * math.pi * 3.0) * 0.7;
      } else if (t < 38.5) {
        if (t < 37.2) {
          maleX = w * 0.68 +
              (w *
                  0.08 *
                  Curves.easeInOut
                      .transform(((t - 36.0) / 1.2).clamp(0.0, 1.0)));
          maleFacingLeft = false;
        } else {
          maleX = w * 0.76;
          maleFacingLeft = false;
          maleHoldingRose = t >= 38.0;
        }
      } else if (t < 41.5) {
        final p = ((t - 38.5) / 3.0).clamp(0.0, 1.0);
        maleX = (w * 0.76) - (w * 0.18 * Curves.easeInOutCubic.transform(p));
        maleHoldingRose = true;
      } else if (t < 44.5) {
        maleX = w * 0.58;
        maleHoldingRose = t < 42.5;
      } else {
        maleX = w * 0.58;
        maleHoldingRose = false;
      }
    }

    // Dibujar Ella si t >= 10s
    if (t >= 10.0) {
      HumanSilhouettePainter.drawFemaleSilhouette(
        canvas: canvas,
        x: femaleX,
        groundY: groundY,
        scale: scale,
        facingRight: femaleFacingRight,
        walkCycle: femaleWalkCycle,
        bendProgress: bendProgress,
        pluckingProgress: pluckingProgress,
        surpriseTilt: surpriseTilt,
        receiveRoseProgress: receiveRoseProgress,
        holdHandProgress: holdHandProgress,
        pregnancyProfile: pregnancyProfile,
        holdBabyProgress: holdBabyProgress,
        sittingProgress: sittingProgress,
        remainingPetals: remainingPetals,
        paint: shadowPaint,
      );
    }

    // Dibujar Él si t >= 22s
    if (t >= 22.0) {
      HumanSilhouettePainter.drawMaleSilhouette(
        canvas: canvas,
        x: maleX,
        groundY: groundY,
        scale: scale,
        facingLeft: maleFacingLeft,
        walkCycle: maleWalkCycle,
        surpriseTilt: surpriseTilt,
        bendToPickProgress: (t >= 37.2 && t < 38.5)
            ? math.sin(((t - 37.2) / 1.3).clamp(0.0, 1.0) * math.pi)
            : 0.0,
        offerRoseProgress: (t >= 38.5 && t < 48.0) ? 1.0 : 0.0,
        holdHandProgress: holdHandProgress,
        caressBabyProgress: maleCaressBaby,
        handOnChildShoulder: maleHandOnChild,
        sittingProgress: sittingProgress,
        paint: shadowPaint,
      );

      if (maleHoldingRose) {
        final roseHandX =
            maleFacingLeft ? maleX - (scale * 38.0) : maleX + (scale * 38.0);
        final roseHandY = groundY - (scale * 105.0);
        PropsPainter.drawHeldRose(
          canvas: canvas,
          handPos: Offset(roseHandX, roseHandY),
          angle: maleFacingLeft ? -0.4 : 0.4,
          paint: shadowPaint,
        );
      }
    }

    // Dibujar bebé en brazos en escenas 7, 10 y 12
    if (drawBabyInArms) {
      PropsPainter.drawBabySwaddle(
        canvas: canvas,
        position: babyPos,
        scale: scale * 0.9,
        angle: 0.25,
        paint: shadowPaint,
      );
    }
  }

  /// Renderiza la presencia y acciones de los 3 hijos según la línea de tiempo
  void _renderChildren(
    Canvas canvas,
    double w,
    double groundY,
    double scale,
    Paint shadowPaint,
    double t,
  ) {
    // ESCENA 8 (83s a 93s): El primogénito ya es un niño y se une al baile por el centro
    if (t >= 83.0 && t < 93.0) {
      final p = ((t - 83.0) / 4.0).clamp(0.0, 1.0);
      final childX =
          (w * 0.15) + (w * 0.50 - w * 0.15) * Curves.easeOutQuad.transform(p);
      HumanSilhouettePainter.drawChildSilhouette(
        canvas: canvas,
        x: childX,
        groundY: groundY,
        heightScale: scale * 0.55,
        facingRight: true,
        walkCycle: math.sin(t * 8.0),
        wavingHand: 0.0,
        touchingBelly: 0.0,
        paint: shadowPaint,
      );
    }

    // ESCENA 9 (93s a 103s): Ocho años después (hijo mayor de ~8 años entra jugando y acaricia vientre)
    if (t >= 93.0 && t < 103.0) {
      final p = ((t - 93.0) / 3.5).clamp(0.0, 1.0);
      final childX =
          (w * 0.20) + (w * 0.34 - w * 0.20) * Curves.easeOutQuad.transform(p);
      HumanSilhouettePainter.drawChildSilhouette(
        canvas: canvas,
        x: childX,
        groundY: groundY,
        heightScale: scale * 0.65,
        facingRight: true,
        walkCycle: (p < 0.9) ? math.sin(t * 7.0) : 0.0,
        wavingHand: 0.0,
        touchingBelly: (t > 96.5) ? 1.0 : 0.0,
        paint: shadowPaint,
      );
    }

    // ESCENA 10 (103s a 114s): Segundo bebé (hijo mayor junto a su padre)
    if (t >= 103.0 && t < 114.0) {
      HumanSilhouettePainter.drawChildSilhouette(
        canvas: canvas,
        x: w * 0.66,
        groundY: groundY,
        heightScale: scale * 0.68,
        facingRight: false,
        walkCycle: 0.0,
        wavingHand: 0.0,
        touchingBelly: 0.0,
        paint: shadowPaint,
      );
    }

    // ESCENA 11 (114s a 125s): Once años después (hijo 1 joven y hijo 2 de 11 años)
    if (t >= 114.0 && t < 125.0) {
      // Hijo 1: Joven adulto (~19 años)
      HumanSilhouettePainter.drawChildSilhouette(
        canvas: canvas,
        x: w * 0.70,
        groundY: groundY,
        heightScale: scale * 0.90,
        facingRight: false,
        walkCycle: math.sin(t * 3.0) * 0.4,
        wavingHand: 0.0,
        touchingBelly: 0.0,
        paint: shadowPaint,
      );

      // Hijo 2: Niño/a de ~11 años
      HumanSilhouettePainter.drawChildSilhouette(
        canvas: canvas,
        x: w * 0.30,
        groundY: groundY,
        heightScale: scale * 0.68,
        facingRight: true,
        walkCycle: math.sin(t * 3.0) * 0.4,
        wavingHand: 0.0,
        touchingBelly: 0.0,
        paint: shadowPaint,
      );
    }

    // ESCENA 12 (125s a 136s): Tercer bebé (los dos hermanos mayores saludan al recién nacido)
    if (t >= 125.0 && t < 136.0) {
      HumanSilhouettePainter.drawChildSilhouette(
        canvas: canvas,
        x: w * 0.68,
        groundY: groundY,
        heightScale: scale * 0.92,
        facingRight: false,
        walkCycle: 0.0,
        wavingHand: 0.0,
        touchingBelly: 0.0,
        paint: shadowPaint,
      );
      HumanSilhouettePainter.drawChildSilhouette(
        canvas: canvas,
        x: w * 0.32,
        groundY: groundY,
        heightScale: scale * 0.70,
        facingRight: true,
        walkCycle: 0.0,
        wavingHand: 0.0,
        touchingBelly: 0.0,
        paint: shadowPaint,
      );
    }

    // ESCENA 13 (136s a 150s): Picnic de CINCO integrantes
    if (t >= 136.0 && t < 150.0) {
      // Hijo 1 (adulto joven)
      HumanSilhouettePainter.drawChildSilhouette(
        canvas: canvas,
        x: w * 0.72,
        groundY: groundY,
        heightScale: scale * 0.92,
        facingRight: false,
        walkCycle: 0.0,
        wavingHand: 0.0,
        touchingBelly: 0.0,
        paint: shadowPaint,
      );

      // Hijo 2 (adolescente ~15 años)
      HumanSilhouettePainter.drawChildSilhouette(
        canvas: canvas,
        x: w * 0.28,
        groundY: groundY,
        heightScale: scale * 0.76,
        facingRight: true,
        walkCycle: 0.0,
        wavingHand: 0.0,
        touchingBelly: 0.0,
        paint: shadowPaint,
      );

      // Hijo 3 (pequeño de 4 años corriendo hacia sus padres y abrazo)
      final runP = ((t - 136.0) / 4.0).clamp(0.0, 1.0);
      final runX = (w * 0.12) +
          (w * 0.36 - w * 0.12) * Curves.easeOutCubic.transform(runP);
      HumanSilhouettePainter.drawChildSilhouette(
        canvas: canvas,
        x: runX,
        groundY: groundY,
        heightScale: scale * 0.45,
        facingRight: true,
        walkCycle: (runP < 0.95) ? math.sin(t * 11.0) : 0.0,
        wavingHand: 0.0,
        touchingBelly: 0.0,
        paint: shadowPaint,
      );
    }

    // ESCENA 14 (150s a 170s): Los TRES hijos entran a la casa y el menor se despide
    if (t >= 150.0 && t < 162.0) {
      final exitP = ((t - 150.0) / 5.5).clamp(0.0, 1.0);
      final doorX = w * 0.50;

      // Hijo 1 entra a casa
      final h1X =
          (w * 0.72) + (doorX - w * 0.72) * Curves.easeIn.transform(exitP);
      if (exitP < 0.75) {
        HumanSilhouettePainter.drawChildSilhouette(
          canvas: canvas,
          x: h1X,
          groundY: groundY,
          heightScale: scale * 0.92,
          facingRight: false,
          walkCycle: math.sin(t * 6.0),
          wavingHand: 0.0,
          touchingBelly: 0.0,
          paint: shadowPaint,
        );
      }

      // Hijo 2 entra a casa
      final h2X =
          (w * 0.28) + (doorX - w * 0.28) * Curves.easeIn.transform(exitP);
      if (exitP < 0.85) {
        HumanSilhouettePainter.drawChildSilhouette(
          canvas: canvas,
          x: h2X,
          groundY: groundY,
          heightScale: scale * 0.76,
          facingRight: true,
          walkCycle: math.sin(t * 6.0),
          wavingHand: 0.0,
          touchingBelly: 0.0,
          paint: shadowPaint,
        );
      }

      // Hijo 3 (pequeño) camina hacia la puerta y se despide con la manito en alto
      final h3X = (w * 0.36) +
          (doorX - 12.0 - w * 0.36) * Curves.easeInOut.transform(exitP);
      if (exitP < 0.95) {
        HumanSilhouettePainter.drawChildSilhouette(
          canvas: canvas,
          x: h3X,
          groundY: groundY,
          heightScale: scale * 0.45,
          facingRight: true,
          walkCycle: math.sin(t * 5.0),
          wavingHand:
              (exitP > 0.45) ? 1.0 : 0.0, // Saludo con la mano al entrar
          touchingBelly: 0.0,
          paint: shadowPaint,
        );
      }
    }
  }

  /// 4. Rótulos exactos para los saltos temporales (Escenas 9, 11 y 13)
  void _drawTemporalCaptions(Canvas canvas, double w, double h) {
    final t = currentSeconds;
    final captionY = h * 0.16;

    // Escena 9: «8 años después» (93.0s a 103.0s)
    if (t >= 93.0 && t <= 103.0) {
      final p = ((t - 93.0) / 10.0);
      final opacity = _calculateCaptionFade(p);
      PropsPainter.drawSceneCaption(
        canvas: canvas,
        text: '«8 años después»',
        screenW: w,
        topY: captionY,
        opacity: opacity,
      );
    }

    // Escena 11: «11 años después» (114.0s a 125.0s)
    if (t >= 114.0 && t <= 125.0) {
      final p = ((t - 114.0) / 11.0);
      final opacity = _calculateCaptionFade(p);
      PropsPainter.drawSceneCaption(
        canvas: canvas,
        text: '«11 años después»',
        screenW: w,
        topY: captionY,
        opacity: opacity,
      );
    }

    // Escena 13: «4 años después» (136.0s a 150.0s)
    if (t >= 136.0 && t <= 150.0) {
      final p = ((t - 136.0) / 14.0);
      final opacity = _calculateCaptionFade(p);
      PropsPainter.drawSceneCaption(
        canvas: canvas,
        text: '«4 años después»',
        screenW: w,
        topY: captionY,
        opacity: opacity,
      );
    }
  }

  double _calculateCaptionFade(double progress) {
    if (progress < 0.20) {
      return (progress / 0.20).clamp(0.0, 1.0);
    } else if (progress > 0.80) {
      return ((1.0 - progress) / 0.20).clamp(0.0, 1.0);
    }
    return 1.0;
  }

  @override
  bool shouldRepaint(covariant MasterShadowStagePainter oldDelegate) {
    return oldDelegate.currentSeconds != currentSeconds;
  }
}
