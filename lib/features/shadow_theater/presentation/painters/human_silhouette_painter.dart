import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Motor cinemático y geométrico de siluetas humanas articuladas
/// para el Teatro de Sombras (Estefania, Darlin y sus 3 hijos a lo largo de las 14 escenas).
class HumanSilhouettePainter {
  HumanSilhouettePainter._();

  /// Silueta de Ella (Estefania) a lo largo de las 14 escenas
  static void drawFemaleSilhouette({
    required Canvas canvas,
    required double x,
    required double groundY,
    required double scale,
    required bool facingRight,
    required double walkCycle, // -1.0 a 1.0 (ciclo de paso)
    required double bendProgress, // 0.0 a 1.0 (inclinación)
    required double pluckingProgress, // 0.0 a 1.0 (deshojar flor)
    required double surpriseTilt, // 0.0 a 1.0 (sorpresa / timidez)
    required double receiveRoseProgress, // 0.0 a 1.0 (recibir rosa)
    required double holdHandProgress, // 0.0 a 1.0 (unir mano)
    required double
        pregnancyProfile, // 0.0 a 1.0 (curvatura de gestación en escenas 9 y 11)
    required double holdBabyProgress, // 0.0 a 1.0 (brazos meciendo bebé)
    required double
        sittingProgress, // 0.0 a 1.0 (sentada junto a Él en escena 6)
    required int remainingPetals, // Pétalos en flor (0 a 4)
    required Paint paint,
  }) {
    canvas.save();
    canvas.translate(x, groundY);
    if (!facingRight) {
      canvas.scale(-scale, scale);
    } else {
      canvas.scale(scale, scale);
    }

    const h = 138.0;
    final legSwing = walkCycle * 4.5;
    final walkBobbing = (walkCycle.abs()) * 2.2;
    final sitOffsetY = sittingProgress * 24.0;

    // 1. Zapatos asomando bajo el vestido
    canvas.drawOval(
      Rect.fromCenter(
        center:
            Offset(legSwing * 0.7 + 3.0, -2.5 - walkBobbing + sitOffsetY * 0.2),
        width: 9.5,
        height: 3.8,
      ),
      paint,
    );

    // 2. Vestido de noche / gala con caída de pliegues fluida y perfil gestante suave
    final dressPath = Path();
    final bendAngle = bendProgress * 0.35;
    final bendOffsetY = bendProgress * 18.0;
    final bellyBuldge = pregnancyProfile * 11.0;

    // Dobladillo inferior
    dressPath.moveTo(-22.0 - (legSwing * 0.4), -3.0 - walkBobbing + sitOffsetY);
    // Caída trasera con pliegue orgánico
    dressPath.cubicTo(
      -24.0,
      -h * 0.18 - walkBobbing + sitOffsetY * 0.7,
      -16.0 + bendAngle * 10,
      -h * 0.34 + bendOffsetY * 0.4 + sitOffsetY * 0.5,
      -7.0 + bendAngle * 18,
      -h * 0.48 + bendOffsetY * 0.7 + sitOffsetY * 0.3,
    );
    // Curvatura lumbar natural
    dressPath.cubicTo(
      -9.0 + bendAngle * 22,
      -h * 0.58 + bendOffsetY * 0.8 + sitOffsetY * 0.2,
      -8.0 + bendAngle * 25,
      -h * 0.68 + bendOffsetY * 0.9,
      -4.5 + bendAngle * 28 - (surpriseTilt * 4.0),
      -h * 0.74 + bendOffsetY,
    );
    // Cuello posterior
    dressPath.lineTo(
        -3.0 + bendAngle * 30 - (surpriseTilt * 5.0), -h * 0.81 + bendOffsetY);

    // Cabeza femenina proporcionada (perfil con moño romántico)
    final headBaseX = bendAngle * 32.0 - (surpriseTilt * 5.0);
    final headBaseY = bendOffsetY - (surpriseTilt * 2.0);

    // Nuca y moño romántico
    dressPath.cubicTo(
      headBaseX - 8.0,
      -h * 0.82 + headBaseY,
      headBaseX - 13.5,
      -h * 0.85 + headBaseY,
      headBaseX - 13.5,
      -h * 0.90 + headBaseY,
    );
    dressPath.cubicTo(
      headBaseX - 13.5,
      -h * 0.96 + headBaseY,
      headBaseX - 8.0,
      -h * 0.98 + headBaseY,
      headBaseX - 3.0,
      -h * 0.97 + headBaseY,
    );
    // Coronilla y frente
    dressPath.cubicTo(
      headBaseX - 1.0,
      -h * 1.00 + headBaseY,
      headBaseX + 5.0,
      -h * 0.99 + headBaseY,
      headBaseX + 7.5,
      -h * 0.93 + headBaseY,
    );
    // Perfil facial suave (frente, nariz, labios y mentón)
    dressPath.cubicTo(
      headBaseX + 8.0,
      -h * 0.91 + headBaseY,
      headBaseX + 8.5,
      -h * 0.89 + headBaseY,
      headBaseX + 8.2,
      -h * 0.875 + headBaseY,
    );
    dressPath.lineTo(headBaseX + 9.2, -h * 0.865 + headBaseY); // Nariz
    dressPath.lineTo(headBaseX + 8.2, -h * 0.855 + headBaseY);
    dressPath.lineTo(headBaseX + 8.6, -h * 0.845 + headBaseY); // Labio superior
    dressPath.lineTo(headBaseX + 8.1, -h * 0.838 + headBaseY);
    dressPath.lineTo(headBaseX + 8.5, -h * 0.832 + headBaseY); // Labio inferior
    dressPath.lineTo(headBaseX + 7.6, -h * 0.818 + headBaseY); // Mentón
    // Mandíbula y cuello frontal
    dressPath.cubicTo(
      headBaseX + 5.2,
      -h * 0.80 + headBaseY,
      headBaseX + 3.8,
      -h * 0.77 + headBaseY,
      headBaseX + 3.2,
      -h * 0.74 + headBaseY,
    );
    // Busto y talle
    dressPath.cubicTo(
      headBaseX + 6.2,
      -h * 0.70 + headBaseY,
      headBaseX + 7.8,
      -h * 0.62 + headBaseY,
      5.5 + bendAngle * 18,
      -h * 0.56 + bendOffsetY * 0.7,
    );

    // Vientre (curvatura suave de embarazo en escenas 9 y 11)
    if (pregnancyProfile > 0.05) {
      dressPath.cubicTo(
        6.5 + bellyBuldge,
        -h * 0.52 + bendOffsetY * 0.5,
        7.5 + bellyBuldge,
        -h * 0.44,
        6.0 + bellyBuldge * 0.6,
        -h * 0.38,
      );
    } else {
      dressPath.cubicTo(
        4.0 + bendAngle * 12,
        -h * 0.52 + bendOffsetY * 0.5,
        3.5,
        -h * 0.48,
        4.0,
        -h * 0.45,
      );
    }

    // Falda frontal con vuelo
    dressPath.cubicTo(
      6.0 + (legSwing * 0.3) + bellyBuldge * 0.4,
      -h * 0.32 - walkBobbing + sitOffsetY * 0.4,
      12.0 + (legSwing * 0.4) + bellyBuldge * 0.2,
      -h * 0.16 - walkBobbing + sitOffsetY * 0.3,
      18.0 + (legSwing * 0.5),
      -3.0 - walkBobbing + sitOffsetY,
    );
    // Dobladillo
    dressPath.cubicTo(
        8.0,
        -1.0 - walkBobbing + sitOffsetY,
        -8.0,
        -1.0 - walkBobbing + sitOffsetY,
        -22.0 - (legSwing * 0.4),
        -3.0 - walkBobbing + sitOffsetY);
    dressPath.close();

    canvas.drawPath(dressPath, paint);

    // 3. BRAZOS CINEMÁTICOS ARTICULADOS
    final armPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.8
      ..strokeCap = StrokeCap.round
      ..maskFilter = paint.maskFilter;

    final shoulder = Offset(headBaseX + 1.0, -h * 0.72 + headBaseY);

    if (holdBabyProgress > 0.05) {
      // Brazos en cunita meciendo al recién nacido
      final cradleTarget = Offset(shoulder.dx + 12.0, shoulder.dy + 16.0);
      final elbowL = Offset(shoulder.dx + 8.0, shoulder.dy + 22.0);
      final elbowR = Offset(shoulder.dx + 16.0, shoulder.dy + 24.0);

      final armL = Path()
        ..moveTo(shoulder.dx, shoulder.dy)
        ..quadraticBezierTo(
            elbowL.dx, elbowL.dy, cradleTarget.dx - 4.0, cradleTarget.dy);
      canvas.drawPath(armL, armPaint);

      final armR = Path()
        ..moveTo(shoulder.dx + 4.0, shoulder.dy)
        ..quadraticBezierTo(
            elbowR.dx, elbowR.dy, cradleTarget.dx + 6.0, cradleTarget.dy - 2.0);
      canvas.drawPath(armR, armPaint);

      // Manos sosteniendo la mantilla
      canvas.drawCircle(cradleTarget, 3.5, paint..style = PaintingStyle.fill);
    } else if (receiveRoseProgress > 0.01) {
      // Gesto de recibir la rosa con ambas manos y acercarla al corazón
      final chestTarget = Offset(
          shoulder.dx + 8.0 + (1.0 - receiveRoseProgress) * 16.0,
          shoulder.dy + 12.0);
      final elbowLeft = Offset(shoulder.dx + 6.0, shoulder.dy + 14.0);
      final elbowRight = Offset(shoulder.dx + 12.0, shoulder.dy + 18.0);

      final armL = Path()
        ..moveTo(shoulder.dx, shoulder.dy)
        ..quadraticBezierTo(
            elbowLeft.dx, elbowLeft.dy, chestTarget.dx - 2.0, chestTarget.dy);
      canvas.drawPath(armL, armPaint);

      final armR = Path()
        ..moveTo(shoulder.dx + 3.0, shoulder.dy)
        ..quadraticBezierTo(elbowRight.dx, elbowRight.dy, chestTarget.dx + 2.0,
            chestTarget.dy - 2.0);
      canvas.drawPath(armR, armPaint);

      canvas.drawCircle(chestTarget, 3.2, paint..style = PaintingStyle.fill);

      if (holdHandProgress > 0.05) {
        final handExtended = Offset(
            chestTarget.dx + (holdHandProgress * 24.0), chestTarget.dy + 4.0);
        final extendArm = Path()
          ..moveTo(chestTarget.dx, chestTarget.dy + 2.0)
          ..quadraticBezierTo(
            (chestTarget.dx + handExtended.dx) * 0.5,
            chestTarget.dy + 6.0,
            handExtended.dx,
            handExtended.dy,
          );
        canvas.drawPath(extendArm, armPaint);
        canvas.drawCircle(handExtended, 3.0, paint);
      }
    } else if (bendProgress > 0.01 &&
        pluckingProgress < 0.01 &&
        remainingPetals >= 4) {
      // Inclinándose a recoger flor
      final reachFloor = Offset(shoulder.dx + 16.0, -8.0);
      final elbow = Offset(shoulder.dx + 10.0, -h * 0.40);
      final arm = Path()
        ..moveTo(shoulder.dx, shoulder.dy)
        ..quadraticBezierTo(elbow.dx, elbow.dy, reachFloor.dx, reachFloor.dy);
      canvas.drawPath(arm, armPaint);
      canvas.drawCircle(reachFloor, 3.0, paint..style = PaintingStyle.fill);
    } else {
      // Brazo izquierdo sosteniendo tallo o extendido
      final stemHandPos = Offset(shoulder.dx + 14.0, shoulder.dy + 15.0);
      final elbowL = Offset(shoulder.dx + 6.0, shoulder.dy + 12.0);

      final armL = Path()
        ..moveTo(shoulder.dx, shoulder.dy)
        ..quadraticBezierTo(
            elbowL.dx, elbowL.dy, stemHandPos.dx, stemHandPos.dy);
      canvas.drawPath(armL, armPaint);
      canvas.drawCircle(stemHandPos, 3.0, paint..style = PaintingStyle.fill);

      if (remainingPetals > 0) {
        canvas.drawLine(
          Offset(stemHandPos.dx - 2.0, stemHandPos.dy + 10.0),
          Offset(stemHandPos.dx + 2.0, stemHandPos.dy - 12.0),
          armPaint..strokeWidth = 2.0,
        );
        final flowerCenter =
            Offset(stemHandPos.dx + 2.0, stemHandPos.dy - 12.0);
        canvas.drawCircle(flowerCenter, 2.2, paint..style = PaintingStyle.fill);

        for (int i = 0; i < remainingPetals; i++) {
          final pAngle = (i * (math.pi * 2.0 / 4.0)) - (math.pi / 2.0);
          final px = flowerCenter.dx + math.cos(pAngle) * 4.0;
          final py = flowerCenter.dy + math.sin(pAngle) * 4.0;
          canvas.drawCircle(Offset(px, py), 1.8, paint);
        }
      }

      // Brazo derecho: gesto rítmico de deshojar o reposo
      final pluckPhase = pluckingProgress;
      Offset rightHandPos;
      if (pluckPhase > 0.01 && pluckPhase < 0.99) {
        if (pluckPhase < 0.35) {
          final p = pluckPhase / 0.35;
          rightHandPos = Offset(
              shoulder.dx + 6.0 + (p * 10.0), shoulder.dy + 22.0 - (p * 20.0));
        } else if (pluckPhase < 0.70) {
          final p = (pluckPhase - 0.35) / 0.35;
          rightHandPos = Offset(
              shoulder.dx + 16.0 + (p * 12.0), shoulder.dy + 2.0 + (p * 8.0));
        } else {
          final p = (pluckPhase - 0.70) / 0.30;
          rightHandPos = Offset(
              shoulder.dx + 28.0 - (p * 22.0), shoulder.dy + 10.0 + (p * 12.0));
        }
      } else {
        rightHandPos = Offset(shoulder.dx + 4.0, shoulder.dy + 24.0);
      }

      final elbowR = Offset(
        (shoulder.dx + rightHandPos.dx) * 0.5 + 4.0,
        (shoulder.dy + rightHandPos.dy) * 0.5 + 4.0,
      );

      final armR = Path()
        ..moveTo(shoulder.dx + 2.0, shoulder.dy)
        ..quadraticBezierTo(
            elbowR.dx, elbowR.dy, rightHandPos.dx, rightHandPos.dy);
      canvas.drawPath(armR, armPaint..strokeWidth = 3.6);
      canvas.drawCircle(rightHandPos, 2.8, paint..style = PaintingStyle.fill);
    }

    canvas.restore();
  }

  /// Silueta de Él (Darlin) a lo largo de las 14 escenas
  static void drawMaleSilhouette({
    required Canvas canvas,
    required double x,
    required double groundY,
    required double scale,
    required bool facingLeft,
    required double walkCycle, // -1.0 a 1.0 (ciclo de paso)
    required double surpriseTilt, // 0.0 a 1.0
    required double bendToPickProgress, // 0.0 a 1.0
    required double offerRoseProgress, // 0.0 a 1.0
    required double holdHandProgress, // 0.0 a 1.0
    required double
        caressBabyProgress, // 0.0 a 1.0 (mano acariciando cabecita de bebé en escena 7)
    required double
        handOnChildShoulder, // 0.0 a 1.0 (mano en hombro del hijo en escena 10)
    required double sittingProgress, // 0.0 a 1.0 (sentado en escena 6)
    required Paint paint,
  }) {
    canvas.save();
    canvas.translate(x, groundY);
    if (facingLeft) {
      canvas.scale(-scale, scale);
    } else {
      canvas.scale(scale, scale);
    }

    const h = 148.0;
    final legSwing = walkCycle * 5.0;
    final walkBobbing = (walkCycle.abs()) * 2.5;
    final sitOffsetY = sittingProgress * 26.0;

    // 1. Pantalón de vestir clásico con zancada real
    final legPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..maskFilter = paint.maskFilter;

    final bendOffsetY = (bendToPickProgress * 28.0) + sitOffsetY;
    final kneeBendL = (bendToPickProgress * 15.0) + (sittingProgress * 18.0);
    final kneeBendR = (bendToPickProgress * 22.0) + (sittingProgress * 14.0);

    // Pierna trasera
    canvas.drawLine(
      Offset(4.5, -h * 0.46 + bendOffsetY * 0.5),
      Offset(6.0 + legSwing + kneeBendR, -3.0),
      legPaint,
    );

    // Pierna delantera
    canvas.drawLine(
      Offset(-3.5, -h * 0.46 + bendOffsetY * 0.5),
      Offset(-4.5 - legSwing + kneeBendL, -3.0),
      legPaint,
    );

    // Zapatos de vestir masculinos
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(6.0 + legSwing + kneeBendR + 2.5, -2.5),
        width: 14.0,
        height: 4.8,
      ),
      paint..style = PaintingStyle.fill,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(-4.5 - legSwing + kneeBendL - 2.5, -2.5),
        width: 14.0,
        height: 4.8,
      ),
      paint,
    );

    // 2. Traje masculino, saco entallado y cabeza clásica
    final suitPath = Path();
    final spineTiltX = (surpriseTilt * -5.0) + (bendToPickProgress * 22.0);
    final spineTiltY = bendOffsetY - (surpriseTilt * 1.5);

    suitPath.moveTo(11.0, -h * 0.42 + bendOffsetY * 0.5);
    suitPath.cubicTo(
      9.0 + spineTiltX * 0.5,
      -h * 0.54 + spineTiltY * 0.6,
      7.5 + spineTiltX * 0.8,
      -h * 0.65 + spineTiltY * 0.8,
      8.0 + spineTiltX,
      -h * 0.75 + spineTiltY,
    );
    suitPath.lineTo(5.5 + spineTiltX, -h * 0.82 + spineTiltY);

    final headBaseX = spineTiltX;
    final headBaseY = spineTiltY;

    suitPath.cubicTo(
      headBaseX + 3.5,
      -h * 0.86 + headBaseY,
      headBaseX + 2.5,
      -h * 0.93 + headBaseY,
      headBaseX - 1.0,
      -h * 0.95 + headBaseY,
    );
    suitPath.cubicTo(
      headBaseX - 4.5,
      -h * 0.97 + headBaseY,
      headBaseX - 8.5,
      -h * 0.95 + headBaseY,
      headBaseX - 10.5,
      -h * 0.90 + headBaseY,
    );
    suitPath.lineTo(headBaseX - 10.0, -h * 0.87 + headBaseY); // Frente
    suitPath.lineTo(headBaseX - 12.2, -h * 0.855 + headBaseY); // Nariz
    suitPath.lineTo(headBaseX - 10.2, -h * 0.845 + headBaseY);
    suitPath.lineTo(headBaseX - 10.8, -h * 0.835 + headBaseY); // Labio superior
    suitPath.lineTo(headBaseX - 10.2, -h * 0.83 + headBaseY);
    suitPath.lineTo(headBaseX - 10.7, -h * 0.825 + headBaseY); // Labio inferior
    suitPath.lineTo(headBaseX - 10.8, -h * 0.81 + headBaseY); // Mentón marcado
    suitPath.cubicTo(
      headBaseX - 7.5,
      -h * 0.79 + headBaseY,
      headBaseX - 5.5,
      -h * 0.77 + headBaseY,
      headBaseX - 5.0,
      -h * 0.74 + headBaseY,
    );
    suitPath.cubicTo(
      headBaseX - 9.0,
      -h * 0.70 + headBaseY,
      headBaseX - 10.0,
      -h * 0.60 + headBaseY,
      headBaseX - 8.5,
      -h * 0.52 + headBaseY * 0.8,
    );
    suitPath.lineTo(-9.0 + spineTiltX * 0.4, -h * 0.42 + bendOffsetY * 0.5);
    suitPath.lineTo(11.0, -h * 0.42 + bendOffsetY * 0.5);
    suitPath.close();

    canvas.drawPath(suitPath, paint);

    // 3. BRAZOS CINEMÁTICOS ARTICULADOS
    final armPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.6
      ..strokeCap = StrokeCap.round
      ..maskFilter = paint.maskFilter;

    final shoulder = Offset(headBaseX - 2.5, -h * 0.72 + headBaseY);

    if (caressBabyProgress > 0.05) {
      // Mano acariciando la cabecita del bebé
      final babyHeadTarget = Offset(shoulder.dx + 26.0, shoulder.dy + 12.0);
      final elbow = Offset(shoulder.dx + 14.0, shoulder.dy + 8.0);
      final arm = Path()
        ..moveTo(shoulder.dx, shoulder.dy)
        ..quadraticBezierTo(
            elbow.dx, elbow.dy, babyHeadTarget.dx, babyHeadTarget.dy);
      canvas.drawPath(arm, armPaint);
      canvas.drawCircle(babyHeadTarget, 3.2, paint..style = PaintingStyle.fill);
    } else if (handOnChildShoulder > 0.05) {
      // Mano protectora en el hombro del niño
      final childShoulder = Offset(shoulder.dx + 24.0, shoulder.dy + 28.0);
      final elbow = Offset(shoulder.dx + 12.0, shoulder.dy + 18.0);
      final arm = Path()
        ..moveTo(shoulder.dx, shoulder.dy)
        ..quadraticBezierTo(
            elbow.dx, elbow.dy, childShoulder.dx, childShoulder.dy);
      canvas.drawPath(arm, armPaint);
      canvas.drawCircle(childShoulder, 3.2, paint..style = PaintingStyle.fill);
    } else if (bendToPickProgress > 0.05) {
      // Inclinándose a recoger flor
      final reachFloor = Offset(shoulder.dx + 22.0, -6.0);
      final elbow = Offset(shoulder.dx + 12.0, -h * 0.38 + bendOffsetY);
      final arm = Path()
        ..moveTo(shoulder.dx, shoulder.dy)
        ..quadraticBezierTo(elbow.dx, elbow.dy, reachFloor.dx, reachFloor.dy);
      canvas.drawPath(arm, armPaint);
      canvas.drawCircle(reachFloor, 3.2, paint..style = PaintingStyle.fill);
    } else if (offerRoseProgress > 0.01) {
      // Ofreciendo la rosa con brazo extendido
      final offerReach = offerRoseProgress * 32.0;
      final handPos = Offset(shoulder.dx + 18.0 + offerReach,
          shoulder.dy + 8.0 - (offerRoseProgress * 4.0));
      final elbow = Offset(
        (shoulder.dx + handPos.dx) * 0.5 + 2.0,
        (shoulder.dy + handPos.dy) * 0.5 + 6.0,
      );

      final arm = Path()
        ..moveTo(shoulder.dx, shoulder.dy)
        ..quadraticBezierTo(elbow.dx, elbow.dy, handPos.dx, handPos.dy);
      canvas.drawPath(arm, armPaint);
      canvas.drawCircle(handPos, 3.2, paint..style = PaintingStyle.fill);

      if (holdHandProgress > 0.05) {
        final handHoldPos =
            Offset(handPos.dx + (holdHandProgress * 12.0), handPos.dy + 6.0);
        final otherArm = Path()
          ..moveTo(shoulder.dx + 5.0, shoulder.dy + 4.0)
          ..quadraticBezierTo(
            (shoulder.dx + handHoldPos.dx) * 0.5,
            shoulder.dy + 16.0,
            handHoldPos.dx,
            handHoldPos.dy,
          );
        canvas.drawPath(otherArm, armPaint..strokeWidth = 4.0);
        canvas.drawCircle(handHoldPos, 3.0, paint);
      }
    } else {
      // Caminata o descanso
      final armSwing = walkCycle * 8.0;
      final handPos = Offset(
          shoulder.dx + 4.0 - armSwing, shoulder.dy + 26.0 - walkBobbing);
      final elbow =
          Offset(shoulder.dx + 2.0 - (armSwing * 0.5), shoulder.dy + 14.0);

      final arm = Path()
        ..moveTo(shoulder.dx, shoulder.dy)
        ..quadraticBezierTo(elbow.dx, elbow.dy, handPos.dx, handPos.dy);
      canvas.drawPath(arm, armPaint);
      canvas.drawCircle(handPos, 3.0, paint..style = PaintingStyle.fill);
    }

    canvas.restore();
  }

  /// Silueta de hijo/a según su etapa de crecimiento (niño pequeño, niño/a de 8-11 años o joven adulto)
  static void drawChildSilhouette({
    required Canvas canvas,
    required double x,
    required double groundY,
    required double
        heightScale, // 0.45 (niño pequeño ~4 años), 0.65 (niño/a 8-11 años), 0.90 (joven)
    required bool facingRight,
    required double walkCycle,
    required double
        wavingHand, // 0.0 a 1.0 (saludo de despedida al entrar a casa)
    required double touchingBelly, // 0.0 a 1.0 (acariciar vientre en escena 9)
    required Paint paint,
  }) {
    canvas.save();
    canvas.translate(x, groundY);
    if (!facingRight) {
      canvas.scale(-heightScale, heightScale);
    } else {
      canvas.scale(heightScale, heightScale);
    }

    const h = 130.0;
    final legSwing = walkCycle * 5.0;
    final walkBobbing = (walkCycle.abs()) * 2.0;

    // 1. Piernas infantiles/juveniles
    final legPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.2
      ..strokeCap = StrokeCap.round
      ..maskFilter = paint.maskFilter;

    canvas.drawLine(
      const Offset(3.0, -h * 0.44),
      Offset(4.5 + legSwing, -2.5),
      legPaint,
    );
    canvas.drawLine(
      const Offset(-3.0, -h * 0.44),
      Offset(-4.5 - legSwing, -2.5),
      legPaint,
    );

    // Zapatos
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(4.5 + legSwing + 2.0, -2.0), width: 10.0, height: 4.0),
      paint..style = PaintingStyle.fill,
    );
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(-4.5 - legSwing - 2.0, -2.0),
          width: 10.0,
          height: 4.0),
      paint,
    );

    // 2. Torso y cabeza infantil proporcionada
    final body = Path()
      ..moveTo(-7.0, -h * 0.42)
      ..lineTo(-8.5, -h * 0.72)
      ..lineTo(7.5, -h * 0.72)
      ..lineTo(6.5, -h * 0.42)
      ..close();
    canvas.drawPath(body, paint);

    // Cabeza con cabello redondeado natural
    const headCenter = Offset(0, -h * 0.88);
    canvas.drawCircle(headCenter, 11.5, paint);

    // 3. Brazos articulados
    final armPaint = Paint()
      ..color = paint.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.6
      ..strokeCap = StrokeCap.round
      ..maskFilter = paint.maskFilter;

    const shoulder = Offset(0.0, -h * 0.70);

    if (wavingHand > 0.05) {
      // Saludando con la manita en alto
      final waveReach = wavingHand * 16.0;
      final handTarget =
          Offset(shoulder.dx - 8.0, shoulder.dy - 18.0 - waveReach);
      final elbow = Offset(shoulder.dx - 12.0, shoulder.dy - 6.0);
      final arm = Path()
        ..moveTo(shoulder.dx, shoulder.dy)
        ..quadraticBezierTo(elbow.dx, elbow.dy, handTarget.dx, handTarget.dy);
      canvas.drawPath(arm, armPaint);
      canvas.drawCircle(handTarget, 2.8, paint..style = PaintingStyle.fill);
    } else if (touchingBelly > 0.05) {
      // Mano acariciando el vientre de la madre
      final bellyTarget = Offset(shoulder.dx + 26.0, shoulder.dy - 4.0);
      final elbow = Offset(shoulder.dx + 14.0, shoulder.dy + 6.0);
      final arm = Path()
        ..moveTo(shoulder.dx, shoulder.dy)
        ..quadraticBezierTo(elbow.dx, elbow.dy, bellyTarget.dx, bellyTarget.dy);
      canvas.drawPath(arm, armPaint);
      canvas.drawCircle(bellyTarget, 2.8, paint..style = PaintingStyle.fill);
    } else {
      // Movimiento natural al correr o caminar
      final armSwing = walkCycle * 8.0;
      final handTarget = Offset(
          shoulder.dx + 4.0 - armSwing, shoulder.dy + 22.0 - walkBobbing);
      final elbow = Offset(shoulder.dx + 2.0, shoulder.dy + 12.0);
      final arm = Path()
        ..moveTo(shoulder.dx, shoulder.dy)
        ..quadraticBezierTo(elbow.dx, elbow.dy, handTarget.dx, handTarget.dy);
      canvas.drawPath(arm, armPaint);
      canvas.drawCircle(handTarget, 2.6, paint..style = PaintingStyle.fill);
    }

    canvas.restore();
  }
}
