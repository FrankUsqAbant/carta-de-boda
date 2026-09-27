import 'dart:developer' as developer;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Servicio de gestión y reproducción de audio del Teatro de Sombras.
/// Diseñado de forma robusta para entornos Web y móvil con manejo seguro de autoplay y excepciones.
class TheaterAudioService {
  static final TheaterAudioService _instance = TheaterAudioService._internal();
  factory TheaterAudioService() => _instance;
  TheaterAudioService._internal();

  AudioPlayer? _player;
  bool _isInitialized = false;

  final ValueNotifier<bool> isMutedNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> isPlayingNotifier = ValueNotifier<bool>(false);

  static const String audioAssetPath = 'audio/shadow_theater_theme.mp3';

  AudioPlayer get player {
    _player ??= AudioPlayer();
    return _player!;
  }

  /// Inicializa el reproductor si aún no se ha hecho
  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      final p = player;
      // Detener al finalizar la pista para evitar repetición en bucle infinito en la despedida
      await p.setReleaseMode(ReleaseMode.stop);
      await p.setVolume(isMutedNotifier.value ? 0.0 : 0.85);

      p.onPlayerStateChanged.listen((state) {
        isPlayingNotifier.value = (state == PlayerState.playing);
      });

      _isInitialized = true;
    } catch (e) {
      developer.log('Error inicializando TheaterAudioService: $e');
    }
  }

  /// Inicia la reproducción de la banda sonora desde el segundo especificado
  Future<void> play({double startSeconds = 0.0}) async {
    try {
      await initialize();
      final p = player;

      await p.setSource(AssetSource(audioAssetPath));
      if (startSeconds > 0.1) {
        await p.seek(Duration(milliseconds: (startSeconds * 1000).round()));
      }
      await p.setVolume(isMutedNotifier.value ? 0.0 : 0.85);
      await p.resume();
    } catch (e) {
      developer.log('Error reproduciendo audio: $e');
    }
  }

  /// Pausa el audio
  Future<void> pause() async {
    try {
      if (_player != null) {
        await _player!.pause();
      }
    } catch (e) {
      developer.log('Error pausando audio: $e');
    }
  }

  /// Reanuda el audio
  Future<void> resume() async {
    try {
      if (_player != null) {
        if (!isMutedNotifier.value) {
          await _player!.setVolume(0.85);
        }
        await _player!.resume();
      } else {
        await play();
      }
    } catch (e) {
      developer.log('Error reanudando audio: $e');
    }
  }

  /// Sincroniza la posición del audio con el timeline
  Future<void> seek(double seconds) async {
    try {
      if (_player != null) {
        await _player!.seek(Duration(milliseconds: (seconds * 1000).round()));
      }
    } catch (e) {
      developer.log('Error sincronizando audio en seek: $e');
    }
  }

  /// Alterna entre silenciado y sonido activo
  Future<void> toggleMute() async {
    try {
      final newMute = !isMutedNotifier.value;
      isMutedNotifier.value = newMute;
      if (_player != null) {
        await _player!.setVolume(newMute ? 0.0 : 0.85);
      }
    } catch (e) {
      developer.log('Error toggleMute: $e');
    }
  }

  /// Desvanece el volumen suavemente hasta silenciarlo y detiene la reproducción
  Future<void> fadeOutAndStop({Duration duration = const Duration(seconds: 2)}) async {
    try {
      if (_player == null) return;
      if (isMutedNotifier.value) {
        await stop();
        return;
      }

      const int steps = 12;
      final stepDuration = Duration(milliseconds: duration.inMilliseconds ~/ steps);
      const double initialVolume = 0.85;

      for (int i = steps - 1; i >= 0; i--) {
        if (_player == null) break;
        final vol = (initialVolume * (i / steps)).clamp(0.0, 1.0);
        await _player!.setVolume(vol);
        await Future.delayed(stepDuration);
      }

      await stop();

      // Restaurar el volumen base para que la próxima reproducción suene con volumen normal
      if (_player != null && !isMutedNotifier.value) {
        await _player!.setVolume(0.85);
      }
    } catch (e) {
      developer.log('Error en fadeOutAndStop: $e');
      await stop();
    }
  }

  /// Detiene y libera recursos si es necesario
  Future<void> stop() async {
    try {
      if (_player != null) {
        await _player!.stop();
      }
    } catch (e) {
      developer.log('Error deteniendo audio: $e');
    }
  }

  void dispose() {
    _player?.dispose();
    _player = null;
    _isInitialized = false;
  }
}
