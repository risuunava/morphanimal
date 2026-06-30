# DESIGN.md — Real World Animal Fantasy Collector (RWAFC)
## Design System & UI Specification v2.0.0

**Referensi Visual:** Pokedex App UI — full-bleed gradient hero, clean white detail sheet
**Framework:** Flutter 3.19+ dengan Material 3
**Status:** Rewrite total — replikasi 1:1 dari referensi (Charizard/Suicune/Serperior card)

---

## PERUBAHAN DARI v1.0

Versi ini menggantikan total pendekatan v1.0. Perbedaan utama:

| Aspek | v1.0 (lama) | v2.0 (baru, sesuai referensi) |
|---|---|---|
| Card style | Card kecil dengan tint bg lembut | **Full-bleed gradient** mengisi setengah atas layar |
| Layout | Grid card kompak | **Single hero detail** per layar, carousel kiri-kanan |
| Warna elemen | Pastel/tint terang | **Solid gradient vivid** (oranye api, biru air, hijau racun) |
| Info hewan | Stat grid 2×2 generik | **Peso/Altura/Habilidade** + Gender bar (replikasi exact) |
| Navigasi | Bottom nav 5 tab custom | **Bottom nav 4 ikon flat** (home, pokeball, group, menu) |
| Tipografi nama | Nunito ExtraBold | **Sans-serif besar tegas**, bukan rounded-playful |

---

## DAFTAR ISI

1. Anatomi Layar Referensi (Breakdown Pixel-by-Pixel)
2. Color System — Per Elemen (Diperbaiki Total)
3. Typography
4. Spacing & Layout Grid
5. Component Library
6. Screen Specification — Creature Detail (Utama)
7. Screen Specification — Layar Lain
8. Animation & Motion
9. Flutter Packages
10. Anti-Patterns
11. Asset Specification

---

## 1. ANATOMI LAYAR REFERENSI (BREAKDOWN PIXEL-BY-PIXEL)

Dari gambar Charizard, struktur layar dari atas ke bawah:

```
┌─────────────────────────────────────┐
│ STATUS BAR (transparent, ikon putih) │
├─────────────────────────────────────┤
│ [‹ back]              [pokeball ⊕]  │ ← App bar, icon only, putih
│                                       │
│         [ELLIPSE SHADOW SAMAR]       │ ← bentuk lonjong transparan di belakang artwork
│                                       │
│            [ARTWORK BESAR]           │ ← creature, no card border, langsung di atas gradient
│         [‹]              [›]         │ ← carousel arrow kiri-kanan, circle putih translucent
│                                       │ ← GRADIENT BACKGROUND berhenti di sini (~55% tinggi layar)
├─────────────────────────────────────┤ ← garis transisi gradient → putih (sedikit curve/lengkung halus)
│  WHITE SHEET (rounded top corners)   │
│                                       │
│  Charizard                  nvl. 36  │ ← nama besar kiri, level kanan
│  #006                    EVOLUÇÃO    │ ← nomor di bawah nama, "info evolusi" di bawah level
│                                       │
│  [🔥 Fogo]    [🦅 Voador]            │ ← 2 type pill badge, ikon bulat solid + teks
│                                       │
│  Ele cospe fogo que é quente o       │ ← deskripsi flavor text, 3 baris, abu-abu
│  suficiente para derreter            │
│  pedregulhos...                      │
│                                       │
│  △ PESO      ⊥ ALTURA    ⊙ HABILIDADE│ ← 3 kolom, ikon kecil + label kecil uppercase
│  90,5 kg     1,7 m        Chama      │ ← value besar di bawah label
│                                       │
│           GÊNERO                     │ ← label center
│  [████████████░░░] gradient bar      │ ← bar gender: biru → pink, rounded pill
│  ♂ 87,5%                  ♀ 12,5%    │ ← persentase di kedua ujung
│                                       │
├─────────────────────────────────────┤
│  [⌂]      [⊕]      [⚭⚭]      [☰]    │ ← bottom nav, 4 ikon outline, flat, tanpa label
└─────────────────────────────────────┘
```

### 1.1 Detail Kunci yang Wajib Direplikasi

1. **Tidak ada card dengan border/shadow terpisah** — gradient color LANGSUNG menjadi background layar bagian atas, bukan card mengambang
2. **Artwork tanpa frame** — creature/foto ditempel langsung di atas gradient, dengan satu ellipse shadow lembut warna putih transparan di belakangnya untuk depth
3. **White sheet dengan rounded top corner** (radius besar ~28-32dp) menutupi gradient di bagian bawah — efek seperti bottom sheet yang menyatu
4. **Carousel arrows** — lingkaran putih semi-transparent dengan ikon panah, posisi vertically centered sejajar artwork
5. **Type badge** — bentuk pill dengan ikon BULAT SOLID berwarna (bukan ikon outline) di kiri, lalu teks
6. **3-column info row** (Peso/Altura/Habilidade) — bukan grid 2×2 seperti versi lama, tapi **3 kolom sejajar horizontal** dengan divider tipis vertikal antar kolom
7. **Gender bar** — satu-satunya elemen dengan gradient horizontal (biru ke pink), bentuk pill tipis
8. **Bottom nav minimalis** — 4 ikon saja, tanpa label teks, tanpa background pill di ikon aktif (beda dari desain v1.0 sebelumnya)

---

## 2. COLOR SYSTEM — PER ELEMEN (DIPERBAIKI TOTAL)

### 2.1 Kesalahan di v1.0 yang Diperbaiki

Di versi sebelumnya, warna elemen menggunakan palet pastel lembut yang **tidak mencerminkan karakter elemen** (misalnya Fire hanya peach pucat, padahal di referensi Fire = oranye vivid menyala). Versi ini memperbaiki dengan:
- Warna **solid dan vivid**, sesuai ekspektasi natural tiap elemen (api = merah-oranye membara, air = biru laut, racun = ungu toxic, dst)
- Setiap elemen punya **2 warna untuk gradient** (atas → bawah), bukan 1 warna flat
- Direct match dengan referensi: Fire = oranye Charizard, Water = biru Suicune, Nature = hijau Serperior

### 2.2 Element Gradient Palette (Final)

```dart
// lib/core/theme/element_colors.dart

class ElementPalette {
  final Color gradientTop;     // warna di bagian paling atas
  final Color gradientBottom;  // warna mendekati white sheet
  final Color badgeColor;      // warna solid untuk pill badge ikon
  final Color textOnGradient;  // teks di atas gradient (biasanya putih)
  const ElementPalette({
    required this.gradientTop,
    required this.gradientBottom,
    required this.badgeColor,
    required this.textOnGradient,
  });
}

class ElementColors {
  static const Map<String, ElementPalette> palettes = {

    // FIRE — replikasi exact dari Charizard reference (oranye membara)
    'fire': ElementPalette(
      gradientTop:    Color(0xFFFF9A3C), // oranye terang di puncak
      gradientBottom: Color(0xFFF6722A), // oranye lebih dalam mendekati sheet
      badgeColor:     Color(0xFFFF7A1A),
      textOnGradient: Color(0xFFFFFFFF),
    ),

    // WATER — replikasi exact dari Suicune reference (biru langit-laut)
    'water': ElementPalette(
      gradientTop:    Color(0xFF6FB8F0),
      gradientBottom: Color(0xFF3D8FE0),
      badgeColor:     Color(0xFF2E8BE0),
      textOnGradient: Color(0xFFFFFFFF),
    ),

    // NATURE — replikasi exact dari Serperior reference (hijau daun segar)
    'nature': ElementPalette(
      gradientTop:    Color(0xFF7ED99A),
      gradientBottom: Color(0xFF45B86A),
      badgeColor:     Color(0xFF3CA85E),
      textOnGradient: Color(0xFFFFFFFF),
    ),

    // ELECTRIC — kuning listrik vivid (bukan pastel)
    'electric': ElementPalette(
      gradientTop:    Color(0xFFFFE066),
      gradientBottom: Color(0xFFFFC93C),
      badgeColor:     Color(0xFFFFB300),
      textOnGradient: Color(0xFF4A3700), // gelap karena bg terang
    ),

    // SHADOW — ungu gelap misterius
    'shadow': ElementPalette(
      gradientTop:    Color(0xFF8B6FD9),
      gradientBottom: Color(0xFF5B3FB8),
      badgeColor:     Color(0xFF6B4FC4),
      textOnGradient: Color(0xFFFFFFFF),
    ),

    // LIGHT — kuning keemasan cerah
    'light': ElementPalette(
      gradientTop:    Color(0xFFFFF3B8),
      gradientBottom: Color(0xFFFFD96B),
      badgeColor:     Color(0xFFFFC940),
      textOnGradient: Color(0xFF5C4400),
    ),

    // WIND — biru langit pucat-cerah (beda dari water yang lebih dalam)
    'wind': ElementPalette(
      gradientTop:    Color(0xFFAEE3F5),
      gradientBottom: Color(0xFF6FC9E8),
      badgeColor:     Color(0xFF4FB8DC),
      textOnGradient: Color(0xFF003547),
    ),

    // EARTH — coklat tanah hangat
    'earth': ElementPalette(
      gradientTop:    Color(0xFFCB9B6C),
      gradientBottom: Color(0xFFA9713F),
      badgeColor:     Color(0xFF9C6A3E),
      textOnGradient: Color(0xFFFFFFFF),
    ),

    // ICE — biru es pucat-dingin
    'ice': ElementPalette(
      gradientTop:    Color(0xFFC9F1F5),
      gradientBottom: Color(0xFF8FDCE6),
      badgeColor:     Color(0xFF6BC9D6),
      textOnGradient: Color(0xFF00474D),
    ),

    // POISON — ungu toxic terang
    'poison': ElementPalette(
      gradientTop:    Color(0xFFC58AE0),
      gradientBottom: Color(0xFF9B4FC9),
      badgeColor:     Color(0xFFA855D6),
      textOnGradient: Color(0xFFFFFFFF),
    ),

    // UNKNOWN — abu netral untuk Unknown Beast
    'unknown': ElementPalette(
      gradientTop:    Color(0xFFB0B0BD),
      gradientBottom: Color(0xFF7E7E8E),
      badgeColor:     Color(0xFF6E6E80),
      textOnGradient: Color(0xFFFFFFFF),
    ),
  };
}
```

### 2.3 Gradient Implementation (Penting — Arah & Bentuk)

Sesuai referensi, gradient bukan linear lurus dari atas-bawah biasa, tapi punya sedikit **radial highlight** di area artwork agar creature terlihat menonjol:

```dart
BoxDecoration heroGradientDecoration(ElementPalette palette) {
  return BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [palette.gradientTop, palette.gradientBottom],
      stops: const [0.0, 1.0],
    ),
  );
}

// Ellipse shadow di belakang artwork (efek depth seperti referensi)
Widget artworkBackdrop() {
  return Container(
    width: 220,
    height: 140,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      gradient: RadialGradient(
        colors: [
          Colors.white.withOpacity(0.25),
          Colors.white.withOpacity(0.0),
        ],
      ),
    ),
  );
}
```

### 2.4 Neutral & UI Colors

```dart
class AppColors {
  static const Color background     = Color(0xFFFFFFFF); // white sheet
  static const Color surfaceMuted   = Color(0xFFF7F7FA);
  static const Color divider        = Color(0xFFECECF2);
  static const Color textPrimary    = Color(0xFF1C1C28);
  static const Color textSecondary  = Color(0xFF8A8A9A); // label uppercase abu
  static const Color textTertiary   = Color(0xFFB8B8C5);

  // Gender bar (selalu warna ini, tidak tergantung elemen)
  static const Color genderMale     = Color(0xFF4A90E2);
  static const Color genderFemale   = Color(0xFFF5A0B5);

  // Bottom nav
  static const Color navActive      = Color(0xFF1C1C28);
  static const Color navInactive    = Color(0xFFC4C4D0);
}
```

### 2.5 Rarity Colors (Tetap Dipertahankan dari v1.0, Tidak Berubah)

Rarity badge tampil terpisah dari type badge (ditambahkan di luar referensi asli karena RWAFC butuh sistem rarity yang tidak ada di Pokédex biasa):

```dart
class RarityColors {
  static const Map<String, Color> colors = {
    'common':    Color(0xFFAEAEB8),
    'rare':      Color(0xFF4A90E2),
    'epic':      Color(0xFFA855D6),
    'legendary': Color(0xFFFFB300),
  };
}
```

---

## 3. TYPOGRAPHY

### 3.1 Font Family

Referensi menggunakan sans-serif geometris tegas (mirip **Poppins** atau **Plus Jakarta Sans**), BUKAN font rounded-playful seperti Nunito di versi sebelumnya.

```yaml
fonts:
  - family: PlusJakartaSans
    fonts:
      - asset: assets/fonts/PlusJakartaSans-Regular.ttf   # 400
      - asset: assets/fonts/PlusJakartaSans-Medium.ttf    # 500
      - asset: assets/fonts/PlusJakartaSans-SemiBold.ttf  # 600
      - asset: assets/fonts/PlusJakartaSans-Bold.ttf      # 700
      - asset: assets/fonts/PlusJakartaSans-ExtraBold.ttf # 800
```

**Kenapa ganti dari Nunito ke Plus Jakarta Sans?**
Nama creature di referensi ("Charizard", "Suicune", "Serperior") menggunakan huruf tegas dengan sedikit kontras stroke, bukan bulat playful. Plus Jakarta Sans (gratis di Google Fonts) memberikan kesan modern-clean yang identik.

### 3.2 Type Scale

```dart
class AppTextStyles {
  // Nama creature — paling dominan di layar
  static const TextStyle creatureName = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 28,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
    height: 1.1,
  );

  // Level "nvl. 36"
  static const TextStyle levelText = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // "EVOLUÇÃO" kecil di bawah level
  static const TextStyle microLabel = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 10,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.8,
    color: AppColors.textTertiary,
  );

  // Nomor "#006"
  static const TextStyle idNumber = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // Badge teks "Fogo", "Voador"
  static const TextStyle badgeLabel = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Deskripsi flavor text
  static const TextStyle description = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 13.5,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.55,
  );

  // Label uppercase kecil (PESO, ALTURA, HABILIDADE, GÊNERO)
  static const TextStyle infoLabel = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 10.5,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
    color: AppColors.textTertiary,
  );

  // Value besar di bawah label (90,5 kg / 1,7 m / Chama)
  static const TextStyle infoValue = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 15,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  // Persentase gender
  static const TextStyle genderPercent = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
}
```

---

## 4. SPACING & LAYOUT GRID

### 4.1 Proporsi Layar (Sangat Penting — Ini Yang Membuat Mirip Referensi)

```dart
class HeroLayoutSpec {
  // Persentase tinggi layar yang diisi gradient (dari status bar)
  static const double gradientHeightRatio = 0.50; // ~50-55% layar

  // White sheet overlap ke atas gradient (untuk membuat efek menyatu)
  static const double sheetOverlapTop = 28.0; // rounded corner radius

  // Artwork
  static const double artworkSize = 200.0;       // tinggi artwork utama
  static const double artworkBottomOverflow = 0.0; // TIDAK overflow ke white sheet (beda dari v1.0!)
  static const double artworkTopPadding = 70.0;   // jarak dari app bar ke pucuk artwork
}
```

⚠️ **Perbedaan krusial dari v1.0:** Di referensi baru ini, artwork **tidak overflow keluar card** seperti desain Pokémon-card lama. Artwork sepenuhnya berada di dalam area gradient, dan white sheet dimulai bersih di bawahnya.

### 4.2 Spacing Scale

```dart
class AppSpacing {
  static const double xs  = 4.0;
  static const double sm  = 8.0;
  static const double md  = 16.0;
  static const double lg  = 24.0;
  static const double xl  = 32.0;

  static const EdgeInsets sheetPadding = EdgeInsets.fromLTRB(24, 28, 24, 16);
  static const EdgeInsets appBarPadding = EdgeInsets.fromLTRB(20, 16, 20, 0);
}
```

### 4.3 Border Radius

```dart
class AppRadius {
  static const double sheetTop   = 32.0;  // rounded corner white sheet (besar, sesuai referensi)
  static const double badgePill  = 100.0; // type badge, full pill
  static const double iconCircle = 100.0; // carousel arrow button
  static const double genderBar  = 100.0;
}
```

---

## 5. COMPONENT LIBRARY

### 5.1 HeroGradientHeader

Komponen paling penting — pengganti total `CreatureCard` dari v1.0.

```dart
// Struktur:
// Container(gradient) 
//   → SafeArea
//     → AppBar custom (back + pokeball icon kanan)
//     → Center: artwork + ellipse backdrop
//     → Carousel arrows kiri-kanan, vertically center ke artwork

class HeroGradientHeader extends StatelessWidget {
  final Creature creature;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  Widget build(BuildContext context) {
    final palette = ElementColors.palettes[creature.element]!;
    return Container(
      height: MediaQuery.of(context).size.height * 0.50,
      decoration: heroGradientDecoration(palette),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),           // back + pokeball icon
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  artworkBackdrop(),                    // ellipse glow
                  Image.file(File(creature.rawImagePath),
                      height: HeroLayoutSpec.artworkSize,
                      fit: BoxFit.contain),
                  Positioned(left: 12, child: _carouselButton(Icons.chevron_left, onPrev)),
                  Positioned(right: 12, child: _carouselButton(Icons.chevron_right, onNext)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Spesifikasi _buildTopBar():**
- Height: 56dp
- Back button: lingkaran 36×36dp, background `Colors.white.withOpacity(0.2)`, ikon putih
- Pokeball icon (kanan): sama style, tapi isi ikon custom pokeball/capture (ganti dengan ikon app RWAFC, misal logo "target capture")
- Padding horizontal: 20dp

**Spesifikasi _carouselButton():**
- Size: 40×40dp
- Background: `Colors.white.withOpacity(0.25)`
- Border: 1dp `Colors.white.withOpacity(0.4)`
- Ikon: 20dp, putih

---

### 5.2 WhiteDetailSheet

```dart
class WhiteDetailSheet extends StatelessWidget {
  final Creature creature;

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppRadius.sheetTop),
          topRight: Radius.circular(AppRadius.sheetTop),
        ),
      ),
      transform: Matrix4.translationValues(0, -AppRadius.sheetTop, 0), // overlap ke gradient
      padding: AppSpacing.sheetPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNameRow(),       // nama kiri, level kanan
          _buildIdEvolutionRow(),// #006 kiri, EVOLUÇÃO kanan
          const Gap(16),
          _buildTypeBadges(),    // Fogo, Voador
          const Gap(16),
          _buildDescription(),   // flavor text
          const Gap(20),
          _buildInfoRow(),       // Peso/Altura/Habilidade 3 kolom
          const Gap(20),
          _buildGenderSection(), // Gênero bar
        ],
      ),
    );
  }
}
```

---

### 5.3 NameRow & IdEvolutionRow

```dart
// _buildNameRow():
// Row(
//   MainAxisAlignment.spaceBetween,
//   children: [
//     Text(creature.creatureName, style: AppTextStyles.creatureName),
//     Text('nvl. ${creature.level}', style: AppTextStyles.levelText),
//   ],
// )

// _buildIdEvolutionRow(): (4dp di bawah nameRow)
// Row(
//   MainAxisAlignment.spaceBetween,
//   children: [
//     Text('#${creature.id.padLeft(3,'0')}', style: AppTextStyles.idNumber),
//     Text('EVOLUÇÃO', style: AppTextStyles.microLabel),  → ganti label sesuai konteks RWAFC,
//                                                            misal "RARITY" dengan rarity name
//   ],
// )
```

**Catatan adaptasi untuk RWAFC:** Karena RWAFC tidak punya "evolução" dalam arti rantai evolusi yang selalu sama persis Pokémon, kanan atas baris kedua diisi dengan **rarity label** (misal "EPIC" / "LEGENDARY") menggunakan style yang sama persis (`microLabel`), supaya layout tetap identik dengan referensi tapi informasinya relevan untuk game ini.

---

### 5.4 TypeBadge (Pill dengan Ikon Bulat Solid)

Ini detail PALING penting yang harus akurat — beda dari `ElementBadge` versi v1.0.

```
Tampilan referensi:
┌──────────────────┐
│  (🔥)   Fogo      │  ← lingkaran solid oranye berisi ikon api putih, lalu teks
└──────────────────┘
```

```dart
class TypeBadge extends StatelessWidget {
  final String element;
  final String label; // "Fogo", "Voador", dst — atau untuk RWAFC: "Fire", "Shadow"

  Widget build(BuildContext context) {
    final palette = ElementColors.palettes[element]!;
    return Container(
      padding: const EdgeInsets.only(left: 4, right: 14, top: 4, bottom: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceMuted,
        borderRadius: BorderRadius.circular(AppRadius.badgePill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: palette.badgeColor,
              shape: BoxShape.circle,
            ),
            child: Icon(elementIconData[element], size: 15, color: Colors.white),
          ),
          const Gap(8),
          Text(label, style: AppTextStyles.badgeLabel),
        ],
      ),
    );
  }
}
```

**Spesifikasi exact:**
- Outer pill background: `AppColors.surfaceMuted` (#F7F7FA) — BUKAN warna elemen solid seperti v1.0
- Inner circle (ikon): warna elemen solid (`badgeColor`), diameter 28dp
- Ikon di dalam circle: putih, 15dp
- Teks: warna `textPrimary` (hitam), bukan warna kontras elemen
- Gap antar 2 badge: 10dp

---

### 5.5 InfoRow3Column (Peso / Altura / Habilidade)

Pengganti total `StatGrid` 2×2 dari v1.0.

```
┌─────────────┬─────────────┬─────────────┐
│  △ PESO     │  ⊥ ALTURA   │ ⊙ HABILIDADE│
│  90,5 kg    │   1,7 m     │   Chama     │
└─────────────┴─────────────┴─────────────┘
     ↑ divider vertikal tipis antar kolom
```

```dart
class InfoRow3Column extends StatelessWidget {
  final List<InfoItem> items; // exactly 3 items

  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            Expanded(child: _buildColumn(items[i])),
            if (i < items.length - 1)
              Container(width: 1, color: AppColors.divider, margin: const EdgeInsets.symmetric(vertical: 4)),
          ],
        ],
      ),
    );
  }

  Widget _buildColumn(InfoItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon, size: 13, color: AppColors.textTertiary),
            const Gap(4),
            Text(item.label, style: AppTextStyles.infoLabel),
          ],
        ),
        const Gap(6),
        Text(item.value, style: AppTextStyles.infoValue),
      ],
    );
  }
}
```

**Untuk RWAFC, 3 kolom diisi dengan data yang relevan menggantikan Peso/Altura/Habilidade:**

| Kolom 1 | Kolom 2 | Kolom 3 |
|---|---|---|
| ⚡ POWER (BST/total stat) | 📅 CAPTURED (tanggal singkat) | ⭐ SKILL (nama skill utama) |

Contoh: `POWER: 740` · `CAPTURED: 12 Des` · `SKILL: Shadow Claw`

---

### 5.6 GenderSection → Diadaptasi Jadi "PowerBalanceBar"

Referensi punya gender bar (male/female), yang tidak relevan untuk RWAFC. Diadaptasi menjadi **Power Balance Bar** — visualisasi rasio ATK vs DEF creature, dengan style visual identik (gradient pill bar + persentase di kedua ujung).

```
           KESEIMBANGAN
  [████████████░░░░░] gradient oranye→biru
  ⚔ ATK 68%              🛡 DEF 32%
```

```dart
class PowerBalanceBar extends StatelessWidget {
  final int atk;
  final int def;

  Widget build(BuildContext context) {
    final total = atk + def;
    final atkRatio = atk / total;

    return Column(
      children: [
        Text('KESEIMBANGAN', style: AppTextStyles.infoLabel),
        const Gap(10),
        Container(
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.genderBar),
            gradient: const LinearGradient(
              colors: [Color(0xFFFF7A1A), Color(0xFF4A90E2)],
            ),
          ),
          // Catatan: gradient solid (bukan dipotong sesuai ratio seperti Pokédex asli)
          // karena makna berbeda — di sini menunjukkan SPEKTRUM bukan proporsi populasi
        ),
        const Gap(8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('⚔ ATK ${(atkRatio*100).round()}%', style: AppTextStyles.genderPercent),
            Text('🛡 DEF ${(100-atkRatio*100).round()}%', style: AppTextStyles.genderPercent),
          ],
        ),
      ],
    );
  }
}
```

---

### 5.7 BottomNavBar (4 Ikon Flat, Replikasi Exact)

```
[⌂]      [⊕ pokeball]      [⚭⚭ group]      [☰ menu]
```

```dart
class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.divider, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navIcon(Icons.home_outlined, 0),
          _navIcon(Icons.catching_pokemon, 1),     // ganti ikon capture/target custom RWAFC
          _navIcon(Icons.group_outlined, 2),        // battle/team
          _navIcon(Icons.menu, 3),                  // profile/menu
        ],
      ),
    );
  }

  Widget _navIcon(IconData icon, int index) {
    final active = index == currentIndex;
    return Icon(icon, size: 24,
        color: active ? AppColors.navActive : AppColors.navInactive);
  }
}
```

**Spesifikasi exact:**
- TIDAK ada label teks di bawah ikon (beda dari v1.0)
- TIDAK ada background pill khusus untuk ikon aktif (beda dari v1.0 yang punya floating capture button)
- Item aktif: hanya beda warna (hitam vs abu)
- Background: putih solid, border atas 1dp abu sangat tipis
- Height: 64dp + safe area bottom

⚠️ Ini perubahan filosofi besar dari v1.0: capture button TIDAK lagi jadi FAB raksasa di tengah nav. Sesuai referensi, semua ikon punya bobot visual yang sama.

---

### 5.8 CarouselButton (Tombol Panah Kiri-Kanan)

Sudah dijelaskan di 5.1, detail tambahan:
- Posisi: vertically centered sejajar dengan tengah artwork, BUKAN sejajar bottom artwork
- Saat ditekan: scale 0.9 + opacity naik ke 0.4
- Fungsi: navigasi antar creature dalam koleksi tanpa harus back ke list (swipe-like browsing)

---

## 6. SCREEN SPECIFICATION — CREATURE DETAIL (UTAMA)

Ini adalah layar paling penting karena paling identik dengan referensi.

```
┌───────────────────────────────────────┐
│ ░░░░░░░░░ GRADIENT ELEMENT ░░░░░░░░░░ │ ← height: 50% layar
│ [‹]                            [⊕]    │
│                                        │
│         (ellipse glow putih)          │
│ [‹]      [FOTO CREATURE]        [›]   │
│                                        │
├═══════════════════════════════════════┤ ← rounded top 32dp, overlap -32dp
│                                        │
│  Umbren Claw                 nvl. 12  │
│  #042                         EPIC    │
│                                        │
│  (🌑) Shadow      (🐈) Feline          │ ← 2 type badge
│                                        │
│  Kreatur misterius yang lahir dari    │
│  bayangan kucing liar. Cakarnya       │
│  mampu menembus kegelapan malam.      │ ← flavor text auto-generate
│                                        │
│  ⚡POWER  │ 📅CAPTURED │ ⭐SKILL        │
│   740    │  12 Des    │ Shadow Claw   │
│                                        │
│         KESEIMBANGAN                  │
│  [██████████░░░░░░] oranye→biru       │
│  ⚔ ATK 68%            🛡 DEF 32%      │
│                                        │
│  ── divider ──                        │
│                                        │
│  [Ganti Nama]  [Set ke Tim]  [Share]  │ ← 3 tombol aksi, full width row
│                                        │
├───────────────────────────────────────┤
│   [⌂]    [⊕]    [⚭⚭]    [☰]          │
└───────────────────────────────────────┘
```

### 6.1 Tambahan Khusus RWAFC (Tidak Ada di Referensi Asli)

Karena RWAFC adalah game collector dengan sistem rarity (tidak ada di Pokédex biasa), tambahkan:
- **Rarity label** menggantikan posisi "EVOLUÇÃO" (kanan atas baris kedua) — tampil sebagai teks saja, TANPA badge/border, mengikuti gaya minimal referensi
- **Stat bar lengkap (HP/ATK/DEF/SPD)** bisa ditambahkan sebagai section collapsible "Lihat Detail Stat" di bawah action button, agar layar utama tetap clean seperti referensi tapi power user tetap bisa lihat detail

```dart
// Optional expandable section (TIDAK collapse by default, biar tetap clean):
ExpansionTile(
  title: Text('Detail Statistik', style: AppTextStyles.infoLabel),
  children: [
    StatBar(label: 'HP', value: creature.hp, max: 350, color: Color(0xFF4CAF50)),
    StatBar(label: 'ATK', value: creature.atk, max: 220, color: Color(0xFFFF6B35)),
    StatBar(label: 'DEF', value: creature.def, max: 200, color: Color(0xFF2196F3)),
    StatBar(label: 'SPD', value: creature.spd, max: 230, color: Color(0xFF9C27B0)),
  ],
)
```

---

## 7. SCREEN SPECIFICATION — LAYAR LAIN

### 7.1 CollectionScreen (List Sebelum Masuk Detail)

Referensi yang diberikan hanya menunjukkan detail screen, bukan grid list. Untuk konsistensi, grid card di CollectionScreen dibuat sebagai **versi mini dari hero gradient** (bukan card putih netral seperti v1.0):

```
┌─────────────┐  ┌─────────────┐
│ gradient bg │  │ gradient bg │
│   [foto]    │  │   [foto]    │
│ Nama        │  │ Nama        │
│ #042 · Lv12 │  │ #017 · Lv8  │
└─────────────┘  └─────────────┘
```

```dart
class CreatureGridCard extends StatelessWidget {
  Widget build(BuildContext context) {
    final palette = ElementColors.palettes[creature.element]!;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [palette.gradientTop, palette.gradientBottom],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Expanded(child: Image.file(File(creature.imagePath), fit: BoxFit.contain)),
          const Gap(8),
          Align(alignment: Alignment.centerLeft,
            child: Text(creature.creatureName,
                style: AppTextStyles.badgeLabel.copyWith(color: Colors.white))),
          Align(alignment: Alignment.centerLeft,
            child: Text('#${creature.id} · Lv${creature.level}',
                style: AppTextStyles.idNumber.copyWith(color: Colors.white.withOpacity(0.85)))),
        ],
      ),
    );
  }
}
```

✅ Card grid tetap memakai gradient elemen penuh (BUKAN card putih dengan tint kecil) — supaya konsisten dengan bahasa visual hero detail

### 7.2 HomeScreen

Tidak ada referensi langsung untuk HomeScreen, jadi tetap gunakan struktur dari versi sebelumnya, namun:
- Hunter card menggunakan warna netral (putih + abu), bukan gradient — gradient HANYA dipakai untuk konteks per-creature
- Mini creature card di section "Kreaturmu" menggunakan `CreatureGridCard` versi mini (7.1)

---

## 8. ANIMATION & MOTION

### 8.1 Carousel Transition (Swipe Antar Creature)

```dart
// Saat tombol carousel ditekan / swipe:
// 1. Artwork lama fade out + slide ke arah swipe (200ms)
// 2. Gradient background cross-fade ke warna elemen creature baru (300ms)
// 3. Artwork baru slide in dari arah berlawanan + fade in (250ms)
// 4. White sheet content (nama, stat, dll) fade out → update data → fade in (200ms total)

class AppDuration {
  static const Duration gradientCrossfade = Duration(milliseconds: 300);
  static const Duration artworkSlide      = Duration(milliseconds: 250);
  static const Duration sheetContentSwap  = Duration(milliseconds: 200);
}
```

### 8.2 Page Entry (Saat Masuk dari Collection ke Detail)

```dart
// Hero animation pada artwork SAJA (bukan seluruh card background)
Hero(
  tag: 'creature_artwork_${creature.id}',
  child: Image.file(File(creature.rawImagePath)),
)
// Background gradient TIDAK pakai Hero, langsung fade in 250ms
// agar transisi terlihat natural seperti referensi (background "muncul" di belakang artwork)
```

---

## 9. FLUTTER PACKAGES

```yaml
dependencies:
  flutter_animate: ^4.5.0    # crossfade gradient, carousel transition
  google_fonts: ^6.2.1       # Plus Jakarta Sans
  gap: ^3.0.1
  flutter_svg: ^2.0.9        # ikon elemen custom (api, air, daun, dst — bentuk solid bukan outline)

  # Tetap dipertahankan dari v1.0:
  flutter_riverpod: ^2.5.1
  go_router: ^13.2.0
  hive_flutter: ^1.1.0
```

**Catatan font:** Jika tidak ingin embed font manual, gunakan `google_fonts` package langsung:
```dart
TextStyle creatureName = GoogleFonts.plusJakartaSans(
  fontSize: 28, fontWeight: FontWeight.w800,
);
```

---

## 10. ANTI-PATTERNS

```
❌ JANGAN gunakan card kecil dengan shadow drop untuk hero detail
   → Gradient HARUS full-bleed mengisi area atas layar, tanpa card border

❌ JANGAN biarkan artwork overflow keluar dari area gradient (seperti v1.0)
   → Di referensi baru, artwork sepenuhnya di dalam gradient area

❌ JANGAN gunakan warna pastel/tint lembut untuk gradient elemen
   → Gunakan warna VIVID solid sesuai palet section 2.2

❌ JANGAN gunakan icon outline di dalam type badge
   → Ikon harus SOLID/FILLED berwarna di dalam lingkaran solid

❌ JANGAN tambahkan label teks di bawah ikon bottom nav
   → Bottom nav HARUS ikon-only, flat, tanpa label

❌ JANGAN buat tombol capture sebagai FAB besar mengambang di tengah nav
   → Semua 4 ikon nav punya bobot visual setara

❌ JANGAN gunakan border radius kecil (8-12dp) untuk white sheet
   → White sheet HARUS pakai radius besar (28-32dp) untuk efek "menyatu"

❌ JANGAN taruh stat grid 2×2 untuk info Peso/Altura/Habilidade
   → HARUS 3 kolom horizontal sejajar dengan divider vertikal tipis
```

---

## 11. ASSET SPECIFICATION

### 11.1 Ikon Elemen (Solid, Bukan Outline)

Beda dari v1.0 yang pakai ikon outline 2dp stroke, versi ini butuh **ikon solid/filled** karena ditempatkan di dalam lingkaran berwarna:

```
assets/icons/elements/
├── fire_solid.svg      ← api solid putih
├── water_solid.svg     ← tetesan air solid putih
├── nature_solid.svg    ← daun solid putih
├── electric_solid.svg  ← petir solid (putih/gelap tergantung kontras)
├── shadow_solid.svg    ← bulan sabit / siluet solid putih
├── light_solid.svg     ← matahari solid
├── wind_solid.svg      ← spiral angin solid
├── earth_solid.svg     ← gunung/batu solid
├── ice_solid.svg       ← kristal es solid
└── poison_solid.svg    ← tetesan racun solid
```

Spesifikasi tiap ikon: 16×16dp viewBox, fill putih (akan ditempatkan di atas badgeColor solid).

### 11.2 Pokeball/Capture Icon (Custom Brand)

Pengganti ikon pokeball asli (hak cipta) untuk RWAFC:
- Desain custom: lingkaran dengan target crosshair di tengah (merepresentasikan "capture")
- Dipakai di: app bar kanan atas (hero detail) dan bottom nav index 1

---

## QUICK REFERENCE — DESIGN TOKENS v2.0

```dart
// Gradient per elemen (top → bottom):
// Fire:     0xFFFF9A3C → 0xFFF6722A
// Water:    0xFF6FB8F0 → 0xFF3D8FE0
// Nature:   0xFF7ED99A → 0xFF45B86A
// Electric: 0xFFFFE066 → 0xFFFFC93C
// Shadow:   0xFF8B6FD9 → 0xFF5B3FB8
// Ice:      0xFFC9F1F5 → 0xFF8FDCE6
// Poison:   0xFFC58AE0 → 0xFF9B4FC9

// Font: Plus Jakarta Sans (bukan Nunito)
// Nama creature: 28px ExtraBold
// Sheet radius: 32dp (besar)
// Type badge: pill abu muda + lingkaran ikon solid 28dp
// Info row: 3 kolom horizontal, BUKAN grid 2x2
// Bottom nav: 4 ikon flat tanpa label
```

---

*DESIGN.md v2.0.0 — RWAFC | Replikasi langsung dari referensi Pokédex screenshot (Charizard/Suicune/Serperior)*
*Menggantikan total pendekatan card-tint v1.0 dengan full-bleed gradient hero style.*