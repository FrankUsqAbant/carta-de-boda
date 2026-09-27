import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../shared/services/theater_audio_service.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../welcome/presentation/presentation_letter_screen.dart';
import '../../core/models/theater_scene.dart';
import '../../core/timeline/theater_timeline_controller.dart';
import '../painters/shadow_stage_painter.dart';
import '../widgets/theater_closing_curtain.dart';

/// Pantalla inmersiva a pantalla completa del Teatro de Sombras «Bajo el mismo cielo».
/// Diseñada con estética cinematográfica pura, audio ambiental y telón final conmemorativo.
class ShadowTheaterPlayScreen extends StatefulWidget {
  const ShadowTheaterPlayScreen({super.key});

  @override
  State<ShadowTheaterPlayScreen> createState() =>
      _ShadowTheaterPlayScreenState();
}

class _ShadowTheaterPlayScreenState extends State<ShadowTheaterPlayScreen>
    with SingleTickerProviderStateMixin {
  late final TheaterTimelineController _timeline;
  late final TheaterAudioService _audioService;
  bool _showOverlayControls = true;
  bool _isAudioFadingOut = false;

  @override
  void initState() {
    super.initState();
    // Configurar modo inmersivo en dispositivos móviles
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _audioService = TheaterAudioService();

    // Inicializar controlador en exactamente 170.0 segundos para la obra completa
    _timeline = TheaterTimelineController(
      vsync: this,
      totalSeconds: MasterTheaterScript.totalPlannedSeconds,
    );

    // Escuchar el progreso del timeline para desvanecer la música al entrar la despedida
    _timeline.addListener(_onTimelineTick);

    // Iniciar automáticamente la reproducción y el audio
    _timeline.play();
    _audioService.play(startSeconds: 0.0);
  }

  void _onTimelineTick() {
    final currentSec = _timeline.currentSeconds;

    // Al llegar al desenlace final (segundo 167.0 o al concluir la animación)
    // desvanecemos suavemente el audio para que coincida exactamente con la
    // aparición del telón de despedida y no siga sonando harto tiempo.
    if ((currentSec >= 167.0 || _timeline.isCompleted) && !_isAudioFadingOut) {
      _isAudioFadingOut = true;
      _audioService.fadeOutAndStop(duration: const Duration(seconds: 2));
    }
  }

  @override
  void dispose() {
    _timeline.removeListener(_onTimelineTick);
    _audioService.pause();
    _timeline.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleControlsVisibility() {
    setState(() {
      _showOverlayControls = !_showOverlayControls;
    });
  }

  void _handlePlayPause() {
    _timeline.togglePlayPause();
    if (_timeline.isPlaying) {
      if (_timeline.currentSeconds < 167.0) {
        _isAudioFadingOut = false;
        _audioService.resume();
      }
    } else {
      _audioService.pause();
    }
  }

  void _handleSeek(double seconds) {
    if (seconds < 167.0) {
      _isAudioFadingOut = false;
    }
    _timeline.seekTo(seconds);
    _audioService.seek(seconds);
    if (_timeline.isPlaying && seconds < 167.0) {
      _audioService.resume();
    }
  }

  void _handleRestart() {
    _isAudioFadingOut = false;
    _timeline.restart();
    _audioService.play(startSeconds: 0.0);
  }

  void _returnToLetter() {
    _audioService.stop();
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (context, _, __) => const PresentationLetterScreen(),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(
            opacity: CurvedAnimation(parent: animation, curve: Curves.easeInOut),
            child: child,
          );
        },
      ),
    );
  }

  String _formatTime(double seconds) {
    final int s = seconds.toInt();
    final int tenths = ((seconds - s) * 10).toInt();
    final int min = s ~/ 60;
    final int remSec = s % 60;
    return '${min.toString().padLeft(2, '0')}:${remSec.toString().padLeft(2, '0')}.${tenths}s';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _toggleControlsVisibility,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 1. LIENZO DEL TEATRO DE SOMBRAS (Ocupa absolutamente toda la pantalla)
            AnimatedBuilder(
              animation: _timeline,
              builder: (context, _) {
                return CustomPaint(
                  painter: MasterShadowStagePainter(
                    currentSeconds: _timeline.currentSeconds,
                  ),
                  size: size,
                );
              },
            ),

            // 2. OVERLAY SUPERIOR DISCRETO (Título, Acto, Botón Audio Mute, Volver y Ocultar)
            Positioned(
              top: MediaQuery.of(context).padding.top + 12.0,
              left: 16.0,
              right: 16.0,
              child: AnimatedOpacity(
                opacity: _showOverlayControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón volver a la carta de presentación
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.textAccent,
                            size: 20.0,
                          ),
                          tooltip: 'Volver a la carta',
                          onPressed: _returnToLetter,
                        ),
                        const SizedBox(width: 4.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              '«Bajo el mismo cielo»',
                              style: TextStyle(
                                fontFamily: 'Cinzel',
                                color: AppColors.textAccent,
                                fontSize: 14.5,
                                letterSpacing: 2.2,
                                fontWeight: FontWeight.w600,
                                shadows: [
                                  Shadow(color: Colors.black, blurRadius: 12.0),
                                ],
                              ),
                            ),
                            const SizedBox(height: 2.0),
                            AnimatedBuilder(
                              animation: _timeline,
                              builder: (context, _) {
                                final scene = _timeline.currentScene;
                                return Text(
                                  'Acto ${scene.id}: ${scene.title}',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    color: AppColors.textHero
                                        .withValues(alpha: 0.85),
                                    fontSize: 12.0,
                                    letterSpacing: 1.2,
                                    shadows: const [
                                      Shadow(
                                          color: Colors.black, blurRadius: 10.0),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Acciones derechas: Control de Sonido y Ocultar controles
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Botón de Mute / Audio
                        ValueListenableBuilder<bool>(
                          valueListenable: _audioService.isMutedNotifier,
                          builder: (context, isMuted, _) {
                            return IconButton(
                              icon: Icon(
                                isMuted
                                    ? Icons.volume_off_rounded
                                    : Icons.volume_up_rounded,
                                color: AppColors.textAccent,
                                size: 22.0,
                              ),
                              tooltip: isMuted ? 'Activar sonido' : 'Silenciar',
                              onPressed: _audioService.toggleMute,
                            );
                          },
                        ),

                        // Botón para alternar visibilidad de controles
                        IconButton(
                          icon: const Icon(
                            Icons.fullscreen_exit_rounded,
                            color: AppColors.textAccent,
                            size: 22.0,
                          ),
                          tooltip: 'Ocultar controles',
                          onPressed: _toggleControlsVisibility,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 3. OVERLAY INFERIOR DISCRETO (Controles de reproducción y Scrubber para revisión)
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 16.0,
              left: 20.0,
              right: 20.0,
              child: AnimatedOpacity(
                opacity: _showOverlayControls ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(
                      color: AppColors.buttonBorder.withValues(alpha: 0.35),
                      width: 0.8,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black54,
                        blurRadius: 16.0,
                      ),
                    ],
                  ),
                  child: AnimatedBuilder(
                    animation: _timeline,
                    builder: (context, _) {
                      final currentSec = _timeline.currentSeconds;
                      final totalSec = _timeline.totalSeconds;
                      final isPlaying = _timeline.isPlaying;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Scrubber temporal ultra-preciso
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppColors.textAccent,
                              inactiveTrackColor: Colors.white24,
                              thumbColor: AppColors.textHero,
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 5.5),
                              trackHeight: 2.5,
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 12.0),
                            ),
                            child: Slider(
                              value: currentSec.clamp(0.0, totalSec),
                              min: 0.0,
                              max: totalSec,
                              onChanged: _handleSeek,
                            ),
                          ),

                          // Barra de botones y contador
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Cronómetro exacto
                              Text(
                                '${_formatTime(currentSec)} / ${_formatTime(totalSec)}',
                                style: const TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: AppColors.textHero,
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.0,
                                ),
                              ),

                              // Botones de acción rápida
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.replay_rounded),
                                    color: AppColors.textAccent,
                                    iconSize: 22.0,
                                    tooltip: 'Reiniciar fragmento',
                                    onPressed: _handleRestart,
                                  ),
                                  const SizedBox(width: 8.0),
                                  IconButton.filled(
                                    style: IconButton.styleFrom(
                                      backgroundColor: AppColors.textAccent,
                                      foregroundColor: AppColors.backgroundDeep,
                                      minimumSize: const Size(36.0, 36.0),
                                      padding: EdgeInsets.zero,
                                    ),
                                    icon: Icon(
                                      isPlaying
                                          ? Icons.pause_rounded
                                          : Icons.play_arrow_rounded,
                                      size: 22.0,
                                    ),
                                    tooltip: isPlaying
                                        ? 'Pausar'
                                        : 'Reproducir',
                                    onPressed: _handlePlayPause,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),

            // 4. TELÓN DE CLAUSURA FINAL AL CONCLUIR LA OBRA (Aparece a partir del fundido final en 168.5s)
            AnimatedBuilder(
              animation: _timeline,
              builder: (context, _) {
                final currentSec = _timeline.currentSeconds;
                if (currentSec >= 168.5 || _timeline.isCompleted) {
                  return TheaterClosingCurtain(
                    onReplay: _handleRestart,
                    onReturnToLetter: _returnToLetter,
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }
}
