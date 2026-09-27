import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// Botón interactivo de alta gama basado en los principios de ingeniería de diseño
/// de Emil Kowalski:
/// - Feedback táctil inmediato (escala 0.965 en 120ms con `easeOutCubic`).
/// - Elevación suave e incremento de resplandor perimetral en hover (1.025).
/// - Bisel de iluminación superior de 1px simulando reflejo de estudio.
/// - Micro-animación de traslación en el icono indicador.
/// - Respuesta háptica táctil en dispositivos móviles.
class EmilPremiumButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? trailingIcon;
  final EdgeInsetsGeometry padding;

  const EmilPremiumButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.trailingIcon = Icons.arrow_forward_ios_rounded,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 36.0,
      vertical: 18.0,
    ),
  });

  @override
  State<EmilPremiumButton> createState() => _EmilPremiumButtonState();
}

class _EmilPremiumButtonState extends State<EmilPremiumButton>
    with TickerProviderStateMixin {
  late final AnimationController _pressController;
  late final AnimationController _hoverController;

  late final Animation<double> _pressScale;
  late final Animation<double> _hoverScale;
  late final Animation<double> _hoverGlow;
  late final Animation<double> _iconShift;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    // 1. Controlador de presión táctil (120ms según estándar de Emil)
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _pressScale = Tween<double>(begin: 1.0, end: 0.965).animate(
      CurvedAnimation(
        parent: _pressController,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeOutBack,
      ),
    );

    // 2. Controlador de hover (220ms para transición fluida en web/desktop)
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _hoverScale = Tween<double>(begin: 1.0, end: 1.025).animate(
      CurvedAnimation(
        parent: _hoverController,
        curve: Curves.easeOutCubic,
      ),
    );
    _hoverGlow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _hoverController,
        curve: Curves.easeOut,
      ),
    );
    _iconShift = Tween<double>(begin: 0.0, end: 4.0).animate(
      CurvedAnimation(
        parent: _hoverController,
        curve: Curves.easeOutCubic,
      ),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails _) {
    HapticFeedback.lightImpact();
    _pressController.forward();
  }

  void _handleTapUp(TapUpDetails _) {
    _pressController.reverse();
  }

  void _handleTapCancel() {
    _pressController.reverse();
  }

  void _handleTap() {
    widget.onPressed();
  }

  void _handleHover(bool hovering) {
    if (_isHovered == hovering) return;
    setState(() => _isHovered = hovering);
    if (hovering) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _handleTap,
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: AnimatedBuilder(
          animation: Listenable.merge([_pressController, _hoverController]),
          builder: (context, child) {
            // Escala combinada: Base * HoverScale * PressScale
            final currentScale = _hoverScale.value * _pressScale.value;
            final glowAmount = _hoverGlow.value;

            return Transform.scale(
              scale: currentScale,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(44.0),
                  // Sombras dinámicas multicapa con resplandor dorado expansivo
                  boxShadow: [
                    // Sombra ambiental base
                    BoxShadow(
                      color:
                          AppColors.backgroundVignette.withValues(alpha: 0.6),
                      blurRadius: 16.0,
                      offset: const Offset(0, 8),
                    ),
                    // Halo de luz dorada reactiva a hover
                    BoxShadow(
                      color: AppColors.buttonGlow.withValues(
                        alpha: (0.25 + (0.35 * glowAmount)).clamp(0.0, 1.0),
                      ),
                      blurRadius: 24.0 + (12.0 * glowAmount),
                      spreadRadius: 1.0 + (2.0 * glowAmount),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(44.0),
                  child: Container(
                    padding: widget.padding,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(44.0),
                      // Superficie con micro-gradiente translúcido
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color.lerp(
                            const Color(0x35FFFFFF),
                            const Color(0x45FFFFFF),
                            glowAmount,
                          )!,
                          Color.lerp(
                            const Color(0x18FFFFFF),
                            const Color(0x22FFFFFF),
                            glowAmount,
                          )!,
                        ],
                      ),
                      // Doble borde con bisel superior de luz (simulación de estudio)
                      border: Border.all(
                        color: Color.lerp(
                          AppColors.buttonBorder.withValues(alpha: 0.5),
                          AppColors.textAccent.withValues(alpha: 0.9),
                          glowAmount,
                        )!,
                        width: 1.2,
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Micro-reflejo de bisel superior de luz (1px)
                        Positioned(
                          top: 0,
                          left: 20,
                          right: 20,
                          height: 1.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  AppColors.textHero.withValues(
                                    alpha: (0.4 + (0.4 * glowAmount))
                                        .clamp(0.0, 1.0),
                                  ),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Contenido del botón
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.text,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: AppColors.buttonText,
                                  letterSpacing: 1.8,
                                  fontWeight: FontWeight.w500,
                                  shadows: [
                                    Shadow(
                                      color:
                                          AppColors.ambientGlowGold.withValues(
                                        alpha: (0.2 + (0.4 * glowAmount))
                                            .clamp(0.0, 1.0),
                                      ),
                                      blurRadius: 12.0,
                                    ),
                                  ],
                                ),
                              ),
                              if (widget.trailingIcon != null) ...[
                                const SizedBox(width: 12.0),
                                Transform.translate(
                                  offset: Offset(_iconShift.value, 0.0),
                                  child: Icon(
                                    widget.trailingIcon,
                                    size: 14.0,
                                    color: Color.lerp(
                                      AppColors.textAccent,
                                      AppColors.textHero,
                                      glowAmount,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
