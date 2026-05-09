# EVA-01 Design System — Flutter Showcase

Aplicación Flutter que implementa y exhibe el **Design System EVA-01**: una identidad visual operacional inspirada en la estética HUD/mech de Neon Genesis Evangelion. Funciona como catálogo interactivo de componentes (`DS` tab) y como demo de pantallas operacionales ficticias.

| Plataforma | Estado |
|---|---|
| Web | ✅ |
| iOS | ✅ |
| Android | ✅ |

---

## Inicio rápido

> Este proyecto usa **fvm** para gestionar la versión de Flutter. Todos los comandos deben correr con `fvm flutter`.

```bash
# 1. Instalar dependencias
fvm flutter pub get

# 2. Correr en web (puerto fijo 8080)
fvm flutter run -d chrome --web-port 8080

# 3. Correr en iOS simulator
fvm flutter run -d ios

# 4. Correr en Android emulator
fvm flutter run -d android
```

**Versión requerida:** Flutter 3.41.4 · Dart SDK ^3.11.1

---

## Arquitectura

```
lib/
├── main.dart               # Punto de entrada; monta MaterialApp con EvaTheme
├── app.dart                # MaterialApp: aplica EvaTheme.theme, ruta raíz → AppShell
├── app_shell.dart          # Scaffold principal; navegación adaptativa (ver §Navegación)
│
├── theme/
│   └── eva_theme.dart      # Tokens de diseño: EvaColors, EvaTextStyles, EvaSpacing, EvaTheme
│
├── screens/
│   ├── home_screen.dart        # OPS — panel de operaciones: reloj de misión, barras de subsistema, log
│   ├── directives_screen.dart  # CMD — formulario de directiva: inputs, selector de subsistema, interlocks
│   ├── alerts_screen.dart      # ALERT — log de alertas activas + panel de respuesta de emergencia
│   ├── auth_screen.dart        # AUTH — perfil de operador con barras de estadísticas
│   └── showcase_screen.dart    # DS — catálogo completo de todos los componentes del DS
│
└── widgets/                # Componentes del DS EVA-01 (ver §Catálogo de componentes)
    ├── eva_alert_panel.dart
    ├── eva_badge.dart
    ├── eva_button.dart
    ├── eva_clip.dart
    ├── eva_data_card.dart
    ├── eva_hazard_modal.dart
    ├── eva_icon.dart
    ├── eva_micro_label.dart
    ├── eva_pip.dart
    ├── eva_progress_bar.dart
    ├── eva_status_badge.dart
    └── eva_text_input.dart

assets/
├── logo.svg                    # Logotipo EVA-01
├── hazard-pattern.svg          # Patrón de franjas de peligro (SVG estático)
└── icons/                      # 13 iconos SVG angulares del DS
    ├── chevron-down.svg
    ├── clock.svg
    ├── cross.svg
    ├── grid.svg
    ├── lock.svg
    ├── menu.svg
    ├── plus.svg
    ├── shield.svg
    ├── signal.svg
    ├── target.svg
    ├── terminal.svg
    └── triangle-alert.svg
```

---

## Reglas del Design System

Estas reglas son invariantes. Todo componente nuevo debe cumplirlas.

| # | Regla | Aplicación en Flutter |
|---|---|---|
| 1 | **Solo fondos oscuros.** Sin modo claro. | Usar `EvaColors.surface`, `surface2`, `surface3`. Nunca `Colors.white` como fondo. |
| 2 | **Naranja (`#FF6B00`) es el acento por defecto.** Botones, bordes, etiquetas. | Usar `EvaColors.warning` como color de acción principal. |
| 3 | **Rojo (`#FF2020`) solo para destrucción.** Errores, acciones irreversibles, alertas críticas. | `EvaColors.danger` únicamente en `EvaButtonVariant.danger`, `AlertLevel.danger`, `PipStatus.danger`. |
| 4 | **Franjas de peligro solo para acciones irreversibles.** Requieren modal de confirmación con texto escrito. | `EvaButtonVariant.hazard` siempre abre `EvaHazardModal`. |
| 5 | **TODO en mayúsculas:** labels, botones, estados, headers. Sentence case solo en párrafos de cuerpo. | Llamar `.toUpperCase()` en todos los textos de UI que no sean párrafos. |
| 6 | **Sin emoji.** Usar el set de iconos SVG angular o caracteres geométricos Unicode. | Usar `EvaIcon(EvaIconName.xxx)`. Nunca `⚠`, `✓`, `→` en labels. |
| 7 | **Sin `border-radius` mayor a 2px.** Usar cortes diagonales (`clip-path`). | Usar `EvaClipBox` o `ClipPath(clipper: EvaClipper(cut: n))`. `BoxDecoration` sin `borderRadius` o con `BorderRadius.zero`. |
| 8 | **Letter-spacing 0.08–0.18em en todos los títulos y texto en MAYÚSCULAS.** | `EvaTextStyles.ui()` y `display()` ya lo incluyen. Al pasar `letterSpacing` manual: mínimo `0.08`. |
| 9 | **Tres familias tipográficas:** Share Tech Mono (datos), Bebas Neue (display), Rajdhani (UI). | `EvaTextStyles.mono()`, `.display()`, `.ui()`. No usar otras fuentes. |
| 10 | **Respetar `prefers-reduced-motion`.** Desactivar pulsos, glitch y scan lines si el sistema lo pide. | Verificar `MediaQuery.disableAnimationsOf(context)` antes de iniciar animaciones repetidas. |

---

## Tokens de diseño

Definidos en `lib/theme/eva_theme.dart`.

### Colores — `EvaColors`

| Token | Hex | Uso |
|---|---|---|
| `surface` | `#0A0A0A` | Fondo base del scaffold |
| `surface2` | `#111111` | Fondo de tarjetas y paneles elevados |
| `surface3` | `#1A0800` | Fondo con tinte cálido (alertas, estados críticos) |
| `danger` | `#FF2020` | Crítico / destructivo (rojo) |
| `warning` | `#FF6B00` | Acento principal / advertencia (naranja) |
| `caution` | `#FFB800` | Precaución (ámbar) |
| `active` | `#F5C518` | Elemento activo / confirmación (amarillo) |
| `data` | `#CC4400` | Naranja oscuro para datos secundarios |
| `muted` | `#8B4513` | Marrón oxidado para estructura deshabilitada |
| `border` | `#3D1500` | Borde por defecto de contenedores |
| `textPrimary` | `#FF6B00` | Texto principal |
| `textSecondary` | `#CC4400` | Texto secundario |
| `textLabel` | `#666666` | Micro-etiquetas, metadatos |
| `textValue` | `#FFFFFF` | Valores numéricos destacados |
| `textDisabled` | `#333333` | Texto deshabilitado |
| `statusActive` | `#6BFF3B` | PIP activo (verde neón) |
| `statusStandby` | `#FFB800` | PIP en espera |
| `statusDanger` | `#FF2020` | PIP en peligro |
| `statusOffline` | `#555555` | PIP sin conexión |

### Tipografía — `EvaTextStyles`

| Método | Fuente | Parámetros clave | Uso |
|---|---|---|---|
| `display({size, color})` | Bebas Neue | `size` defecto 40; tracking automático según tamaño | Títulos grandes, headers de pantalla |
| `mono({size, color, weight})` | Share Tech Mono | `size` defecto 13; tracking 0.02 | Valores numéricos, logs, datos técnicos |
| `ui({size, color, weight, letterSpacing})` | Rajdhani | `size` defecto 13; peso defecto 600; tracking defecto 0.08 | Labels de interfaz, botones, badges |
| `microLabel({color})` | Share Tech Mono | 9px fijo; tracking 0.18 | Micro-etiquetas sobre componentes |

### Espaciado — `EvaSpacing`

| Token | Valor |
|---|---|
| `s1` | 4px |
| `s2` | 8px |
| `s3` | 12px |
| `s4` | 16px |
| `s5` | 20px |
| `s6` | 24px |
| `s8` | 32px |
| `s10` | 40px |
| `s12` | 48px |

---

## Catálogo de componentes

### `EvaButton`

Botón con corte diagonal. Siempre escribe el label en mayúsculas (lo hace internamente con `.toUpperCase()`).

```dart
EvaButton(
  label: 'SUBMIT',
  variant: EvaButtonVariant.secondary, // defecto
  size: EvaButtonSize.md,              // defecto
  icon: EvaIcon(EvaIconName.plus, size: 14, color: EvaColors.warning),
  onPressed: () {},
)
```

| Variante | Color | Cuándo usar |
|---|---|---|
| `primary` | Naranja filled, texto negro | Acción principal de la pantalla |
| `secondary` | Borde naranja, fondo transparente | Acción secundaria / defecto |
| `danger` | Borde rojo, texto rojo | Acción destructiva con confirmación fácil |
| `ghost` | Tono gris oscuro | Acción terciaria o cancelar |
| `hazard` | Franjas ámbar/negro | Acción **irreversible** — debe abrir `EvaHazardModal` |

| Tamaño | Altura | Uso |
|---|---|---|
| `sm` | 28px | Botones en filas compactas |
| `md` | 36px | Uso general |
| `lg` | 44px | CTA principal de pantalla |

---

### `EvaAlertPanel`

Panel de alerta con borde izquierdo de color y icono.

```dart
EvaAlertPanel(
  level: AlertLevel.danger, // o AlertLevel.warn
  code: 'ERR-7740 · CORE BREACH',
  message: 'Reactor delta exceeded safe threshold.',
)
```

- `danger` → borde y texto rojos (`EvaColors.danger`)
- `warn` → borde y texto naranja (`EvaColors.warning`)
- El `message` puede estar en sentence case (es texto de párrafo).

---

### `EvaBadge`, `EvaBadgeStack`, `EvaMicroBadge`

```dart
// Label simple con fondo translúcido
EvaBadge('ACTIVE', variant: EvaBadgeVariant.label, color: EvaColors.statusActive)

// Con icono y pulso
EvaBadge('ALERT', variant: EvaBadgeVariant.icon, color: EvaColors.danger,
         icon: EvaIconName.triangleAlert, pulse: true)

// Conteo superpuesto sobre otro widget
EvaBadgeStack(count: '3', color: EvaColors.danger,
              child: EvaIcon(EvaIconName.terminal, size: 24, color: EvaColors.textLabel))

// Micro-badge de una línea con borde izquierdo
EvaMicroBadge('CHN-14B')
EvaMicroBadge('CRITICAL', color: EvaColors.danger)
```

| Variante | Descripción |
|---|---|
| `label` | Fondo translúcido + borde inferior del color |
| `outlined` | Borde completo, fondo transparente, corte diagonal |
| `status` | Incluye `EvaPip` a la izquierda |
| `icon` | Incluye `EvaIcon` a la izquierda |
| `count` | Número compacto sobre fondo sólido (para `EvaBadgeStack`) |

---

### `EvaClipBox` / `EvaClipper`

Geometría de corte diagonal para contenedores.

```dart
// Contenedor completo con borde y fondo
EvaClipBox(
  cut: 12,              // tamaño del corte en px
  bottomLeft: false,    // si true, aplica corte también en esquina inf-izq
  backgroundColor: EvaColors.surface2,
  borderColor: EvaColors.border,
  topAccentColor: EvaColors.warning,  // línea de acento en la parte superior
  child: ...,
)

// Solo el clipper (para ClipPath manual)
ClipPath(
  clipper: EvaClipper(cut: 10),
  child: ...,
)
```

---

### `EvaDataCard`

Tarjeta de dato técnico con categoría, etiqueta, valor y unidad.

```dart
EvaDataCard(
  category: 'SYNC RATIO',
  label: 'IKARI · S',
  value: '41.3',
  unit: '%',
  danger: false,       // true → valor y acento en rojo
  footer: EvaPip(...), // widget opcional bajo el valor
)
```

---

### `EvaHazardModal`

Modal de confirmación para acciones irreversibles. El botón de ejecución se activa solo cuando el usuario escribe la palabra exacta.

```dart
EvaHazardModal(
  onClose: () {},
  onExecute: () {},
  confirmWord: 'PURGE',          // palabra que debe escribir el usuario
  actionLabel: 'PURGE CORE',
  description: 'This action is irreversible and cannot be undone.',
)
```

---

### `EvaIcon` / `EvaLogo`

Iconos SVG angulares del DS. Usar siempre en lugar de `Icons.*` de Material.

```dart
EvaIcon(EvaIconName.triangleAlert, size: 20, color: EvaColors.danger)
EvaLogo(height: 32)
```

| `EvaIconName` | Icono |
|---|---|
| `grid` | Cuadrícula / dashboard |
| `terminal` | Terminal / comando |
| `triangleAlert` | Alerta / advertencia |
| `shield` | Escudo / auth |
| `target` | Objetivo / apuntar |
| `clock` | Reloj / tiempo |
| `signal` | Señal / conexión |
| `lock` | Candado / seguridad |
| `plus` | Más / agregar |
| `cross` | Cruz / cerrar |
| `menu` | Menú / hamburgesa |
| `chevronDown` | Flecha abajo / expandir |

---

### `EvaMicroLabel`

Etiqueta de 9px en Share Tech Mono, siempre en mayúsculas con tracking ancho.

```dart
EvaMicroLabel('[ SUBSYSTEM INTEGRITY ]')
EvaMicroLabel('ENGAGEMENT WINDOW', color: EvaColors.danger)
```

---

### `EvaPip`

Indicador de estado cuadrado. Respeta `prefers-reduced-motion`.

```dart
EvaPip(status: PipStatus.active)
EvaPip(status: PipStatus.danger, pulse: true, size: 10)
```

| Estado | Color |
|---|---|
| `active` | Verde neón `#6BFF3B` |
| `standby` | Ámbar `#FFB800` |
| `danger` | Rojo `#FF2020` |
| `offline` | Gris `#555555` |

---

### `EvaProgressBar`

Barra de progreso con etiqueta, porcentaje y animación de entrada.

```dart
EvaProgressBar(value: 68, label: 'FUEL · OXIDIZER')
EvaProgressBar(value: 14, label: 'SHIELD · CRITICAL', level: ProgressLevel.crit)
EvaProgressBar(value: 92, label: 'CORE · HAZARD',     level: ProgressLevel.haz)
EvaProgressBar(value: 41.3, label: 'SYNC RATIO',      level: ProgressLevel.sync, thin: true)
```

| Nivel | Color de fill | Efecto extra |
|---|---|---|
| `normal` | Naranja | Glow naranja |
| `crit` | Rojo | Flash pulsante (respeta reduced-motion) |
| `haz` | Franjas ámbar/negro | Sin glow |
| `sync` | Amarillo activo | Glow suave |

---

### `EvaStatusBadge`

Badge compuesto: `EvaPip` + texto de estado.

```dart
EvaStatusBadge(status: PipStatus.active, label: 'MAGI SYNC')
EvaStatusBadge(status: PipStatus.danger, label: '3 OPEN')
```

---

### `EvaTextInput`

Campo de texto con borde inferior de acento y soporte de error.

```dart
EvaTextInput(
  label: 'OPERATOR ID',       // micro-label encima del campo
  controller: _controller,
  placeholder: 'ENTER ID',
  error: null,                 // string → muestra error en rojo
  obscureText: false,
  onChanged: (v) {},
)
```

---

## Cómo agregar un componente nuevo

1. **Crear** `lib/widgets/eva_<nombre>.dart`. Importar `../theme/eva_theme.dart`.
2. **Aplicar reglas del DS** (§Reglas del Design System): fondos oscuros, cortes diagonales, naranja como acento, rojo solo para destructivo, mayúsculas en labels, `EvaIcon` en lugar de `Icons.*`.
3. **Verificar reduced-motion** si el componente tiene animaciones repetidas:
   ```dart
   if (!MediaQuery.disableAnimationsOf(context)) {
     // animación
   }
   ```
4. **Agregar al showcase** en `lib/screens/showcase_screen.dart`: crear `_buildNuevoComponente()` y registrarlo en `build()` con `_buildSection('NOMBRE', _buildNuevoComponente())`.
5. **Verificar** en `fvm flutter analyze` que no hay errores ni imports innecesarios.

---

## Navegación adaptativa

`AppShell` detecta el ancho del viewport y cambia de layout:

| Modo | Umbral | Componente de navegación |
|---|---|---|
| Narrow (móvil) | `< 600px` | Barra inferior con 5 tabs + header de pantalla |
| Wide (tablet/web) | `≥ 600px` | Rail lateral de 200px + header de contenido |

Tabs disponibles:

| Tab | Pantalla | Icono |
|---|---|---|
| `OPS` | `HomeScreen` | `EvaIconName.grid` |
| `CMD` | `DirectivesScreen` | `EvaIconName.terminal` |
| `ALERT` | `AlertsScreen` | `EvaIconName.triangleAlert` |
| `AUTH` | `AuthScreen` | `EvaIconName.shield` |
| `DS` | `ShowcaseScreen` | `EvaIconName.target` |

---

## Dependencias

| Paquete | Versión | Propósito |
|---|---|---|
| `google_fonts` | `^6.2.1` | Bebas Neue, Share Tech Mono, Rajdhani |
| `flutter_animate` | `^4.5.0` | Animaciones declarativas (fadeIn, slideY, shimmer, pulse) |
| `flutter_svg` | `^2.0.10` | Renderizado de iconos y logo SVG |
