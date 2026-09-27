import 'package:flutter/material.dart';
import '../../../../shared/constants/app_strings.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/emil_premium_button.dart';

/// Telón de clausura conmemorativo y emotivo del Teatro de Sombras:
/// Se activa al concluir el Acto 14 («Bajo la luna») tras el fundido a negro final.
/// Presenta la dedicatoria eterna para Estefania & Darlin con opciones para revivir la obra o volver.
class TheaterClosingCurtain extends StatefulWidget {
  final VoidCallback onReplay;
  final VoidCallback onReturnToLetter;

  const TheaterClosingCurtain({
    super.key,
    required this.onReplay,
    required this.onReturnToLetter,
  });

  @override
  State<TheaterClosingCurtain> createState() => _TheaterClosingCurtainState();
}

class _TheaterClosingCurtainState extends State<TheaterClosingCurtain>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final isCompact = size.width < 380 || size.height < 680;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            color: Color(0xFF000000),
            gradient: RadialGradient(
              center: Alignment(0.0, -0.10),
              radius: 1.15,
              colors: [
                Color(0xFF22161A), // Resplandor cálido central
                Color(0xFF120C11),
                Color(0xFF060406),
                Color(0xFF000000),
              ],
              stops: [0.0, 0.38, 0.75, 1.0],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 24.0 : 36.0,
                  vertical: 24.0,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Corona floral superior sutil
                      Image.asset(
                        'assets/images/roses/rose_red_bud.png',
                        width: isCompact ? 54.0 : 68.0,
                        height: isCompact ? 54.0 : 68.0,
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: isCompact ? 14.0 : 20.0),

                      // Epílogo de la historia
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 5.0,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            color: AppColors.textAccent.withValues(alpha: 0.30),
                            width: 0.8,
                          ),
                          color: Colors.white.withValues(alpha: 0.02),
                        ),
                        child: Text(
                          'PARA SIEMPRE',
                          style: TextStyle(
                            fontFamily: 'Cinzel',
                            fontSize: isCompact ? 10.0 : 11.5,
                            letterSpacing: 4.0,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textAccent,
                          ),
                        ),
                      ),

                      SizedBox(height: isCompact ? 16.0 : 22.0),

                      // Título poético
                      Text(
                        'Bajo el mismo cielo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: isCompact ? 26.0 : 33.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.2,
                          color: AppColors.textHero,
                          shadows: const [
                            Shadow(
                              color: Color(0x99DFBA8F),
                              blurRadius: 26.0,
                              offset: Offset(0, 2),
                            ),
                            Shadow(
                              color: Colors.black,
                              blurRadius: 18.0,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: isCompact ? 12.0 : 16.0),

                      // Nombres de los novios
                      Text(
                        AppStrings.coupleNames,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Cinzel',
                          fontSize: isCompact ? 22.0 : 27.0,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.8,
                          color: AppColors.textAccent,
                          shadows: const [
                            Shadow(
                              color: Color(0x66DFBA8F),
                              blurRadius: 18.0,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6.0),

                      // Fecha
                      Text(
                        AppStrings.weddingDate,
                        style: TextStyle(
                          fontSize: isCompact ? 12.5 : 13.5,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textBody.withValues(alpha: 0.80),
                        ),
                      ),

                      SizedBox(height: isCompact ? 22.0 : 30.0),

                      // Mensaje conmemorativo y de agradecimiento
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          'Que el amor, la complicidad y la paz\nsigan tejiendo cada uno de nuestros días.\n\nGracias por ser testigo de nuestra historia.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Cormorant Garamond',
                            fontStyle: FontStyle.italic,
                            fontSize: isCompact ? 16.0 : 18.0,
                            height: 1.55,
                            letterSpacing: 0.4,
                            color: AppColors.textBody,
                          ),
                        ),
                      ),

                      SizedBox(height: isCompact ? 30.0 : 40.0),

                      // Botones de acción final
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Botón para volver a ver la obra
                          EmilPremiumButton(
                            text: 'Revivir la historia',
                            onPressed: widget.onReplay,
                            trailingIcon: Icons.replay_rounded,
                            padding: EdgeInsets.symmetric(
                              horizontal: isCompact ? 22.0 : 28.0,
                              vertical: isCompact ? 12.0 : 15.0,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14.0),

                      // Enlace sutil para volver a la carta
                      TextButton.icon(
                        onPressed: widget.onReturnToLetter,
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          size: 16.0,
                          color: AppColors.textAccent,
                        ),
                        label: Text(
                          'Volver a la carta de presentación',
                          style: TextStyle(
                            color: AppColors.textAccent.withValues(alpha: 0.90),
                            fontSize: 12.5,
                            letterSpacing: 1.0,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                AppColors.textAccent.withValues(alpha: 0.40),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
