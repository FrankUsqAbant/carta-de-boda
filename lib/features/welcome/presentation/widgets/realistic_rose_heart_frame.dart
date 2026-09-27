import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Modelo de datos para cada flor o elemento botánico individual en la orla de corazón
class _RoseHeartElement {
  final double t; // Parámetro angular t en [0, 2*pi]
  final String asset;
  final double sizeFactor;
  final double angleOffset;
  final double depth; // 0.0 = más en sombra/profundidad, 1.0 = más iluminada
  final double breathPhase;

  const _RoseHeartElement({
    required this.t,
    required this.asset,
    required this.sizeFactor,
    required this.angleOffset,
    this.depth = 0.5,
    this.breathPhase = 0.0,
  });
}

/// Marco floral cinematográfico en forma de corazón:
/// - Construido con rosas rojas profundas y blancas marfil de apariencia fotográfica real.
/// - Geometría de cardioide abierta calculada para enmarcar el contenido sin tapar jamás
///   el título, nombres «Estefania & Darlin», fecha, dedicatoria ni el botón.
/// - Adaptable a formatos verticales móviles (Android, iPhone y Web móvil).
/// - Animación sutil de respiración ambiental que da vida al fondo sin distraer.
class RealisticRoseHeartFrame extends StatefulWidget {
  final Widget child;
  final VoidCallback? onRosePressed;

  const RealisticRoseHeartFrame({
    super.key,
    required this.child,
    this.onRosePressed,
  });

  @override
  State<RealisticRoseHeartFrame> createState() =>
      _RealisticRoseHeartFrameState();
}

class _RealisticRoseHeartFrameState extends State<RealisticRoseHeartFrame>
    with SingleTickerProviderStateMixin {
  late final AnimationController _breathController;

  // 18 elementos botánicos distribuidos en el perímetro exacto del corazón
  // Alternando rosas rojas, blancas marfil y toques de follaje botánico
  static final List<_RoseHeartElement> _roseElements = [
    // 1. Cúspide superior (escotadura suave, coronando arriba)
    const _RoseHeartElement(
      t: 0.0,
      asset: 'assets/images/roses/rose_red_bud.png',
      sizeFactor: 0.88,
      angleOffset: 0.0,
      depth: 0.5,
      breathPhase: 0.0,
    ),
    // 2. Lóbulo superior derecho ascendente
    const _RoseHeartElement(
      t: 0.35,
      asset: 'assets/images/roses/foliage_sprig.png',
      sizeFactor: 0.85,
      angleOffset: 0.2,
      depth: 0.45,
      breathPhase: 0.4,
    ),
    const _RoseHeartElement(
      t: 0.70,
      asset: 'assets/images/roses/rose_white_1.png',
      sizeFactor: 1.08,
      angleOffset: -0.15,
      depth: 0.95,
      breathPhase: 0.8,
    ),
    // 3. Cima del lóbulo derecho
    const _RoseHeartElement(
      t: 1.05,
      asset: 'assets/images/roses/rose_red_1.png',
      sizeFactor: 1.15,
      angleOffset: 0.25,
      depth: 1.0,
      breathPhase: 1.2,
    ),
    // 4. Lado derecho exterior
    const _RoseHeartElement(
      t: 1.40,
      asset: 'assets/images/roses/foliage_sprig.png',
      sizeFactor: 0.90,
      angleOffset: -0.2,
      depth: 0.6,
      breathPhase: 1.6,
    ),
    const _RoseHeartElement(
      t: 1.75,
      asset: 'assets/images/roses/rose_white_2.png',
      sizeFactor: 1.12,
      angleOffset: 0.3,
      depth: 0.9,
      breathPhase: 2.0,
    ),
    // 5. Curva derecha descendente
    const _RoseHeartElement(
      t: 2.10,
      asset: 'assets/images/roses/rose_red_2.png',
      sizeFactor: 1.08,
      angleOffset: -0.15,
      depth: 0.85,
      breathPhase: 2.4,
    ),
    const _RoseHeartElement(
      t: 2.45,
      asset: 'assets/images/roses/foliage_sprig.png',
      sizeFactor: 0.85,
      angleOffset: 0.25,
      depth: 0.55,
      breathPhase: 2.8,
    ),
    const _RoseHeartElement(
      t: 2.80,
      asset: 'assets/images/roses/rose_white_1.png',
      sizeFactor: 1.0,
      angleOffset: -0.1,
      depth: 0.8,
      breathPhase: 3.2,
    ),

    // 7. Curva izquierda ascendente
    const _RoseHeartElement(
      t: 3.49,
      asset: 'assets/images/roses/rose_red_bud.png',
      sizeFactor: 0.90,
      angleOffset: 0.15,
      depth: 0.7,
      breathPhase: 4.0,
    ),
    const _RoseHeartElement(
      t: 3.84,
      asset: 'assets/images/roses/foliage_sprig.png',
      sizeFactor: 0.85,
      angleOffset: -0.2,
      depth: 0.5,
      breathPhase: 4.4,
    ),
    const _RoseHeartElement(
      t: 4.19,
      asset: 'assets/images/roses/rose_white_2.png',
      sizeFactor: 1.08,
      angleOffset: 0.2,
      depth: 0.85,
      breathPhase: 4.8,
    ),
    // 8. Lado izquierdo exterior
    const _RoseHeartElement(
      t: 4.54,
      asset: 'assets/images/roses/rose_red_2.png',
      sizeFactor: 1.12,
      angleOffset: -0.25,
      depth: 0.95,
      breathPhase: 5.2,
    ),
    const _RoseHeartElement(
      t: 4.89,
      asset: 'assets/images/roses/foliage_sprig.png',
      sizeFactor: 0.90,
      angleOffset: 0.15,
      depth: 0.6,
      breathPhase: 5.6,
    ),
    // 9. Cima del lóbulo izquierdo
    const _RoseHeartElement(
      t: 5.24,
      asset: 'assets/images/roses/rose_white_1.png',
      sizeFactor: 1.15,
      angleOffset: -0.2,
      depth: 1.0,
      breathPhase: 6.0,
    ),
    const _RoseHeartElement(
      t: 5.59,
      asset: 'assets/images/roses/rose_red_1.png',
      sizeFactor: 1.08,
      angleOffset: 0.15,
      depth: 0.9,
      breathPhase: 0.3,
    ),
    // 10. Lóbulo superior izquierdo descendente hacia la escotadura
    const _RoseHeartElement(
      t: 5.94,
      asset: 'assets/images/roses/foliage_sprig.png',
      sizeFactor: 0.85,
      angleOffset: -0.15,
      depth: 0.45,
      breathPhase: 0.7,
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Ciclo de respiración lenta y sutil de 6 segundos
    _breathController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );

    final isTestEnvironment =
        WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!isTestEnvironment) {
      _breathController.repeat(reverse: true);
    } else {
      _breathController.value = 0.5;
    }
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  /// Calcula la posición normalizada (x, y) de la silueta de corazón botánico
  /// t en radianes [0, 2*pi].
  /// Retorna Offset normalizado donde:
  /// - t = 0: Escotadura superior centrada
  /// - t = pi/2: Lado derecho
  /// - t = pi: Punta inferior del corazón
  /// - t = 3*pi/2: Lado izquierdo
  Offset _heartParametric(double t) {
    final double sinT = math.sin(t);
    final double cosT = math.cos(t);

    // Ecuación clásica de cardioide
    final double x = 16.0 * sinT * sinT * sinT;
    final double rawY = -(13.0 * cosT -
        5.0 * math.cos(2.0 * t) -
        2.0 * math.cos(3.0 * t) -
        math.cos(4.0 * t));

    final double nx = x / 16.0;
    final double ny = rawY / 17.0;

    // Suavizado de la escotadura superior para que corone con elegancia
    // por encima del encabezado sin descender hacia el centro del texto
    final double distToTopNotch = math.min(t, (2.0 * math.pi) - t);
    final double notchFactor =
        math.exp(-(distToTopNotch * distToTopNotch) / 0.42);
    final double nyElevated = ny - (0.36 * notchFactor);

    // Ensanchamiento lateral suave en la franja media para dejar la dedicatoria
    // y los nombres en un marco amplio y despejado sin colisiones en móvil
    final double midFlare =
        (nyElevated > -0.35 && nyElevated < 0.72) ? 1.34 : 1.0;
    final double finalNx = nx * midFlare;

    return Offset(finalNx, nyElevated);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;

        final isCompact = screenWidth < 380 || screenHeight < 680;

        // Radios calibrados para que el marco rodee completamente la composición:
        // El radio X abarca ampliamente los laterales para no tocar los nombres ni la dedicatoria
        // El radio Y abarca holgadamente desde arriba del título hasta debajo del botón
        final double radiusX = (screenWidth * 0.46).clamp(162.0, 235.0);
        final double radiusY = (screenHeight * 0.47).clamp(270.0, 385.0);

        // Centro vertical ligeramente ponderado para balancear con el botón
        final double centerX = screenWidth / 2.0;
        final double centerY = screenHeight * 0.465;

        // Tamaño base de las rosas optimizado para no saturar la pantalla
        final double baseRoseSize = isCompact ? 50.0 : 60.0;

        return Stack(
          fit: StackFit.expand,
          children: [
            // 1. RESPLANDOR AMBIENTAL DE FONDO CON RESPIRACIÓN SUAVE NUPCIAL
            AnimatedBuilder(
              animation: _breathController,
              builder: (context, _) {
                final breath = math.sin(_breathController.value * math.pi);
                final glowIntensity = 0.25 + (0.15 * breath);

                return Positioned(
                  left: centerX - radiusX * 1.15,
                  top: centerY - radiusY * 0.95,
                  width: radiusX * 2.3,
                  height: radiusY * 2.0,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFDFBA8F)
                                .withValues(alpha: glowIntensity * 0.65),
                            blurRadius: 90.0,
                            spreadRadius: 20.0,
                          ),
                          BoxShadow(
                            color: const Color(0xFFF3DEC8)
                                .withValues(alpha: 0.35),
                            blurRadius: 110.0,
                            spreadRadius: 25.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),

            // 2. CORONA FLORAL DE ROSAS Y FOLLAJE EN FORMA DE CORAZÓN
            AnimatedBuilder(
              animation: _breathController,
              builder: (context, _) {
                final breathVal = _breathController.value;

                return Stack(
                  fit: StackFit.expand,
                  children: _roseElements.map((elem) {
                    final normPos = _heartParametric(elem.t);

                    // Micro-desplazamiento de respiración orgánico e independiente por flor
                    final elemBreath = math
                        .sin((breathVal * 2.0 * math.pi) + elem.breathPhase);
                    final floatOffset = elemBreath * 1.5;
                    final scaleMod = 1.0 + (elemBreath * 0.018);

                    final posX = centerX + (normPos.dx * radiusX);
                    final posY = centerY + (normPos.dy * radiusY) + floatOffset;

                    final flowerSize =
                        baseRoseSize * elem.sizeFactor * scaleMod;

                    // Ángulo orgánico natural de colocación floral
                    final rotation =
                        (elem.t - (math.pi / 2.0)) * 0.35 + elem.angleOffset;



                    return Positioned(
                      left: posX - (flowerSize / 2.0),
                      top: posY - (flowerSize / 2.0),
                      width: flowerSize,
                      height: flowerSize,
                      child: IgnorePointer(
                        child: Transform.rotate(
                          angle: rotation,
                          child: Opacity(
                            opacity: (0.76 + (0.12 * elem.depth)).clamp(0.68, 0.86),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF6B4E3D).withValues(
                                      alpha: (0.18 * elem.depth).clamp(0.0, 0.28),
                                    ),
                                    blurRadius: 9.0,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Image.asset(
                                elem.asset,
                                cacheWidth: (flowerSize * 2.0).round().clamp(100, 240),
                                cacheHeight: (flowerSize * 2.0).round().clamp(100, 240),
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.low,
                                errorBuilder: (context, error, stackTrace) {
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),

            // 3. VELO TRANSLÚCIDO SUAVE PARA ENFOCAR EL TEXTO EN EL CENTRO
            Positioned(
              left: centerX - (radiusX * 0.78),
              top: centerY - (radiusY * 0.82),
              width: radiusX * 1.56,
              height: radiusY * 1.64,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.60),
                        const Color(0xFFFAF5EC).withValues(alpha: 0.30),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.65, 1.0],
                    ),
                  ),
                ),
              ),
            ),

            // 4. CONTENIDO PRINCIPAL (Nombres, Fecha, Dedicatoria)
            widget.child,

            // 5. BOTÓN EN FORMA DE ROSA (Vértice inferior del corazón)
            AnimatedBuilder(
              animation: _breathController,
              builder: (context, _) {
                final breathVal = _breathController.value;
                final elemBreath =
                    math.sin((breathVal * 2.0 * math.pi) + 3.6);
                final floatOffset = elemBreath * 1.5;

                final normPos = _heartParametric(math.pi);
                final posX = centerX + (normPos.dx * radiusX);
                final posY = centerY + (normPos.dy * radiusY) + floatOffset;
                final flowerSize = baseRoseSize * 1.28;

                return Positioned(
                  left: posX - (flowerSize / 2.0),
                  top: posY - (flowerSize / 2.0),
                  width: flowerSize,
                  height: flowerSize,
                  child: _InteractiveRoseButton(
                    key: const Key('start_story_rose_button'),
                    asset: 'assets/images/roses/rose_red_1.png',
                    size: flowerSize,
                    onPressed: widget.onRosePressed,
                    breathVal: breathVal,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

/// Botón interactivo con forma de la rosa original del vértice inferior:
/// - Mantiene intacta la apariencia visual de la rosa roja real.
/// - Incorpora micro-animación de respiración orgánica sincronizada.
/// - Reacciona al cursor/toque con halo dorado envolvente y escala táctil.
class _InteractiveRoseButton extends StatefulWidget {
  final String asset;
  final double size;
  final VoidCallback? onPressed;
  final double breathVal;

  const _InteractiveRoseButton({
    super.key,
    required this.asset,
    required this.size,
    required this.onPressed,
    required this.breathVal,
  });

  @override
  State<_InteractiveRoseButton> createState() => _InteractiveRoseButtonState();
}

class _InteractiveRoseButtonState extends State<_InteractiveRoseButton> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final breath = math.sin((widget.breathVal * 2.0 * math.pi) + 3.6);
    final breathScale = 1.0 + (breath * 0.022);
    final hoverScale = _isHovered ? 1.08 : 1.0;
    final pressScale = _isPressed ? 0.93 : 1.0;
    final totalScale = breathScale * hoverScale * pressScale;

    // Resplandor cálido dorado que se intensifica al acercar el dedo o ratón
    final glowAlpha = _isHovered
        ? 0.70
        : (0.35 + (0.22 * math.max(0.0, breath)));

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: totalScale,
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Halo dorado cálido interactivo
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: widget.size * 0.90,
                  height: widget.size * 0.90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFDFBA8F)
                            .withValues(alpha: glowAlpha),
                        blurRadius: _isHovered ? 30.0 : 18.0,
                        spreadRadius: _isHovered ? 6.0 : 2.5,
                      ),
                      BoxShadow(
                        color: const Color(0xFF8B1A2B)
                            .withValues(alpha: 0.50),
                        blurRadius: 16.0,
                        spreadRadius: 2.0,
                      ),
                    ],
                  ),
                ),

                // Rosa fotográfica original sin modificar con delicada suavidad nupcial
                Opacity(
                  opacity: 0.92,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6B4E3D).withValues(alpha: 0.28),
                          blurRadius: 12.0,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      widget.asset,
                      cacheWidth: (widget.size * 2.0).round().clamp(120, 260),
                      cacheHeight: (widget.size * 2.0).round().clamp(120, 260),
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.low,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
