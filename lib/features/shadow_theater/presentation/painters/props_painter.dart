import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Dibuja los elementos de utilería interactivos (props) de las 14 Escenas:
/// flor silvestre, rosa, casa sencilla, bebé en mantilla, manta de picnic y luna.
class PropsPainter {
  PropsPainter._();

  /// Dibuja un pétalo cayendo con física de balanceo pendular por viento y gravedad
  static void drawFallingPetal({
    required Canvas canvas,
    required Offset startPos,
    required double groundY,
    required double elapsedSinceDetach,
    required double fallDuration,
    required double horizontalDrift,
    required Paint paint,
  }) {
    if (elapsedSinceDetach <= 0.0) return;

    final progress = (elapsedSinceDetach / fallDuration).clamp(0.0, 1.0);
    final curve = Curves.easeInQuad.transform(progress);

    // Oscilación pendular de la hoja al descender
    final sway =
        math.sin(progress * math.pi * 5.0) * (14.0 * (1.0 - progress * 0.3));
    final x = startPos.dx + (horizontalDrift * progress) + sway;
    final y = startPos.dy + ((groundY - startPos.dy) * curve);
    final rotation = sway * 0.08 + (progress * 1.2);

    canvas.save();
    canvas.translate(x, y);
    canvas.rotate(rotation);

    final petalPath = Path()
      ..moveTo(0, -4.5)
      ..quadraticBezierTo(3.5, 0, 0, 4.5)
      ..quadraticBezierTo(-3.5, 0, 0, -4.5)
      ..close();

    canvas.drawPath(petalPath, paint);
    canvas.restore();
  }

  /// Dibuja la flor silvestre en el prado (antes de ser recogida por Ella en t=13.5s)
  static void drawWildFlowerOnGround({
    required Canvas canvas,
    required double x,
    required double groundY,
    required double swayAngle,
    required Paint paint,
  }) {
    canvas.save();
    canvas.translate(x, groundY);
    canvas.rotate(swayAngle * 0.5);

    // Tallo con curva suave
    final stem = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(-2.0, -14.0, 1.0, -28.0);

    canvas.drawPath(
      stem,
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    // Pequeñas hojas del tallo
    final leaf1 = Path()
      ..moveTo(-1.0, -10.0)
      ..quadraticBezierTo(-6.0, -12.0, -9.0, -10.0)
      ..quadraticBezierTo(-5.0, -8.0, -1.0, -10.0);
    canvas.drawPath(leaf1, paint..style = PaintingStyle.fill);

    // Flor con 4 pétalos
    const flowerCenter = Offset(1.0, -28.0);
    canvas.drawCircle(flowerCenter, 2.5, paint);

    for (int i = 0; i < 4; i++) {
      final angle = (i * math.pi / 2.0) + (math.pi / 4.0);
      final px = flowerCenter.dx + math.cos(angle) * 4.5;
      final py = flowerCenter.dy + math.sin(angle) * 4.5;

      final petal = Path()
        ..moveTo(flowerCenter.dx, flowerCenter.dy)
        ..quadraticBezierTo(px + 2.0, py, px, py)
        ..quadraticBezierTo(px - 2.0, py, flowerCenter.dx, flowerCenter.dy);
      canvas.drawPath(petal, paint);
    }

    canvas.restore();
  }

  /// Dibuja la rosa en el césped cerca del árbol derecho (antes de ser cortada por Él en t=38.0s)
  static void drawRoseOnGround({
    required Canvas canvas,
    required double x,
    required double groundY,
    required double swayAngle,
    required Paint paint,
  }) {
    canvas.save();
    canvas.translate(x, groundY);
    canvas.rotate(swayAngle * 0.3);

    // Tallo espinoso
    final stem = Path()
      ..moveTo(0, 0)
      ..quadraticBezierTo(3.0, -15.0, -2.0, -32.0);

    canvas.drawPath(
      stem,
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );

    // Espinas
    canvas.drawLine(const Offset(1.5, -8.0), const Offset(4.5, -10.0),
        paint..strokeWidth = 1.2);
    canvas.drawLine(const Offset(2.0, -18.0), const Offset(5.0, -20.0), paint);

    // Capullo de rosa estilizado
    const budCenter = Offset(-2.0, -32.0);
    final roseBud = Path()
      ..moveTo(budCenter.dx, budCenter.dy + 3.0)
      ..cubicTo(budCenter.dx - 6.0, budCenter.dy - 1.0, budCenter.dx - 5.0,
          budCenter.dy - 10.0, budCenter.dx, budCenter.dy - 11.0)
      ..cubicTo(budCenter.dx + 5.0, budCenter.dy - 10.0, budCenter.dx + 6.0,
          budCenter.dy - 1.0, budCenter.dx, budCenter.dy + 3.0)
      ..close();

    canvas.drawPath(roseBud, paint..style = PaintingStyle.fill);

    // Pétalo envolvente
    final outerPetal = Path()
      ..moveTo(budCenter.dx - 4.0, budCenter.dy - 3.0)
      ..quadraticBezierTo(budCenter.dx - 7.0, budCenter.dy - 8.0,
          budCenter.dx - 2.0, budCenter.dy - 12.0)
      ..quadraticBezierTo(budCenter.dx + 1.0, budCenter.dy - 7.0,
          budCenter.dx - 4.0, budCenter.dy - 3.0);
    canvas.drawPath(outerPetal, paint);

    canvas.restore();
  }

  /// Dibuja la rosa sostenida o en tránsito
  static void drawHeldRose({
    required Canvas canvas,
    required Offset handPos,
    required double angle,
    required Paint paint,
  }) {
    canvas.save();
    canvas.translate(handPos.dx, handPos.dy);
    canvas.rotate(angle);

    // Tallo
    canvas.drawLine(
      const Offset(0, 10.0),
      const Offset(0, -18.0),
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    // Capullo
    final roseBud = Path()
      ..moveTo(0, -16.0)
      ..cubicTo(-5.0, -19.0, -4.5, -27.0, 0, -28.0)
      ..cubicTo(4.5, -27.0, 5.0, -19.0, 0, -16.0)
      ..close();

    canvas.drawPath(roseBud, paint..style = PaintingStyle.fill);
    canvas.restore();
  }

  /// Dibuja la casa sencilla bajo los árboles (Escenas 6 a 14)
  static void drawHouseSilhouette({
    required Canvas canvas,
    required double centerX,
    required double groundY,
    required double scale,
    required double opacity,
    required Paint shadowPaint,
  }) {
    if (opacity <= 0.01) return;

    canvas.save();
    canvas.translate(centerX, groundY);
    canvas.scale(scale, scale);

    final housePaint = Paint()
      ..color = shadowPaint.color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill
      ..maskFilter = shadowPaint.maskFilter;

    const houseW = 108.0;
    const houseH = 78.0;
    const roofH = 46.0;

    // 1. Cuerpo principal de la casa
    final walls = Path()
      ..moveTo(-houseW * 0.5, 0)
      ..lineTo(-houseW * 0.5, -houseH)
      ..lineTo(houseW * 0.5, -houseH)
      ..lineTo(houseW * 0.5, 0)
      ..close();
    canvas.drawPath(walls, housePaint);

    // 2. Chimenea en el tejado
    final chimney = Path()
      ..moveTo(houseW * 0.22, -houseH - 12.0)
      ..lineTo(houseW * 0.22, -houseH - roofH - 14.0)
      ..lineTo(houseW * 0.34, -houseH - roofH - 14.0)
      ..lineTo(houseW * 0.34, -houseH - 2.0)
      ..close();
    canvas.drawPath(chimney, housePaint);

    // 3. Tejado a dos aguas
    final roof = Path()
      ..moveTo(-houseW * 0.58, -houseH + 4.0)
      ..lineTo(0, -houseH - roofH)
      ..lineTo(houseW * 0.58, -houseH + 4.0)
      ..close();
    canvas.drawPath(roof, housePaint);

    // 4. Puerta sencilla
    final door = Path()
      ..moveTo(-12.0, 0)
      ..lineTo(-12.0, -42.0)
      ..quadraticBezierTo(0, -48.0, 12.0, -42.0)
      ..lineTo(12.0, 0)
      ..close();

    // Recorte de luz o silueta de la puerta
    canvas.drawPath(
      door,
      Paint()
        ..color = const Color(0xFF040305).withValues(alpha: opacity)
        ..style = PaintingStyle.fill,
    );

    // 5. Ventana iluminada con luz cálida interna difusa
    const winRect = Rect.fromLTWH(houseW * 0.16, -houseH * 0.72, 22.0, 24.0);
    final winGlow = Paint()
      ..color = const Color(0xFFFFE3A3).withValues(alpha: 0.65 * opacity)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
        RRect.fromRectAndRadius(winRect, const Radius.circular(3.0)), winGlow);

    // Cruceta de la ventana
    final framePaint = Paint()
      ..color = shadowPaint.color.withValues(alpha: opacity)
      ..strokeWidth = 1.8
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(winRect.left + winRect.width * 0.5, winRect.top),
      Offset(winRect.left + winRect.width * 0.5, winRect.bottom),
      framePaint,
    );
    canvas.drawLine(
      Offset(winRect.left, winRect.top + winRect.height * 0.5),
      Offset(winRect.right, winRect.top + winRect.height * 0.5),
      framePaint,
    );

    // 6. Maceta con flor junto a la puerta
    final pot = Path()
      ..moveTo(-26.0, 0)
      ..lineTo(-29.0, -10.0)
      ..lineTo(-18.0, -10.0)
      ..lineTo(-21.0, 0)
      ..close();
    canvas.drawPath(pot, housePaint);

    // Brote floral en la maceta
    canvas.drawCircle(const Offset(-23.5, -15.0), 3.5, housePaint);

    canvas.restore();
  }

  /// Dibuja a un recién nacido envuelto en mantilla
  static void drawBabySwaddle({
    required Canvas canvas,
    required Offset position,
    required double scale,
    required double angle,
    required Paint paint,
  }) {
    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(angle);
    canvas.scale(scale, scale);

    // Cuerpo envuelto en mantilla
    final swaddle = Path()
      ..moveTo(0, 0)
      ..cubicTo(-6.0, -8.0, -10.0, -18.0, -4.0, -26.0)
      ..cubicTo(0, -32.0, 10.0, -32.0, 12.0, -26.0)
      ..cubicTo(16.0, -16.0, 10.0, -6.0, 0, 0)
      ..close();
    canvas.drawPath(swaddle, paint);

    // Cabecita asomando
    canvas.drawCircle(const Offset(4.0, -27.0), 5.5, paint);

    canvas.restore();
  }

  /// Dibuja la manta de picnic y la cesta (Escena 13)
  static void drawPicnicMatAndBasket({
    required Canvas canvas,
    required double centerX,
    required double groundY,
    required double scale,
    required double opacity,
    required Paint shadowPaint,
  }) {
    if (opacity <= 0.01) return;

    canvas.save();
    canvas.translate(centerX, groundY);
    canvas.scale(scale, scale);

    final pPaint = Paint()
      ..color = shadowPaint.color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill
      ..maskFilter = shadowPaint.maskFilter;

    // Manta extendida con bordes ligeramente ondulados
    final mat = Path()
      ..moveTo(-58.0, -1.0)
      ..quadraticBezierTo(-20.0, -4.0, 0, -3.0)
      ..quadraticBezierTo(25.0, -4.0, 62.0, -1.0)
      ..lineTo(56.0, 0)
      ..lineTo(-52.0, 0)
      ..close();
    canvas.drawPath(mat, pPaint);

    // Cesta de mimbre silueteada
    const basketRect = Rect.fromLTWH(26.0, -16.0, 18.0, 14.0);
    final basket = Path()
      ..moveTo(basketRect.left, basketRect.bottom)
      ..lineTo(basketRect.left - 2.0, basketRect.top)
      ..lineTo(basketRect.right + 2.0, basketRect.top)
      ..lineTo(basketRect.right, basketRect.bottom)
      ..close();
    canvas.drawPath(basket, pPaint);

    // Asa de la cesta
    final handle = Path()
      ..moveTo(basketRect.left + 2.0, basketRect.top)
      ..quadraticBezierTo(basketRect.center.dx, basketRect.top - 12.0,
          basketRect.right - 2.0, basketRect.top);
    canvas.drawPath(
      handle,
      Paint()
        ..color = shadowPaint.color.withValues(alpha: opacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round,
    );

    canvas.restore();
  }

  /// Dibuja la luna en el cielo (Escena 14: sol ya oculto)
  static void drawMoon({
    required Canvas canvas,
    required double cx,
    required double cy,
    required double radius,
    required double intensity,
  }) {
    if (intensity <= 0.01) return;

    // Aura difusa de la luna en la pantalla de tela
    final moonGlow = Paint()
      ..color = const Color(0xFFFFF7E2).withValues(alpha: 0.35 * intensity)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 22.0);
    canvas.drawCircle(Offset(cx, cy), radius * 1.8, moonGlow);

    // Silueta creciente de luna recortada poética
    final moonDisc = Path()
      ..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: radius));

    final cutDisc = Path()
      ..addOval(Rect.fromCircle(
          center: Offset(cx + radius * 0.45, cy - radius * 0.25),
          radius: radius * 0.88));

    final crescent = Path.combine(PathOperation.difference, moonDisc, cutDisc);

    final moonPaint = Paint()
      ..color = const Color(0xFFFFF9EE).withValues(alpha: 0.95 * intensity)
      ..style = PaintingStyle.fill;
    canvas.drawPath(crescent, moonPaint);
  }

  /// Dibuja un rótulo narrativo breve y exacto («8 años después», «11 años después», «4 años después»)
  static void drawSceneCaption({
    required Canvas canvas,
    required String text,
    required double screenW,
    required double topY,
    required double opacity,
  }) {
    if (opacity <= 0.01) return;

    final textSpan = TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: 'Cinzel',
        fontSize: 16.0,
        fontWeight: FontWeight.w400,
        letterSpacing: 3.5,
        color: const Color(0xFFDFBA8F).withValues(alpha: opacity),
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.9 * opacity),
            blurRadius: 14.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: screenW);

    final x = (screenW - textPainter.width) * 0.5;
    textPainter.paint(canvas, Offset(x, topY));
  }
}
