import 'package:flutter/material.dart';
import '../models/theater_scene.dart';

/// Controlador maestro de la línea de tiempo del Teatro de Sombras.
/// Envuelve un [AnimationController] estándar de Flutter garantizando sincronización perfecta
/// tanto en ejecución en dispositivos como en pruebas unitarias y de widgets.
class TheaterTimelineController extends ChangeNotifier {
  final TickerProvider vsync;
  final double totalSeconds;
  late final AnimationController _animationController;

  TheaterTimelineController({
    required this.vsync,
    this.totalSeconds = MasterTheaterScript.totalPlannedSeconds,
  }) {
    _animationController = AnimationController(
      vsync: vsync,
      duration: Duration(milliseconds: (totalSeconds * 1000).round()),
    );

    _animationController.addListener(() {
      notifyListeners();
    });
  }

  /// Tiempo actual en segundos (0.0 a totalSeconds) con alta precisión
  double get currentSeconds => _animationController.value * totalSeconds;

  /// Progreso global normalizado (0.0 a 1.0)
  double get globalProgress => _animationController.value;

  /// Estado de reproducción
  bool get isPlaying => _animationController.isAnimating;

  /// Indica si la obra o fragmento ha finalizado
  bool get isCompleted => _animationController.isCompleted;

  /// Controlador de animación interno
  AnimationController get animationController => _animationController;

  /// Obtiene la escena actualmente activa según el tiempo en segundos
  TheaterScene get currentScene {
    final s = currentSeconds;
    for (final scene in MasterTheaterScript.fullScript) {
      if (scene.containsTime(s)) {
        return scene;
      }
    }
    // Si llegó al final exacto
    if (s >= totalSeconds) {
      return MasterTheaterScript.fullScript.last; // Escena 14: Bajo la luna
    }
    return MasterTheaterScript.fullScript.first;
  }

  void play() {
    if (_animationController.isCompleted) {
      _animationController.reset();
    }
    _animationController.forward();
    notifyListeners();
  }

  void pause() {
    _animationController.stop();
    notifyListeners();
  }

  void togglePlayPause() {
    if (isPlaying) {
      pause();
    } else {
      play();
    }
  }

  void seekTo(double seconds) {
    final targetValue = (seconds / totalSeconds).clamp(0.0, 1.0);
    _animationController.value = targetValue;
    notifyListeners();
  }

  void seekProgress(double progress) {
    _animationController.value = progress.clamp(0.0, 1.0);
    notifyListeners();
  }

  void restart() {
    _animationController.reset();
    _animationController.forward();
    notifyListeners();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
