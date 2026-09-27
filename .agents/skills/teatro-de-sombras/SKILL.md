---
name: teatro-de-sombras
description: Guía experta para diseñar e implementar presentaciones narrativas de teatro de sombras en Flutter mediante siluetas animadas, pantalla iluminada, poses clave y líneas de tiempo por escenas.
---

# Skill: Teatro de Sombras en Flutter (Shadow Theater Storytelling)

Este skill define la metodología, estética y arquitectura técnica para construir experiencias narrativas de **teatro de sombras** en Flutter.

El objetivo no es crear una pantalla estática con texto y efectos ornamentales, sino **contar una historia a través de acciones visuales perceptibles**: siluetas humanas y accesorios interactuando detrás de una pantalla de lienzo/papel iluminada por luz posterior.

---

## 1. Principio Fundamental: Narrativa a través de la Acción

> [!IMPORTANT]
> **Regla de oro:** Nunca sustituyas la narrativa visual por una portada estática, textos cinematográficos flotantes o nubes de partículas decorativas. 
> La historia se transmite porque los personajes **se mueven, interactúan con objetos, reaccionan entre sí y transforman la escena**.

### Regla de Storyboard Previo
Antes de escribir cualquier línea de código de una nueva escena o secuencia:
1. Definir el **Inicio**: Posición inicial de las siluetas, escenario y atmósfera de luz.
2. Definir la **Acción**: El movimiento físico y la acción dramática principal (caminar, buscar, encontrarse, ofrecer un objeto, bailar).
3. Definir el **Final / Transición**: Pose clave de cierre y transición luminosa o de siluetas hacia la siguiente escena.

---

## 2. Anatomía Visual del Teatro de Sombras

Toda escena de teatro de sombras se compone de tres planos físicos fundamentales:

```
[ Fondo / Luz de Proyector ]
           ↓
[ Siluetas y Props (Opacos/Traslúcidos) ]
           ↓
[ Pantalla de Papel de Arroz / Lienzo Difusor ]
           ↓
[ Espectador / Cámara ]
```

### Paleta y Propiedades Físicas:
1. **Luz Trasera (Backlight):**
   - No es un fondo plano; es un haz de luz focal (lámpara o proyector cálido: marfil `#FFF9E6`, ámbar dorado `#DFBA8F` o tonos crepusculares).
   - Atenuación radial suave hacia los bordes simulando una tela tensada con iluminación puntual.
2. **Pantalla Difusora (Screen Canvas):**
   - Textura sutil y viñeta en las esquinas que imita el marco de madera o el soporte del teatro de títeres.
3. **Siluetas (Shadow Puppets):**
   - Figuras de perfil o tres cuartos en negro profundo o sepia muy oscuro (`Color(0xFF0F0D11)`).
   - Bordes definidos con micro-difuminado (desenfoque de 0.5px a 1.5px según la proximidad a la pantalla).
   - Accesorios traslúcidos con recortes o ventanas de luz interna (faroles, paraguas, joyas, estrellas).

---

## 3. Arquitectura en Flutter: Poses Clave y Línea de Tiempo

Para lograr movimientos orgánicos de títeres de sombras sin sobrecargar el árbol de widgets:

### A. Estructura de Control de Escena (`AnimationController`)
Cada escena posee un `AnimationController` con una duración total definida (ej. 4 a 8 segundos), subdividida mediante `CurvedAnimation` con intervalos específicos (`Interval(start, end, curve)`).

```dart
// Ejemplo de desglose por intervalos
_characterWalk = Tween<double>(begin: -0.4, end: 0.1).animate(
  CurvedAnimation(parent: _controller, curve: Interval(0.0, 0.45, curve: Curves.easeInOut)),
);

_armRaise = Tween<double>(begin: 0.0, end: -0.6).animate(
  CurvedAnimation(parent: _controller, curve: Interval(0.40, 0.70, curve: Curves.easeOutBack)),
);
```

### B. Composición Mediante `CustomPainter` vs Widgets Modulares
- **Siluetas complejas:** Usar `CustomPainter` con `Path` vectoriales para siluetas precisas, extremidades articuladas y props recortados.
- **Transformaciones jerárquicas:** Animar puntos de pivote (`canvas.translate`, `canvas.rotate`) para emular varillas de títeres de sombras (rotación de brazos desde el hombro/codo, pasos rítmicos).

### C. Adaptabilidad Móvil (Responsive)
- Toda la escena debe calcularse en base a un lienzo normalizado relativo (coordenadas relativas `0.0` a `1.0` o `BoxConstraints`).
- Mantener la acción principal contenida dentro de la zona segura central (Safe Area y relación de aspecto de 9:16 a 4:5).

---

## 4. Checklist de Verificación de Calidad

Antes de dar por concluida una escena:
- [ ] ¿Hay al menos una acción humana reconocible y con propósito?
- [ ] ¿Los personajes tienen poses claras y siluetas legibles de un vistazo?
- [ ] ¿La pantalla proyecta calidez y profundidad de teatro de sombras tradicional?
- [ ] ¿Las transiciones entre poses usan curvas de desaceleración orgánicas (`easeOutCubic`, `easeInOutQuad`)?
- [ ] ¿Es completamente responsive y se ejecuta a 60 fps en móvil y web?
