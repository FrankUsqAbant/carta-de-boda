import 'package:flutter/material.dart';
import '../../shadow_theater/presentation/screens/shadow_theater_play_screen.dart';
import '../../../shared/constants/app_strings.dart';
import '../../../shared/services/theater_audio_service.dart';
import 'widgets/realistic_rose_heart_frame.dart';

/// Carta de Presentación / Prólogo íntimo del Teatro de Sombras:
/// - Fondo oscuro cinematográfico con iluminación difusa cálida.
/// - Marco botánico en forma de corazón formado por rosas rojas y blancas de apariencia fotográfica real.
/// - El centro permanece despejado y el texto y botón son los protagonistas absolutos.
/// - Entrada elegante inmediata, sin bloquear la interacción del botón.
/// - El botón «Comenzar la historia» actúa como PLAY con icono sutil de reproducción y protección contra doble pulsación.
/// - La obra de sombras permanece en cero (no se instancia) mientras se lee la carta.
class PresentationLetterScreen extends StatefulWidget {
  const PresentationLetterScreen({super.key});

  @override
  State<PresentationLetterScreen> createState() =>
      _PresentationLetterScreenState();
}

class _PresentationLetterScreenState extends State<PresentationLetterScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  bool _isTransitioning = false;

  @override
  void initState() {
    super.initState();

    // Animación de entrada fluida y rápida (650ms)
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.025),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOutCubic,
    ));

    _entranceController.forward();
  }

  static bool _assetsPrecached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_assetsPrecached) {
      _assetsPrecached = true;
      const roseAssets = [
        'assets/images/roses/rose_red_1.png',
        'assets/images/roses/rose_red_2.png',
        'assets/images/roses/rose_white_1.png',
        'assets/images/roses/rose_white_2.png',
        'assets/images/roses/rose_red_bud.png',
        'assets/images/roses/foliage_sprig.png',
      ];
      for (final asset in roseAssets) {
        precacheImage(AssetImage(asset), context);
      }
    }
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  /// Inicia la transición teatral hacia la obra de sombras al pulsar PLAY y arranca el audio
  void _startStory() {
    if (_isTransitioning) return;
    setState(() => _isTransitioning = true);

    // Arrancar la banda sonora del teatro de sombras disparado por el gesto del usuario
    TheaterAudioService().play(startSeconds: 0.0);

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ShadowTheaterPlayScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            ),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final isCompact = size.width < 370 || size.height < 670;

    return Scaffold(
      backgroundColor: const Color(0xFFF9F5EE),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. ILUMINACIÓN NUPCIAL CÁLIDA, LUMINOSA Y RADIANTE (Fondo ideal para boda con vida)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0.0, -0.10),
                  radius: 1.35,
                  colors: [
                    Color(0xFFFFFDF9), // Centro marfil luminoso nupcial
                    Color(0xFFFBF4EA), // Champaña crema cálido
                    Color(0xFFF4E7DA), // Rubor nupcial sutil y elegante
                    Color(0xFFEADBCE), // Arena dorada suave en los bordes
                  ],
                  stops: [0.0, 0.45, 0.80, 1.0],
                ),
              ),
            ),
          ),

          // 2. MARCO FLORAL EN FORMA DE CORAZÓN CON ROSAS REALISTAS Y RESPIRACIÓN SUTIL
          Positioned.fill(
            child: RealisticRoseHeartFrame(
              onRosePressed: _startStory,
              child: SafeArea(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: isCompact ? 20.0 : 28.0,
                          vertical: isCompact ? 16.0 : 24.0,
                        ),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 420.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // NOMBRES: «Estefania & Darlin»
                              Text(
                                AppStrings.coupleNames,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Cinzel',
                                  fontSize: isCompact ? 30.0 : 40.0,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2E151B), // Borgoña oscuro noble
                                  letterSpacing: 2.0,
                                  height: 1.15,
                                  shadows: const [
                                    Shadow(
                                      color: Color(0x33D4AF37),
                                      blurRadius: 18.0,
                                      offset: Offset(0, 2),
                                    ),
                                    Shadow(
                                      color: Color(0x1A000000),
                                      blurRadius: 6.0,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 10.0),

                              // FECHA: «27 de septiembre de 2026»
                              Text(
                                AppStrings.weddingDate,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontSize: isCompact ? 12.5 : 14.0,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 2.4,
                                  color: const Color(0xFF8C6D3B), // Oro satinado refinado
                                  shadows: const [
                                    Shadow(
                                      color: Color(0x40FFFFFF),
                                      blurRadius: 6.0,
                                      offset: Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: isCompact ? 20.0 : 28.0),

                              // DEDICATORIA BREVE Y EMOTIVA
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: isCompact ? 245.0 : 285.0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                  vertical: 4.0,
                                ),
                                child: Text(
                                  AppStrings.presentationDedication,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Cormorant Garamond',
                                    fontSize: isCompact ? 18.0 : 21.0,
                                    fontStyle: FontStyle.italic,
                                    height: 1.45,
                                    letterSpacing: 0.4,
                                    color: const Color(0xFF4A343A), // Vino chocolate suave
                                    shadows: const [
                                      Shadow(
                                        color: Color(0x60FFFFFF),
                                        blurRadius: 8.0,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
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
            ),
          ),
        ],
      ),
    );
  }
}
