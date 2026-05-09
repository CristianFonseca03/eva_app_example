# EVA-01 Design System — Flutter Showcase

Aplicación Flutter que implementa y exhibe el **Design System EVA-01**, inspirado en la estética HUD/mech de Neon Genesis Evangelion. Funciona como catálogo interactivo de componentes y como demo de pantallas operacionales ficticias.

## Plataformas

| Plataforma | Estado |
|---|---|
| Web | ✅ |
| iOS | ✅ |
| Android | ✅ |

## Requisitos

- Flutter 3.41.4 — gestionado con `fvm`
- Dart SDK ^3.11.1

## Inicio rápido

```bash
# Instalar dependencias
fvm flutter pub get

# Web (puerto 8080)
fvm flutter run -d chrome --web-port 8080

# iOS simulator
fvm flutter run -d ios

# Android emulator
fvm flutter run -d android
```

## Estructura del proyecto

```
lib/
├── main.dart               # Punto de entrada
├── app.dart                # MaterialApp con EvaTheme
├── app_shell.dart          # Scaffold principal + navegación adaptativa
├── theme/
│   └── eva_theme.dart      # Colores, tipografía, espaciado y ThemeData
├── screens/
│   ├── home_screen.dart    # OPS — panel de operaciones principal
│   ├── directives_screen.dart  # CMD — directivas de misión
│   ├── alerts_screen.dart  # ALERT — log de alertas activas
│   ├── auth_screen.dart    # AUTH — autenticación de operador
│   └── showcase_screen.dart    # DS — catálogo del design system
└── widgets/                # Componentes del DS EVA-01
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
```

## Design System

### Paleta de colores (`EvaColors`)

| Token | Hex | Uso |
|---|---|---|
| `surface` | `#0A0A0A` | Fondo base |
| `surface2` | `#111111` | Fondo de tarjetas |
| `surface3` | `#1A0800` | Fondo con tinte cálido |
| `danger` | `#FF2020` | Estado crítico |
| `warning` | `#FF6B00` | Primario / advertencia |
| `caution` | `#FFB800` | Precaución |
| `active` | `#F5C518` | Elemento activo |
| `textPrimary` | `#FF6B00` | Texto principal |
| `textSecondary` | `#CC4400` | Texto secundario |
| `statusActive` | `#6BFF3B` | PIP activo |
| `statusDanger` | `#FF2020` | PIP en peligro |

### Tipografía (`EvaTextStyles`)

| Estilo | Fuente | Uso |
|---|---|---|
| `display` | Bebas Neue | Títulos y headers grandes |
| `mono` | Share Tech Mono | Datos técnicos, valores |
| `ui` | Rajdhani | Etiquetas de interfaz |
| `microLabel` | Share Tech Mono 9px | Micro-etiquetas |

### Componentes

| Widget | Descripción |
|---|---|
| `EvaButton` | Botón con 5 variantes: `primary`, `secondary`, `danger`, `ghost`, `hazard` |
| `EvaAlertPanel` | Panel de alerta con niveles `danger` y `warn` |
| `EvaBadge` | Insignia de estado con icono y animación |
| `EvaClip` | `CustomClipper` para esquinas recortadas estilo HUD |
| `EvaDataCard` | Tarjeta de dato técnico con etiqueta y valor |
| `EvaHazardModal` | Modal de confirmación de acción peligrosa |
| `EvaIcon` | Íconos SVG del sistema (13 iconos) |
| `EvaMicroLabel` | Etiqueta pequeña en mayúsculas con letra monoespaciada |
| `EvaPip` | Indicador de estado circular animado (`active`, `standby`, `danger`, `offline`) |
| `EvaProgressBar` | Barra de progreso con etiqueta y animación |
| `EvaStatusBadge` | Badge compuesto: pip + texto de estado |
| `EvaTextInput` | Campo de texto estilizado con etiqueta flotante |

## Dependencias

| Paquete | Versión | Propósito |
|---|---|---|
| `google_fonts` | ^6.2.1 | Bebas Neue, Share Tech Mono, Rajdhani |
| `flutter_animate` | ^4.5.0 | Animaciones declarativas en componentes |
| `flutter_svg` | ^2.0.10 | Renderizado de iconos SVG |

## Navegación

La app usa navegación adaptativa en `AppShell`:
- **Móvil** (`< 600px`): `NavigationBar` inferior con 5 tabs
- **Wide** (`≥ 600px`): Rail lateral

Tabs: **OPS** · **CMD** · **ALERT** · **AUTH** · **DS**
