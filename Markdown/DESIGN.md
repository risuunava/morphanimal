# DESIGN.md — Real World Animal Fantasy Collector (RWAFC)
## Design System & UI Specification v1.0.0

**Referensi Visual:** Pokémon Pokedex UI (Dribbble — clean card style)
**Framework:** Flutter 3.19+ dengan Material 3
**Pendekatan:** Light-first dengan dark mode opsional, card-centric, element-tinted

---

## DAFTAR ISI

1. Design Language & Visi Estetika
2. Color System
3. Typography
4. Spacing & Grid
5. Component Library
6. Screen-by-Screen Specification
7. Animation & Motion
8. Flutter Package yang Dipakai
9. Anti-Patterns
10. Asset & Icon Specification

---

## 1. DESIGN LANGUAGE & VISI ESTETIKA

### 1.1 Satu Kalimat Estetika
> "Dunia nyata yang tertangkap kamera, disajikan dalam kartu fantasi yang bersih dan hidup."

### 1.2 Kata Kunci Visual
- **Clean** — banyak whitespace, tidak ramai
- **Tinted** — background card berubah warna sesuai elemen creature (seperti referensi: Venusaur = hijau, Charizard = oranye)
- **Readable** — stat dan nama creature dibaca dalam 1 detik
- **Playful tapi tidak childish** — rounded corner, warna hidup, tapi tipografi tegas

### 1.3 Inspirasi Visual dari Referensi
Dari gambar referensi yang diberikan, ciri khas desain yang diadopsi:
- Background card berwarna solid sesuai tipe (hijau untuk Nature, oranye untuk Fire)
- Artwork creature ditampilkan besar, setengah keluar dari card
- Detail stats (Height, Weight, Category, Abilities) dalam grid 2 kolom
- Number badge (No.003) dengan font tipis dan muted
- Type badge berbentuk pill dengan ikon dan warna berbeda per tipe
- Bottom stat bar horizontal (biru & ungu gradient dalam referensi → kita gunakan solid color per elemen)

---

## 2. COLOR SYSTEM

### 2.1 Neutral Palette (Base UI)

```dart
// lib/core/theme/app_colors.dart

class AppColors {
  // Neutrals
  static const Color background   = Color(0xFFF5F5F5); // Abu sangat terang
  static const Color surface      = Color(0xFFFFFFFF); // Card putih
  static const Color surfaceDim   = Color(0xFFF0F0F0); // Divider, subtle bg
  static const Color onSurface    = Color(0xFF1A1A2E); // Teks utama (near-black biru)
  static const Color onSurfaceMed = Color(0xFF6B6B8A); // Teks sekunder
  static const Color onSurfaceLow = Color(0xFFABABBF); // Teks muted, placeholder

  // Overlay
  static const Color scrim        = Color(0x80000000); // Modal backdrop
}
```

### 2.2 Element Color Palette

Ini adalah warna utama yang mewarnai card creature — mirip dengan referensi Pokémon tipe hijau/oranye.

```dart
class ElementColors {
  // Setiap elemen punya: background (terang), primary (solid), text (dark)

  static const Map<String, ElementPalette> palettes = {
    'fire': ElementPalette(
      background: Color(0xFFFFEBE0), // Peach terang
      primary:    Color(0xFFFF6B35), // Oranye hidup
      gradient:   Color(0xFFFF4500), // Gradient ujung
      text:       Color(0xFF8B2500), // Teks di atas bg
      badgeText:  Color(0xFFFFFFFF),
    ),
    'water': ElementPalette(
      background: Color(0xFFE0F4FF),
      primary:    Color(0xFF2196F3),
      gradient:   Color(0xFF0D47A1),
      text:       Color(0xFF0A2E6E),
      badgeText:  Color(0xFFFFFFFF),
    ),
    'nature': ElementPalette(
      background: Color(0xFFE8F5E9),
      primary:    Color(0xFF4CAF50),
      gradient:   Color(0xFF1B5E20),
      text:       Color(0xFF1B5E20),
      badgeText:  Color(0xFFFFFFFF),
    ),
    'electric': ElementPalette(
      background: Color(0xFFFFFDE7),
      primary:    Color(0xFFFFD600),
      gradient:   Color(0xFFF57F17),
      text:       Color(0xFF6D4C00),
      badgeText:  Color(0xFF3D2800),
    ),
    'shadow': ElementPalette(
      background: Color(0xFFEDE7F6),
      primary:    Color(0xFF7B1FA2),
      gradient:   Color(0xFF311B92),
      text:       Color(0xFF1A0033),
      badgeText:  Color(0xFFFFFFFF),
    ),
    'light': ElementPalette(
      background: Color(0xFFFFFDE7),
      primary:    Color(0xFFFFEB3B),
      gradient:   Color(0xFFFBC02D),
      text:       Color(0xFF4A3700),
      badgeText:  Color(0xFF4A3700),
    ),
    'wind': ElementPalette(
      background: Color(0xFFE3F2FD),
      primary:    Color(0xFF29B6F6),
      gradient:   Color(0xFF01579B),
      text:       Color(0xFF003060),
      badgeText:  Color(0xFFFFFFFF),
    ),
    'earth': ElementPalette(
      background: Color(0xFFFBE9E7),
      primary:    Color(0xFF8D6E63),
      gradient:   Color(0xFF3E2723),
      text:       Color(0xFF3E2723),
      badgeText:  Color(0xFFFFFFFF),
    ),
    'ice': ElementPalette(
      background: Color(0xFFE0F7FA),
      primary:    Color(0xFF80DEEA),
      gradient:   Color(0xFF006064),
      text:       Color(0xFF004D54),
      badgeText:  Color(0xFF004D54),
    ),
    'poison': ElementPalette(
      background: Color(0xFFF3E5F5),
      primary:    Color(0xFFAB47BC),
      gradient:   Color(0xFF6A1B9A),
      text:       Color(0xFF3A0060),
      badgeText:  Color(0xFFFFFFFF),
    ),
    'unknown': ElementPalette(
      background: Color(0xFFF5F5F5),
      primary:    Color(0xFF9E9E9E),
      gradient:   Color(0xFF424242),
      text:       Color(0xFF212121),
      badgeText:  Color(0xFFFFFFFF),
    ),
  };
}
```

### 2.3 Rarity Color System

```dart
class RarityColors {
  static const Map<String, RarityPalette> palettes = {
    'common': RarityPalette(
      color:     Color(0xFF9E9E9E),
      shimmer:   Color(0xFFBDBDBD),
      label:     'Common',
    ),
    'rare': RarityPalette(
      color:     Color(0xFF2196F3),
      shimmer:   Color(0xFF64B5F6),
      label:     'Rare',
    ),
    'epic': RarityPalette(
      color:     Color(0xFF9C27B0),
      shimmer:   Color(0xFFCE93D8),
      label:     'Epic',
    ),
    'legendary': RarityPalette(
      color:     Color(0xFFFFD600),
      shimmer:   Color(0xFFFFEE58),
      label:     'Legendary',
    ),
  };
}
```

### 2.4 Semantic / UI Colors

```dart
class SemanticColors {
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color error   = Color(0xFFF44336);
  static const Color info    = Color(0xFF2196F3);

  // HP bar color (berubah sesuai persentase)
  static Color hpColor(double percent) {
    if (percent > 0.5) return const Color(0xFF4CAF50); // Hijau
    if (percent > 0.2) return const Color(0xFFFF9800); // Oranye
    return const Color(0xFFF44336);                    // Merah
  }
}
```

---

## 3. TYPOGRAPHY

### 3.1 Font Families

```yaml
# pubspec.yaml
fonts:
  - family: Nunito
    fonts:
      - asset: assets/fonts/Nunito-Regular.ttf    # weight: 400
      - asset: assets/fonts/Nunito-Medium.ttf     # weight: 500
      - asset: assets/fonts/Nunito-SemiBold.ttf   # weight: 600
      - asset: assets/fonts/Nunito-Bold.ttf       # weight: 700
      - asset: assets/fonts/Nunito-ExtraBold.ttf  # weight: 800

  - family: JetBrainsMono
    fonts:
      - asset: assets/fonts/JetBrainsMono-Regular.ttf
      - asset: assets/fonts/JetBrainsMono-Bold.ttf
```

**Kenapa Nunito?**
- Rounded letterform = friendly, playful tapi tidak childish
- Cocok untuk dark background maupun terang
- Dipakai di banyak game UI mobile (mirip dengan referensi)

**Kenapa JetBrains Mono?**
- Untuk angka stat (HP, ATK, DEF) agar tampak presisi seperti game
- Monospace = angka selalu rata/sejajar di list

### 3.2 Type Scale

```dart
class AppTextStyles {
  // Display — nama creature di detail page
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 32,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.1,
  );

  // Heading — judul section, nama di card
  static const TextStyle headingLarge = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.2,
  );

  static const TextStyle headingMedium = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  // Body — deskripsi, flavor text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.6,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // Label — badge elemen, label stat
  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // Stat numbers — HP angka, ATK angka
  static const TextStyle statNumber = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
  );

  static const TextStyle statNumberLarge = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: -1,
  );

  // Number badge — No.003 style
  static const TextStyle numberBadge = TextStyle(
    fontFamily: 'Nunito',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    letterSpacing: 1.0,
  );
}
```

---

## 4. SPACING & GRID

### 4.1 Spacing Scale (8pt grid)

```dart
class AppSpacing {
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;
  static const double xxl = 48.0;

  // Padding halaman utama
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: 20.0,
    vertical: 16.0,
  );

  // Padding card
  static const EdgeInsets cardPadding = EdgeInsets.all(20.0);
  static const EdgeInsets cardPaddingSmall = EdgeInsets.all(12.0);
}
```

### 4.2 Border Radius

```dart
class AppRadius {
  static const double xs   = 8.0;
  static const double sm   = 12.0;
  static const double md   = 20.0;   // Dipakai di creature card
  static const double lg   = 28.0;   // Dipakai di bottom sheet
  static const double full = 100.0;  // Pill badge (elemen, rarity)

  static const BorderRadius cardRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius pillRadius = BorderRadius.all(Radius.circular(full));
}
```

### 4.3 Elevation & Shadow

```dart
class AppShadows {
  // Card normal
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: Color(0x08000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  // Card yang sedang dipilih / active
  static List<BoxShadow> cardShadowColored(Color elementColor) => [
    BoxShadow(
      color: elementColor.withOpacity(0.30),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: elementColor.withOpacity(0.10),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  // Bottom navigation bar
  static const List<BoxShadow> navBarShadow = [
    BoxShadow(
      color: Color(0x18000000),
      blurRadius: 24,
      offset: Offset(0, -4),
    ),
  ];
}
```

---

## 5. COMPONENT LIBRARY

### 5.1 CreatureCard (Komponen paling utama)

Terinspirasi langsung dari referensi: card berwarna sesuai elemen, artwork besar, nama & nomor di atas.

```dart
// Struktur visual CreatureCard:
//
// ┌─────────────────────────────────────┐
// │  [BACKGROUND: element color tint]   │
// │                                     │
// │  No.001          [♡ favorite]       │
// │  "Umbren Claw"                      │
// │  [Shadow] [Epic]                    │ ← type badges (pill)
// │                                     │
// │              [ARTWORK]              │ ← 180×180dp, pakai foto asli
// │            (melayang setengah       │   dengan element frame
// │             keluar dari card)       │
// └─────────────────────────────────────┘
//           ↕ artwork overflow

// Code ringkas:
class CreatureCard extends StatelessWidget {
  final Creature creature;
  final VoidCallback? onTap;
  final bool showFull; // false = grid card, true = detail card

  Widget build(BuildContext context) {
    final palette = ElementColors.palettes[creature.element]!;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: palette.background,
          borderRadius: AppRadius.cardRadius,
          boxShadow: AppShadows.cardShadowColored(palette.primary),
        ),
        child: Stack(children: [
          _buildBackground(palette),   // pattern/texture subtle
          _buildContent(palette),      // teks & badges
          _buildArtwork(),             // foto creature
        ]),
      ),
    );
  }
}
```

**Spesifikasi CreatureCard ukuran Grid (untuk halaman koleksi):**
- Size: lebar mengisi kolom (2 kolom), tinggi 200dp
- Artwork: 120×120dp, overflow ke atas 20dp
- Padding dalam: 12dp
- Font nama: headingMedium (18px, bold)
- Font no: numberBadge (13px, muted)

**Spesifikasi CreatureCard ukuran Detail (halaman detail creature):**
- Width: full screen
- Height: 280dp
- Artwork: 200×200dp, overflow ke atas 40dp
- Padding dalam: 20dp
- Font nama: headingLarge (22px, bold) → displayLarge (32px) di hero section

---

### 5.2 ElementBadge

Pill badge untuk menampilkan elemen creature. Persis seperti referensi "Grass", "Poison", "Fire", "Air".

```dart
// Tampilan:
// ┌──────────────────┐
// │  🔥  Fire        │ ← ikon + teks dalam pill
// └──────────────────┘

class ElementBadge extends StatelessWidget {
  final String element;

  // Spesifikasi:
  // - Height: 28dp
  // - Padding: horizontal 12dp, vertical 6dp
  // - Border radius: 100dp (pill penuh)
  // - Background: palette.primary
  // - Text color: palette.badgeText
  // - Font: labelLarge (13px, semibold)
  // - Ikon: 14dp, sebelum teks
  // - Gap ikon-teks: 4dp
}

// Ikon per elemen (gunakan SVG asset custom):
const Map<String, String> elementIcons = {
  'fire':     'assets/icons/elem_fire.svg',
  'water':    'assets/icons/elem_water.svg',
  'nature':   'assets/icons/elem_nature.svg',
  'electric': 'assets/icons/elem_electric.svg',
  'shadow':   'assets/icons/elem_shadow.svg',
  'light':    'assets/icons/elem_light.svg',
  'wind':     'assets/icons/elem_wind.svg',
  'earth':    'assets/icons/elem_earth.svg',
  'ice':      'assets/icons/elem_ice.svg',
  'poison':   'assets/icons/elem_poison.svg',
};
```

---

### 5.3 RarityBadge

Berbeda dari ElementBadge — ini menunjukkan kelangkaan, bukan tipe. Ditampilkan bersamaan.

```dart
// Tampilan:
// ┌────────────┐
// │  ★  Epic  │ ← bintang + teks
// └────────────┘

// Spesifikasi:
// - Background: transparent, dengan border 1.5dp
// - Border color: rarity.color
// - Text color: rarity.color
// - Ikon: bintang (★ Unicode atau SVG)
// - Ukuran sama dengan ElementBadge (28dp tinggi)
```

---

### 5.4 StatBar

Komponen bar HP/ATK/DEF/SPD. Mengacu pada style referensi — bar horizontal dengan warna solid.

```dart
// Tampilan:
// ATK  [████████░░░░]  112 / 220
//       ↑ bar berwarna  ↑ angka dengan JetBrains Mono

class StatBar extends StatelessWidget {
  final String label;
  final int value;
  final int maxValue;
  final Color color;

  // Spesifikasi:
  // - Label: bodyMedium (13px), width: 40dp fixed, right-aligned, muted color
  // - Gap label-bar: 8dp
  // - Bar background: Color(0xFFE8E8F0) — abu muted
  // - Bar fill: gradient dari color ke color.withOpacity(0.7)
  // - Bar height: 8dp
  // - Bar border radius: 100dp
  // - Animasi fill: 600ms dengan curve Curves.easeOut saat pertama mount
  // - Angka: statNumber, right-aligned, width: 56dp
  // - Format angka: "$value" (tanpa padding)

  // Row layout:
  // [Label 40dp] [Gap 8dp] [Bar flex:1] [Gap 8dp] [Value 56dp]
}
```

---

### 5.5 StatGrid (2×2 untuk detail page)

Seperti referensi: Height, Weight, Category, Abilities dalam grid 2 kolom.

```dart
// Tampilan:
// ┌───────────────┬───────────────┐
// │ ↕ Height      │ ⚖ Weight      │
// │   1.2 m       │   4.2 kg      │
// ├───────────────┼───────────────┤
// │ ◉ Category    │ ⚡ Abilities   │
// │   Shadow      │   Night Slash │
// └───────────────┴───────────────┘

// Spesifikasi per cell:
// - Background: Colors.white (atau surface)
// - Padding: 16dp semua sisi
// - Label (atas): labelSmall (11px, semibold, muted) + ikon 12dp
// - Value (bawah): bodyLarge (15px, semibold, onSurface)
// - Divider antara cell: 1dp garis vertikal dan horizontal, warna surfaceDim
// - Border radius grup: 12dp
```

---

### 5.6 CaptureButton

Tombol kamera utama di CaptureScreen — ini adalah elemen paling ikonik di app.

```dart
// Tampilan:
//
//        ┌───────────────────────────────┐
//        │  [VIEWFINDER AKTIF]           │
//        │                               │
//        │  [Crosshair target di tengah] │
//        │                               │
//        └───────────────────────────────┘
//
//  [galeri]   ◉ [CAPTURE]   [flash toggle]
//              ↑ tombol utama

// Spesifikasi CaptureButton:
// - Ukuran: 72×72dp
// - Shape: lingkaran
// - Background: Color(0xFFFF6B35) — orange primary
// - Ikon di dalam: kamera (24dp, putih)
// - Inner ring: 4dp gap + 2dp border putih (seperti tombol kamera native)
// - State loading: CircularProgressIndicator putih menggantikan ikon
// - State scanning: ikon berubah ke radar/scanning animation

// Capture state machine:
// IDLE → onPressed → SCANNING (AI) → SUCCESS → REVEAL
//                                  ↘ FAILED → ERROR_FEEDBACK
```

---

### 5.7 RevealModal

Animasi ketika creature baru berhasil di-generate. Ini adalah "money moment" — harus memorable.

```dart
// Flow animasi (sequential):
// 1. Background blur + darken (300ms)
// 2. Egg/cocoon muncul dari bawah (400ms, easeOutBack)
// 3. Egg shake/vibrate (500ms)
// 4. CRACK — split effect (200ms, cepat)
// 5. FLASH putih singkat (100ms)
// 6. Creature muncul dengan scale dari 0.5→1.0 (400ms, easeOutBack)
// 7. Rarity reveal: ring glow muncul sesuai rarity
// 8. Nama creature muncul dari bawah (300ms, fadeUp)
// 9. Element badge + rarity badge fade in (200ms)
// 10. Tombol "Tambah ke koleksi" muncul (200ms)

// Untuk Legendary: tambahkan:
// - Full-screen particle confetti (gunakan confetti package)
// - Background glow emas
// - Sound effect (opsional Phase 2)

// Warna background reveal sesuai elemen creature:
// Fire Legendary → background gradient oranye-merah gelap
// Shadow Epic    → background gradient ungu-hitam
```

---

### 5.8 BottomNavBar

```dart
// 5 tab: Home, Capture, Battle, Collection, Profile
// Spesifikasi:
// - Background: Colors.white dengan shadow atas
// - Height: 72dp (termasuk safe area padding)
// - Item aktif: ikon warna primary + label visible
// - Item inaktif: ikon abu muted + label hidden (atau sangat kecil)
// - Capture tab (tengah) BERBEDA:
//   → Ikon lebih besar (32dp vs 24dp)
//   → Background pill oranye di belakang ikon
//   → Slightly raised / floating effect
//   → Ini seperti FAB yang terintegrasi ke navbar

// Contoh implementasi capture tab:
Widget _buildCaptureTab() {
  return Container(
    width: 56,
    height: 56,
    decoration: BoxDecoration(
      color: AppColors.captureOrange, // #FF6B35
      borderRadius: BorderRadius.circular(16),
      boxShadow: AppShadows.cardShadowColored(AppColors.captureOrange),
    ),
    child: Icon(Icons.camera_alt_rounded, color: Colors.white, size: 28),
  );
}
```

---

### 5.9 AppBar per Screen

```dart
// Default AppBar spec:
// - Background: Colors.transparent (mengikuti warna halaman)
// - Elevation: 0
// - Leading: back arrow (IconButton, 44×44 tap target)
// - Title: headingMedium, center-aligned
// - Actions: max 2 ikon

// HomeScreen AppBar (khusus):
// - Tidak ada back button
// - Kiri: avatar hunter (CircleAvatar 40dp)
// - Kanan: notifikasi ikon + hunter level badge
// - Bawah AppBar: greeting "Selamat datang, [nama]"
```

---

## 6. SCREEN-BY-SCREEN SPECIFICATION

### 6.1 HomeScreen

```
STATUS BAR
━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Avatar]  Selamat datang,          [🔔]
          Lazuardi!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━

HUNTER CARD (full width, 120dp tinggi)
┌──────────────────────────────────────┐
│  Lv. 12 · 2,450 / 3,000 XP         │
│  [XP bar full width]                 │
│  🔥 Streak 5 hari · 🏆 12 kreatur  │
└──────────────────────────────────────┘

DAILY MISSION (section)
"Misi Hari Ini"                [Lihat semua →]
┌──────────────────┐ ┌──────────────────┐
│ ✓ Login harian   │ │ ○ Tangkap burung │
│   Selesai        │ │   0/1            │
└──────────────────┘ └──────────────────┘

KOLEKSI TERAKHIR (section, horizontal scroll)
"Kreaturmu"                    [Lihat semua →]
──────────────────────────────────────────────
 [Card] [Card] [Card] [Card]  → scroll
──────────────────────────────────────────────

BESTIARY PROGRESS (section)
"Koleksi Spesies"
  [Progress bar]  18 / 50 spesies ditemukan

━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[🏠] [📷 capture] [⚔] [📚] [👤]
    BOTTOM NAV
```

**Warna HomeScreen:** Background `#F5F5F5`, semua card putih dengan shadow ringan.

---

### 6.2 CaptureScreen

```
[← Kembali]    KAMERA         [⚡ Flash]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
│                                   │
│         VIEWFINDER PENUH          │
│                                   │
│    ┌ ─ ─ ─ ─ ─ ─ ─ ─ ┐           │
│                                   │
│    │   [CROSSHAIR]    │           │
│         TARGET                    │
│    │                  │           │
│    └ ─ ─ ─ ─ ─ ─ ─ ─ ┘           │
│                                   │
│  "Arahkan ke hewan..."            │
│                                   │
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[📷 galeri]   ◉ CAPTURE   [☀ exposure]
```

**State SCANNING (setelah capture):**
```
[Foto blur/dimmed di background]
        ┌─────────────────────┐
        │   🔍 Menganalisis   │
        │   hewan...          │
        │   [Progress bar]    │
        │   "AI mendeteksi    │
        │    jenis spesies"   │
        └─────────────────────┘
```

**Warna CaptureScreen:** Background = live camera feed. UI overlay = gelap semi-transparent.

---

### 6.3 Creature Detail Screen

```
[← Kembali]                     [♡]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
┌─────────────────────────────────┐
│ [BACKGROUND: element tint]      │  ← 280dp tinggi
│                                 │
│  No.042                    [♡] │
│  Umbren Claw                   │
│  [Shadow] [Epic]               │
│                                 │
│          [ARTWORK/FOTO]         │  ← overflow 40dp ke bawah
└─────────────────────────────────┘

      ↕ artwork overflow

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [STAT SECTION - putih background]

  ABOUT
  ┌──────────────┬──────────────┐
  │ ↕ Species    │ ⚡ Element    │
  │  Kucing Dom. │  Shadow      │
  ├──────────────┼──────────────┤
  │ 📅 Captured  │ 📍 Lokasi    │
  │  12 Des 2024 │  Sumedang    │
  └──────────────┴──────────────┘

  STATS
  HP   [████████░░░░]  145 / 260
  ATK  [██████░░░░░░]  112 / 220
  DEF  [████░░░░░░░░]   78 / 200
  SPD  [███████░░░░░]  134 / 230

  IV Quality  ████████░░  81% "Great"

  SKILLS
  ┌─────────────────────────────────┐
  │ [Shadow] Shadow Claw    70 PWR │
  │ PP: 8/8  ·  90% akurasi        │
  └─────────────────────────────────┘
  ┌─────────────────────────────────┐
  │ [Dark] Night Slash      60 PWR │
  │ PP: 10/10  ·  95% akurasi      │
  └─────────────────────────────────┘

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  [Rename]    [Set ke Tim]    [Share]
  (ghost btn)  (primary btn)  (ghost)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### 6.4 Collection Screen

```
[← ]  Koleksiku               [Filter ▼]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Semua] [Fire] [Water] [Shadow] ···
────────── TAB filter elemen ────────
┌──────────────┐  ┌──────────────┐
│  CreatureCard│  │  CreatureCard│
│  (grid 2kol) │  │              │
└──────────────┘  └──────────────┘
┌──────────────┐  ┌──────────────┐
│  CreatureCard│  │  CreatureCard│
└──────────────┘  └──────────────┘
         ... scroll ...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SORT OPTIONS (bottom sheet saat klik filter):
- Terbaru (default)
- Rarity (Legendary dulu)
- Level tertinggi
- Nama A-Z
- Elemen
```

**Grid Card spec:**
- 2 kolom dengan gap 12dp
- Card height: 200dp
- Artwork overflow 20dp ke atas

---

### 6.5 Bestiary Screen

```
[← ]  Bestiary              [Search 🔍]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 18 / 50 spesies ditemukan
 [Progress bar full width, 8dp tinggi]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[Semua] [Mamalia] [Burung] [Reptil]
────────────────────────────────────
┌──────────────┐  ┌──────────────┐
│  [Foto/ikon] │  │  [Silhouette]│ ← belum ditemukan = hitam
│  Kucing Dom. │  │  ???         │
│  Ditemukan 3 │  │  Belum       │
└──────────────┘  └──────────────┘
```

---

## 7. ANIMATION & MOTION

### 7.1 Durasi Standar

```dart
class AppDuration {
  static const Duration fast    = Duration(milliseconds: 150);
  static const Duration normal  = Duration(milliseconds: 300);
  static const Duration slow    = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  // Khusus
  static const Duration reveal  = Duration(milliseconds: 1800); // full reveal sequence
  static const Duration statBar = Duration(milliseconds: 600);  // bar fill animation
}
```

### 7.2 Kurva Animasi

```dart
class AppCurves {
  static const Curve entrance = Curves.easeOutBack;   // element muncul
  static const Curve exit     = Curves.easeInFront;   // element menghilang
  static const Curve smooth   = Curves.easeInOut;     // transisi halaman
  static const Curve elastic  = Curves.elasticOut;    // Legendary reveal
  static const Curve statFill = Curves.easeOut;       // StatBar fill
}
```

### 7.3 Page Transitions

```dart
// Transition dari CollectionScreen → CreatureDetailScreen:
// Shared element transition (Hero widget) pada:
// - Artwork/foto creature
// - Background card (warna elemen)
// - Nama creature

// Implementasi:
Hero(
  tag: 'creature_artwork_${creature.id}',
  child: CreatureArtwork(creature: creature),
)

// Durasi transition: 400ms, curve: Curves.easeInOut
```

### 7.4 Micro-interactions

| Aksi | Animasi | Durasi |
|---|---|---|
| Tap card | Scale 0.96 → 1.0 | 150ms |
| Favorite toggle | Ikon scale 1.0 → 1.3 → 1.0 + warna berubah | 300ms |
| Tab switch | Slide + fade | 200ms |
| StatBar load | Width 0 → target, left to right | 600ms |
| Badge appear | Fade + translateY +8 → 0 | 200ms |
| Capture button | Scale 0.92 saat ditekan | 100ms |
| Level up | Number count up animation | 800ms |

---

## 8. FLUTTER PACKAGES YANG DIPAKAI

### 8.1 UI & Animation

```yaml
dependencies:
  # Animasi deklaratif — untuk reveal, fade, slide
  flutter_animate: ^4.5.0

  # Lottie animation — untuk loading scanning AI, egg crack
  lottie: ^3.1.0

  # Confetti — untuk Legendary reveal
  confetti: ^0.7.0

  # SVG renderer — untuk ikon elemen custom
  flutter_svg: ^2.0.9

  # Smooth page indicator — untuk swipe card
  smooth_page_indicator: ^1.1.0

  # Shimmer effect — untuk loading state
  shimmer: ^3.0.0

  # Screenshot — untuk generate share card
  screenshot: ^2.1.0

  # Share — untuk share ke WhatsApp/Instagram
  share_plus: ^9.0.0
```

### 8.2 Styling Helper

```yaml
  # Gap widget (SizedBox shorthand)
  gap: ^3.0.1

  # Google Fonts (jika tidak embed Nunito manual)
  google_fonts: ^6.2.1

  # Cached network image (untuk future online feature)
  cached_network_image: ^3.3.1

  # Image compress — sebelum simpan ke storage
  flutter_image_compress: ^2.2.0
```

### 8.3 Utility

```yaml
  # Riverpod — state management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # GoRouter — navigation
  go_router: ^13.2.0

  # Hive — local database
  hive_flutter: ^1.1.0

  # Camera
  camera: ^0.10.5

  # Path provider
  path_provider: ^2.1.2
```

---

## 9. ANTI-PATTERNS (YANG HARUS DIHINDARI)

### 9.1 Visual Anti-patterns

```
❌ JANGAN gunakan default Material Card tanpa modifikasi
   → Selalu gunakan Container dengan BoxDecoration custom

❌ JANGAN gunakan warna putih untuk teks di atas element background terang
   → Cek palette.text per elemen

❌ JANGAN tumpuk badge terlalu banyak dalam 1 card
   → Max 2 badge per card (1 elemen + 1 rarity)

❌ JANGAN gunakan ListTile default untuk stat
   → Buat StatBar custom dengan JetBrains Mono

❌ JANGAN gunakan AppBar default Material
   → Selalu transparent + elevation 0

❌ JANGAN gunakan SnackBar default untuk feedback capture gagal
   → Gunakan custom bottom notification dengan ikon + warna sesuai konteks

❌ JANGAN pakai border radius 0 kecuali untuk UI khas (misal: full-bleed image)
   → Default 12–20dp untuk semua container

❌ JANGAN pakai warna abu-abu default Flutter (Colors.grey) 
   → Selalu gunakan AppColors atau ElementColors
```

### 9.2 UX Anti-patterns

```
❌ JANGAN langsung masuk ke kamera tanpa permission check yang ramah
   → Tampilkan illustration + penjelasan sebelum request permission

❌ JANGAN tampilkan loading spinner polos selama AI scanning
   → Tampilkan "AI sedang menganalisis..." dengan progress + tips foto bagus

❌ JANGAN biarkan reveal terlalu cepat
   → Suspensi adalah fitur — minimal 1.5 detik sebelum creature muncul

❌ JANGAN overflow konten tanpa scroll container
   → Detail screen harus dalam SingleChildScrollView

❌ JANGAN disable tombol tanpa penjelasan kenapa
   → Tampilkan tooltip atau inline message
```

---

## 10. ASSET & ICON SPECIFICATION

### 10.1 Struktur Asset

```
assets/
├── fonts/
│   ├── Nunito-Regular.ttf
│   ├── Nunito-Bold.ttf
│   ├── Nunito-ExtraBold.ttf
│   └── JetBrainsMono-Regular.ttf
│
├── icons/
│   ├── elem_fire.svg
│   ├── elem_water.svg
│   ├── elem_nature.svg
│   ├── elem_electric.svg
│   ├── elem_shadow.svg
│   ├── elem_light.svg
│   ├── elem_wind.svg
│   ├── elem_earth.svg
│   ├── elem_ice.svg
│   ├── elem_poison.svg
│   ├── rarity_star.svg
│   └── capture_target.svg  ← crosshair kamera
│
├── animations/
│   ├── ai_scanning.json    ← Lottie: radar scan effect
│   ├── egg_crack.json      ← Lottie: reveal sequence
│   ├── level_up.json       ← Lottie: level up burst
│   └── legendary_aura.json ← Lottie: legendary glow
│
├── images/
│   ├── onboarding_1.png
│   ├── onboarding_2.png
│   ├── onboarding_3.png
│   └── placeholder_creature.png ← silhouette untuk belum ditemukan
│
└── backgrounds/
    └── card_pattern.svg    ← subtle dot pattern untuk card bg
```

### 10.2 Lottie Animation Sources (Gratis)

| File | Sumber | Keterangan |
|---|---|---|
| ai_scanning.json | LottieFiles.com — search "radar scan" | Gratis |
| egg_crack.json | LottieFiles.com — search "egg reveal" | Gratis |
| level_up.json | LottieFiles.com — search "level up star" | Gratis |
| legendary_aura.json | LottieFiles.com — search "golden glow" | Gratis |

### 10.3 Ikon Elemen (SVG Simple)

Buat sendiri atau download dari Flaticon/SVGRepo. Spec:
- Size: 24×24dp viewBox
- Style: outlined (bukan filled), 2dp stroke width
- Warna: currentColor (agar bisa di-override dari Flutter)

### 10.4 App Icon Spec

```
Main icon: 1024×1024px
Background: Color(0xFF1A1A2E) — near-black biru
Foreground: Gambar kamera dengan "lingkaran target" yang berubah jadi creature
Style: Flat illustration, bukan foto
Adaptive icon (Android): Foreground layer + background layer terpisah
```

---

## QUICK REFERENCE — DESIGN TOKENS

```dart
// Copy-paste ready tokens

// Warna elemen (background card):
// Fire:     Color(0xFFFFEBE0)
// Water:    Color(0xFFE0F4FF)
// Nature:   Color(0xFFE8F5E9)
// Electric: Color(0xFFFFFDE7)
// Shadow:   Color(0xFFEDE7F6)
// Light:    Color(0xFFFFFDE7)
// Earth:    Color(0xFFFBE9E7)
// Ice:      Color(0xFFE0F7FA)
// Poison:   Color(0xFFF3E5F5)

// Border radius:
// Card:   20dp
// Pill:   100dp (badge)
// Panel:  28dp (bottom sheet)

// Font:
// Nama creature: Nunito ExtraBold 22–32px
// Stat number:   JetBrains Mono Bold 16–24px
// Label:         Nunito SemiBold 11–13px

// Shadow warna elemen (30% opacity):
// elementColor.withOpacity(0.30), blurRadius: 24, offset: Offset(0, 8)
```

---

*DESIGN.md v1.0.0 — RWAFC | Referensi: Pokémon Pokedex UI (Dribbble)*
*Semua warna, spacing, dan komponen di sini siap diimplementasikan langsung di Flutter.*
