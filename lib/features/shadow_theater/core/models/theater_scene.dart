/// Representa una escena del guion maestro del Teatro de Sombras «Bajo el mismo cielo».
class TheaterScene {
  final int id;
  final String title;
  final double durationSeconds;
  final double startSeconds;
  final double endSeconds;
  final String description;

  const TheaterScene({
    required this.id,
    required this.title,
    required this.durationSeconds,
    required this.startSeconds,
    required this.endSeconds,
    required this.description,
  });

  /// Determina si un segundo dado se encuentra dentro del rango de esta escena.
  bool containsTime(double seconds) {
    return seconds >= startSeconds && seconds < endSeconds;
  }

  /// Retorna el progreso local normalizado (0.0 a 1.0) dentro de esta escena.
  double localProgress(double seconds) {
    if (seconds <= startSeconds) return 0.0;
    if (seconds >= endSeconds) return 1.0;
    return (seconds - startSeconds) / durationSeconds;
  }
}

/// Cronología maestra completa de las 14 escenas del contrato narrativo (170 segundos planificados).
class MasterTheaterScript {
  MasterTheaterScript._();

  static const List<TheaterScene> fullScript = [
    TheaterScene(
      id: 1,
      title: 'Amanece',
      durationSeconds: 10.0,
      startSeconds: 0.0,
      endSeconds: 10.0,
      description:
          'Oscuridad total. El sol aparece en el horizonte y asciende. Dos árboles emergen y las flores se mecen.',
    ),
    TheaterScene(
      id: 2,
      title: 'Ella y la flor',
      durationSeconds: 12.0,
      startSeconds: 10.0,
      endSeconds: 22.0,
      description:
          'Ella entra desde la izquierda, recoge una flor y quita los pétalos uno a uno. Conserva el último al escuchar pasos.',
    ),
    TheaterScene(
      id: 3,
      title: 'Encuentro casual',
      durationSeconds: 14.0,
      startSeconds: 22.0,
      endSeconds: 36.0,
      description:
          'Él entra desde la derecha y se detiene al verla. Ambos retroceden brevemente, se observan y se acercan con timidez.',
    ),
    TheaterScene(
      id: 4,
      title: 'La rosa',
      durationSeconds: 12.0,
      startSeconds: 36.0,
      endSeconds: 48.0,
      description:
          'Él encuentra una rosa, la recoge y se la ofrece. Ella acepta la rosa, la acerca al pecho y se toman de las manos.',
    ),
    TheaterScene(
      id: 5,
      title: 'Primer baile',
      durationSeconds: 12.0,
      startSeconds: 48.0,
      endSeconds: 60.0,
      description:
          'Bailan lentamente con un giro y manos unidas mientras el sol desciende.',
    ),
    TheaterScene(
      id: 6,
      title: 'Hogar compartido',
      durationSeconds: 11.0,
      startSeconds: 60.0,
      endSeconds: 71.0,
      description:
          'Aparece una casa sencilla bajo los mismos árboles. Entran juntos con una flor y se sientan.',
    ),
    TheaterScene(
      id: 7,
      title: 'Primer hijo',
      durationSeconds: 12.0,
      startSeconds: 71.0,
      endSeconds: 83.0,
      description:
          'Ella sostiene al primer bebé; Él acaricia su cabeza y los tres se abrazan.',
    ),
    TheaterScene(
      id: 8,
      title: 'Baile de tres',
      durationSeconds: 10.0,
      startSeconds: 83.0,
      endSeconds: 93.0,
      description:
          'El bebé ya es un niño y se une al baile de sus padres con un giro y abrazo.',
    ),
    TheaterScene(
      id: 9,
      title: 'Ocho años después',
      durationSeconds: 10.0,
      startSeconds: 93.0,
      endSeconds: 103.0,
      description:
          'Rótulo: «8 años después». El hijo mayor juega y deja flores; Ella muestra su embarazo.',
    ),
    TheaterScene(
      id: 10,
      title: 'Segundo bebé',
      durationSeconds: 11.0,
      startSeconds: 103.0,
      endSeconds: 114.0,
      description:
          'Ella mece al segundo bebé. Él y el hijo mayor se acercan y los cuatro se reúnen.',
    ),
    TheaterScene(
      id: 11,
      title: 'Once años después',
      durationSeconds: 11.0,
      startSeconds: 114.0,
      endSeconds: 125.0,
      description:
          'Rótulo: «11 años después». El mayor es joven, el segundo tiene 11 años y los cuatro bailan en círculo.',
    ),
    TheaterScene(
      id: 12,
      title: 'Tercer bebé',
      durationSeconds: 11.0,
      startSeconds: 125.0,
      endSeconds: 136.0,
      description:
          'Sostienen al recién nacido; los dos hermanos se acercan y las cinco siluetas quedan reunidas.',
    ),
    TheaterScene(
      id: 13,
      title: 'Cuatro años después, picnic',
      durationSeconds: 14.0,
      startSeconds: 136.0,
      endSeconds: 150.0,
      description:
          'Rótulo: «4 años después». Manta y cesta bajo los árboles; los cinco disfrutan del picnic y se abrazan.',
    ),
    TheaterScene(
      id: 14,
      title: 'Bajo la luna',
      durationSeconds: 20.0,
      startSeconds: 150.0,
      endSeconds: 170.0,
      description:
          'Los tres hijos entran a la casa; la pareja queda sola bajo la luna y la luz se apaga hasta la oscuridad total.',
    ),
  ];

  /// Duración total de la Fase 1 (Escenas 1 a 4): exactamente 48.0 segundos.
  static const double phase1MaxSeconds = 48.0;

  /// Duración total planificada para las 14 escenas de la obra completa: exactamente 170.0 segundos (máximo estricto: 180s).
  static const double totalPlannedSeconds = 170.0;
}
