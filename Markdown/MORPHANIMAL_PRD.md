# GAME DESIGN DOCUMENT (GDD) v2.0
## Morphanimal
**Versi:** 2.0.0
**Status:** Draft — Improved & Expanded
**Platform:** Android (Flutter)
**Pendekatan:** Offline-First, Zero Operational Cost

---

## DAFTAR ISI

1. Visi & Positioning
2. Core Gameplay Loop (Improved)
3. Sistem AI & Detection (Improved)
4. Morphanimal Generation System (Improved)
5. Stat & Balancing System (Baru)
6. Battle System (Baru)
7. Progression System (Baru)
8. Collection & Pokedex System (Improved)
9. UX Flow & User Journey (Baru)
10. Error Handling & Edge Cases (Baru)
11. Monetisasi & Sustainability (Baru)
12. Arsitektur Penyimpanan (Improved)
13. Tech Stack (Improved)
14. UI/UX Design Direction (Improved)
15. Species Database — Supported Animals (Baru)
16. Roadmap Pengembangan (Improved)
17. Risiko & Mitigasi (Baru)

---

## 1. VISI & POSITIONING

### 1.1 Satu Kalimat Visi
> "Setiap hewan yang kamu temui di dunia nyata bisa menjadi pejuang fantasi milikmu — unik, tak tergantikan, dan hanya kamu yang punya."

### 1.2 Core Fantasy
Pengguna bukan sekadar memotret hewan — mereka adalah **Hunter** yang mengeksplorasi dunia nyata untuk "menangkap" Morphanimal langka. Setiap foto adalah momen tak terduga: hewan yang sama bisa menghasilkan Morphanimal berbeda tergantung waktu, kondisi cahaya, dan keberuntungan.

### 1.3 Diferensiasi dari Kompetitor

| Aspek | Pokémon GO | Monster Hunter Now | Morphanimal |
|---|---|---|---|
| Sumber Morphanimal | Virtual AR | Virtual AR | Foto hewan nyata |
| Kebutuhan internet | Selalu | Selalu | Opsional |
| Uniqueness per Morphanimal | Tidak | Tidak | Ya — setiap foto berbeda |
| Edukasi hewan | Tidak | Tidak | Ya (data spesies nyata) |
| Biaya operasional | Tinggi | Tinggi | Nol |

### 1.4 Target Pengguna
- **Primer:** Pelajar & mahasiswa usia 15–24 yang suka game koleksi
- **Sekunder:** Pecinta hewan & nature photography
- **Tersier:** Orang tua yang ingin media edukasi hewan untuk anak

---

## 2. CORE GAMEPLAY LOOP (IMPROVED)

### 2.1 Loop Utama

```
[EXPLORE] → Jalan-jalan di dunia nyata
     ↓
[SPOT] → Temukan hewan (peliharaan, liar, kebun binatang)
     ↓
[CAPTURE] → Foto dengan kamera in-app
     ↓
[DETECT] → AI mengidentifikasi spesies hewan
     ↓
     ├─ [GAGAL DETEKSI] → Feedback jelas + tips retry
     └─ [BERHASIL] → Lanjut ke generasi
          ↓
[GENERATE] → Sistem menghasilkan creature fantasi unik
     ↓
[REVEAL] → Animasi reveal dengan rarity tier
     ↓
[COLLECT] → Creature masuk ke koleksi + XP diberikan
     ↓
[ENGAGE] → Battle, evolusi, atau kembali explore
```

### 2.2 Loop Sekunder (Daily Engagement)

```
Login harian → Cek Daily Mission → Battle PvE →
Lihat koleksi → Rename / organize → Kembali explore
```

### 2.3 Kompulsion Loop (Psikologi Retensi)
- **Variable Reward:** Rarity reveal tidak terprediksi → dopamine spike
- **Near Miss:** "Kamu hampir dapat Legendary! Coba lagi besok."
- **Collection Pressure:** Jumlah spesies tertampil "X/50 ditemukan"
- **Daily Streak:** Bonus rarity multiplier untuk streak berturut-turut

---

## 3. SISTEM AI & DETECTION (IMPROVED)

### 3.1 Model yang Digunakan

**Pilihan Utama: iNaturalist TFLite Model**
- Dilatih pada 5.000+ spesies termasuk hewan Asia Tenggara
- Tersedia gratis dari seek-android repository (Apache 2.0 License)
- Ukuran: ~25MB (quantized INT8)
- Akurasi top-1: ~70%, top-5: ~90%

**Fallback: MobileNetV3-Large (ImageNet)**
- Untuk deteksi broad category (mammal/bird/reptile)
- Ukuran: ~16MB
- Digunakan ketika iNaturalist tidak confident

### 3.2 Pipeline Deteksi 2-Stage

```
Stage 1 — Is it an animal?
Input: foto → MobileNet broad classifier
Output: animal / not_animal (threshold: 0.60)

Jika not_animal → Tolak dengan pesan error

Stage 2 — What animal is it?
Input: foto → iNaturalist classifier
Output: [
  { species: "Felis catus", confidence: 0.87, common_name: "Kucing" },
  { species: "Canis lupus", confidence: 0.08, common_name: "Anjing" },
  ...
]

Ambil top-1 jika confidence ≥ 0.65
Ambil top-3 dan minta user pilih jika 0.40 ≤ confidence < 0.65
Tolak jika semua confidence < 0.40
```

### 3.3 Preprocessing Gambar

Sebelum masuk ke model, lakukan:
1. **Resize** ke 224×224 (input size model)
2. **Auto-brightness normalization** — kompensasi pencahayaan buruk
3. **Center crop** — fokus ke objek tengah frame
4. **Blur detection** — tolak foto buram (Laplacian variance < 100)

### 3.4 Context Enrichment

Data konteks ditambahkan tanpa biaya untuk memperkaya Morphanimal:

```dart
CaptureContext {
  timestamp: DateTime.now(),
  hour: 6,                    // → bias Light/Dawn element
  isNight: false,             // jam 20:00–05:00 → bias Shadow element
  isGoldenHour: true,         // jam 06:00–07:30 → bias Fire element
  locationTag: "outdoor",     // opsional: GPS coarse (kota saja)
  weatherTag: null,           // Phase 2: OpenWeatherMap free tier
}
```

### 3.5 Confidence UI

Tampilkan kepada pengguna seberapa "jelas" foto mereka:

```
[████████░░] 80% — "Identifikasi berhasil: Kucing"
[█████░░░░░] 50% — "Kurang yakin, ini kucing atau musang?"
[██░░░░░░░░] 20% — "Tidak dapat mengenali hewan ini"
```

---

## 4. MORPHANIMAL GENERATION SYSTEM (IMPROVED)

### 4.1 Formula Lengkap

```
Creature = f(Species, Rarity, Seed, TimeContext, WeatherContext)

Seed = SHA256(imageBytes[0:1024] + userId + captureTimestamp)
       → Deterministik per foto, reproducible
```

### 4.2 Species → Element Mapping

| Kelompok Hewan | Element Primer | Element Sekunder (random) |
|---|---|---|
| Kucing (Felidae) | Shadow | Fire, Electric |
| Anjing (Canidae) | Nature | Light, Water |
| Burung kecil | Wind | Light, Electric |
| Burung predator | Fire | Shadow, Wind |
| Reptil | Earth | Shadow, Poison |
| Ikan | Water | Electric, Ice |
| Serangga | Poison | Nature, Wind |
| Amfibi | Water | Nature, Earth |
| Hewan nokturnal | Shadow | Dark, Ice |
| Primata | Nature | Light, Earth |

**Time Modifier** (tambahan bias):
- 20:00–05:00 (malam) → +20% Shadow, +10% Dark
- 06:00–07:30 (golden hour) → +20% Light, +15% Fire
- 07:30–17:00 (siang) → element primer tidak berubah
- Hujan (Phase 2) → +25% Water, +10% Ice

### 4.3 Rarity Generation

```dart
double rarityRoll = seededRandom(seed).nextDouble(); // 0.0–1.0

// Dengan daily streak bonus
double streakBonus = min(streak * 0.01, 0.05); // max +5%
double finalRoll = rarityRoll + streakBonus;

if (finalRoll < 0.55) return Rarity.Common;      // 55%
if (finalRoll < 0.80) return Rarity.Rare;        // 25%
if (finalRoll < 0.95) return Rarity.Epic;        // 15%
return Rarity.Legendary;                          // 5%
```

### 4.4 Nama Morphanimal

Format: `[Prefix] + [Species Base Name] + [Suffix (opsional)]`

```
Prefix (dari element):
Fire → "Embara", "Pyrion", "Ignar"
Water → "Aquon", "Tidalis", "Marinu"
Shadow → "Umbren", "Nyxar", "Shaden"
Electric → "Voltis", "Zaphar", "Strikun"

Contoh hasil:
- Kucing + Shadow + Epic → "Umbren Claw" / "Nyxar the Silent"
- Burung + Fire + Legendary → "Pyrion Skywing of the Ember"
```

---

## 5. STAT & BALANCING SYSTEM (BARU)

### 5.1 Base Stats per Rarity

| Stat | Common | Rare | Epic | Legendary |
|---|---|---|---|---|
| HP | 80–120 | 120–180 | 180–260 | 260–350 |
| ATK | 40–70 | 70–110 | 110–160 | 160–220 |
| DEF | 30–60 | 60–100 | 100–150 | 150–200 |
| SPD | 40–80 | 80–120 | 120–170 | 170–230 |
| Total BST | 190–330 | 330–510 | 510–740 | 740–1000 |

BST = Base Stat Total, mengacu pada sistem Pokémon.

### 5.2 Species Modifier

Setiap kelompok hewan memiliki stat affinity:

```
Kucing: ATK ↑↑, SPD ↑, HP ↓
Anjing: HP ↑↑, DEF ↑, ATK ↓
Burung: SPD ↑↑↑, ATK ↑, DEF ↓↓
Reptil: DEF ↑↑, HP ↑, SPD ↓↓
Ikan: HP ↑, SPD ↑, ATK ↓
Serangga: SPD ↑↑, ATK ↑, HP ↓↓
```

### 5.3 Individual Values (IV) System

Terinspirasi dari Pokémon IV — setiap Morphanimal punya nilai unik 0–31 per stat:

```dart
int iv_hp  = seededRandom(seed + "hp").nextInt(32);   // 0–31
int iv_atk = seededRandom(seed + "atk").nextInt(32);
// dst...

// Final stat formula:
finalStat = floor((baseStat * 2 + iv) * level / 100 + 5)
```

Ini membuat dua Morphanimal spesies sama bisa berbeda secara signifikan → replayability tinggi.

### 5.4 Elemental Advantage Matrix

```
Fire    > Nature, Ice
Water   > Fire, Earth
Nature  > Water, Earth
Electric> Water, Wind
Shadow  > Light, Psychic
Light   > Shadow, Dark
Wind    > Nature, Poison
Earth   > Electric, Fire
Ice     > Nature, Wind
Poison  > Nature, Water
```

Bonus damage: 1.5× untuk advantage, 0.5× untuk disadvantage.

---

## 6. BATTLE SYSTEM (BARU)

### 6.1 Visi Battle
Battle bukan fokus utama Phase 1–2, tapi harus dirancang dari awal agar tidak perlu refactor besar.

### 6.2 Format Battle

**PvE (Priority — Phase 3)**
- Lawan: CPU-controlled wild Morphanimals atau Dungeon bosses
- Turn-based, giliran ditentukan oleh SPD stat
- Player pilih skill dari 4 opsi

**PvP Asinkron (Phase 4)**
- Player set "defense team" (3 Morphanimal)
- Lawan bisa menyerang kapan saja, hasil dihitung server-side
- Tidak perlu real-time connection → murah di Supabase

### 6.3 Turn-Based Mechanic

```
Urutan giliran:
1. Bandingkan SPD kedua creature
2. Creature SPD lebih tinggi attack duluan
3. Damage formula:
   damage = floor((ATK * skillPower / DEF) * typeMultiplier * random(0.85, 1.0))
4. HP berkurang sesuai damage
5. Cek status effects (burn, paralyze, dll)
6. Giliran berganti
7. Creature HP ≤ 0 → KO
```

### 6.4 Skill System Detail

Setiap Morphanimal punya 2–4 skill berdasarkan:
- 1–2 skill dari element primer (dijamin)
- 1 skill dari species type
- 1 skill random (Rare+)

```dart
class Skill {
  String name;
  Element element;
  int power;          // 40–120
  int accuracy;       // 70–100 (persen)
  int ppMax;          // 5–15 penggunaan
  StatusEffect? effect; // burn, paralyze, confuse (30% chance)
}

// Contoh skill:
Skill(name: "Ember Strike", element: Fire, power: 60, accuracy: 95, pp: 10)
Skill(name: "Shadow Claw",  element: Shadow, power: 70, accuracy: 90, pp: 8, effect: paralyze)
Skill(name: "Volt Tackle",  element: Electric, power: 90, accuracy: 80, pp: 5)
```

### 6.5 Battle Rewards
- XP untuk semua Morphanimal yang ikut battle
- Gold coin (currency in-game, tidak real money)
- Chance drop "Capture Boost" item (meningkatkan rarity roll +5%)

---

## 7. PROGRESSION SYSTEM (BARU)

### 7.1 Player Level (Hunter Rank)

```
XP Sources:
- Capture baru: +50 XP (Common), +100 (Rare), +200 (Epic), +500 (Legendary)
- Battle menang (PvE): +30 XP
- Daily mission selesai: +150 XP
- Streak bonus: +20 XP × hari streak

Level milestones (contoh):
Level 1:  0 XP    → Unlock: Basic camera
Level 5:  500 XP  → Unlock: Battle mode
Level 10: 2000 XP → Unlock: Team builder (3 creature)
Level 20: 8000 XP → Unlock: PvP mode
Level 30: 20000XP → Unlock: Legendary hunt mode
```

### 7.2 Morphanimal Level & Evolution

```
Creature XP dari:
- Battle: +10–50 XP per battle
- Passive (harian): +5 XP/hari

Level cap: 50

Evolution trigger (jika ada):
- Level 20: Form 1 → Form 2 (stat boost +20%, nama berubah)
- Level 40: Form 2 → Form 3 (stat boost +20%, skill baru)

Syarat evolution tambahan:
- Common & Rare: Level saja
- Epic: Level + 1 item "Moonstone" (dari daily mission)
- Legendary: Tidak berevolusi (sudah final form)
```

### 7.3 Daily Mission System

```dart
// Generate 3 misi harian menggunakan seed tanggal
List<Mission> dailyMissions = generateMissions(
  seed: DateUtils.dateOnly(DateTime.now()).millisecondsSinceEpoch
);

// Tipe misi:
MissionType.CAPTURE_ANY          // "Tangkap 1 hewan apapun"
MissionType.CAPTURE_SPECIES      // "Tangkap seekor Burung"
MissionType.CAPTURE_ELEMENT      // "Dapatkan creature elemen Air"
MissionType.BATTLE_WIN           // "Menangkan 2 battle"
MissionType.BATTLE_ELEMENT       // "Menangkan battle pakai creature Api"
MissionType.LOGIN_STREAK         // "Login hari ini"

// Reward:
"Tangkap 1 hewan": +150 XP, +50 Gold
"Menangkan 2 battle": +200 XP, +80 Gold, 1x Boost Item
```

### 7.4 Achievement System

```
Achievement tier: Bronze → Silver → Gold → Platinum

Contoh:
"First Blood"       → Tangkap creature pertama [Bronze]
"Nature Walker"     → Tangkap 10 spesies berbeda [Silver]
"Shadow Hunter"     → Dapatkan 5 creature Shadow [Silver]
"Lucky Seven"       → Dapatkan 1 Legendary [Gold]
"Completionist"     → Unlock 30 spesies berbeda [Platinum]
"Night Owl"         → Tangkap 5 creature di malam hari [Silver]
```

---

## 8. COLLECTION & POKÉDEX SYSTEM (IMPROVED)

### 8.1 Dua Layer Koleksi

**Layer 1 — My Morphanimals (inventory)**
- Semua Morphanimal yang dimiliki dengan stat lengkap
- Bisa rename, lihat detail, set ke battle team
- Sort: by date, by rarity, by element, by species

**Layer 2 — Bestiary (Pokédex-style)**
- Daftar semua spesies yang pernah ditemukan (bukan instance)
- Slot kosong untuk spesies yang belum ditemukan (dengan silhouette)
- Tampilkan: nama spesies nyata, fakta menarik, elemen yang mungkin
- Progress: "32/50 spesies ditemukan"

### 8.2 Morphanimal Detail Page

```
┌─────────────────────────────────┐
│  [Foto asli hewan]              │
│  "Umbren Claw"                  │
│  ★★★ EPIC · Shadow · Lv.12     │
│  Spesies: Kucing Domestik       │
│  Ditangkap: 12 Des 2024, 20:34 │
│  Lokasi: Sumedang (jika ada)   │
├─────────────────────────────────┤
│  HP  ████████░░  145/260        │
│  ATK ██████░░░░  112            │
│  DEF ████░░░░░░  78             │
│  SPD ███████░░░  134            │
├─────────────────────────────────┤
│  SKILLS:                        │
│  • Shadow Claw (Shadow, 70 PWR)│
│  • Night Slash (Dark, 60 PWR)  │
├─────────────────────────────────┤
│  IV Quality: ██████░░░░ 61%    │
│  [Rename] [Set to Team] [Share]│
└─────────────────────────────────┘
```

### 8.3 Share Mechanic (Organic Growth)

Generate share card otomatis — gambar 1080×1080 yang bisa dishare ke Instagram/WhatsApp:

```
Template share card:
┌──────────────────────────────┐
│  🌑 EPIC CREATURE CAPTURED!  │
│                              │
│  [Foto hewan + overlay frame]│
│                              │
│  "Umbren Claw"               │
│  Shadow · EP 142/260 HP      │
│  Captured by: [username]     │
│  #MorphanimalHunter              │
└──────────────────────────────┘
```

Plugin: `screenshot` + `share_plus` (gratis)

---

## 9. UX FLOW & USER JOURNEY (BARU)

### 9.1 First Time User Experience (FTUE)

```
App launch pertama kali:
1. Splash screen (1.5 detik)
2. Intro cutscene singkat (bisa skip):
   "Dunia ini penuh makhluk tersembunyi...
    Hanya Hunter sejati yang bisa melihatnya."
3. Input nama Hunter (atau "Mulai sebagai Tamu")
4. Tutorial capture pertama:
   - Minta foto hewan (bisa pakai foto kucing demo)
   - Reveal creature pertama dengan animasi penuh
   - Dijamin dapat Rare (seeded tutorial)
5. Tampilkan koleksi, jelaskan UI utama
6. Selesai → masuk homescreen
```

### 9.2 Session Flow Ideal (5 menit)

```
Buka app
  → Cek daily mission (+10 detik)
  → Cek notif battle result (+10 detik)
  → Buka kamera, foto hewan di sekitar (+60 detik)
  → Lihat reveal animasi (+20 detik)
  → Cek koleksi baru, rename (+30 detik)
  → Battle quick PvE (+90 detik)
  → Tutup app

Total: ~5 menit, bisa harian
```

### 9.3 Navigasi Utama (Bottom Navigation)

```
[🏠 Home] [📷 Capture] [⚔️ Battle] [📚 Collection] [👤 Profile]

Home      : Dashboard, daily mission, last captured
Capture   : Buka kamera langsung
Battle    : PvE arena, riwayat battle, leaderboard (Phase 4)
Collection: My creatures + Bestiary
Profile   : Stats, achievement, settings, backup/export
```

### 9.4 Micro-Interaction Penting

- **Capture button:** Efek shutter + loading bar "AI scanning..."
- **Rarity reveal:** Animasi buka "egg" atau portal — suspense 2 detik
- **Legendary reveal:** Full screen animasi + particle effect + suara fanfare
- **Battle hit:** Screen shake ringan + damage number melayang
- **Level up:** Confetti + stat increase animation

---

## 10. ERROR HANDLING & EDGE CASES (BARU)

### 10.1 Skenario Gagal Deteksi

| Kondisi | Pesan ke User | Saran |
|---|---|---|
| Foto blur | "Foto terlalu buram. Tahan kamera lebih stabil." | Retry button |
| Bukan hewan | "Ini bukan hewan. Coba foto makhluk hidup!" | Retry button |
| Confidence rendah | "Tidak yakin ini hewan apa. Pilih dari daftar?" | Dropdown 3 opsi |
| Hewan tidak dikenal | "Makhluk misterius! Termasuk kategori 'Unknown Beast'" | Tetap generate |
| Cahaya terlalu gelap | "Terlalu gelap. Coba nyalakan lampu atau keluar." | Flash toggle |

### 10.2 "Unknown Beast" Fallback

Jika hewan tidak dikenali tapi sudah lolos blur dan animal detection:

```dart
// Generate creature dengan species "Unknown Beast"
Creature unknownBeast = CreatureGenerator.generate(
  species: Species.unknown,
  element: Element.random(),  // Fully random
  rarityBoost: 0.10,          // +10% rarity karena "misterius"
  namePrefix: ["Phantom", "Void", "Ancient", "Enigma"],
);
```

Ini mengubah kegagalan AI menjadi fitur menarik — bisa memotivasi user untuk menemukan "unknown beast" sebagai Morphanimal langka.

### 10.3 Edge Cases Lain

**Foto hewan yang sama berulang:**
- Tidak ada batasan — setiap foto akan berbeda karena timestamp berbeda dalam seed
- Tampilkan: "Kamu sudah punya 3 Kucing! Kali ini dapat yang berbeda?"

**Storage hampir penuh:**
- Cek storage sebelum capture: jika < 50MB tersisa → peringatkan user
- Opsi: hapus foto asli (simpan hanya thumbnail) untuk hemat space

**Hapus Morphanimal:**
- Permanent deletion dengan konfirmasi
- Morphanimal yang sudah di-delete masuk "Graveyard" selama 7 hari (bisa restore)
- Setelah 7 hari → hapus permanen

**Pertama kali tanpa internet:**
- Semua fitur utama tetap berjalan
- Badge "Offline Mode" di corner
- Sync otomatis saat kembali online (untuk leaderboard/profile)

---

## 11. MONETISASI & SUSTAINABILITY (BARU)

### 11.1 Prinsip Monetisasi

> Zero-cost untuk infrastruktur bukan berarti zero-revenue untuk developer.
> Namun aplikasi ini harus **tidak pernah menjual keuntungan gameplay** — hanya kosmetik.

Model: **Free-to-Play + Cosmetic-Only IAP** (jika dimonetisasi di masa depan)

### 11.2 Opsi Revenue (Tidak Wajib, Phase 5+)

**Opsi A — Google AdMob (Gratis setup)**
- Rewarded video ads: "Tonton iklan 30 detik untuk +5% rarity boost hari ini"
- Interstitial: hanya setelah 5 captures (tidak mengganggu)
- Banner: di halaman koleksi (bukan halaman utama)
- Estimasi revenue: $1–5 per 1000 active users per hari

**Opsi B — Cosmetic IAP**
- Frame Morphanimal card (gold, crystal, neon): Rp5.000–15.000
- Nickname title ("Shadow Master", "Beast Tamer"): Rp10.000
- Morphanimal storage expansion (default 100 slots → 200): Rp15.000
- Tidak ada pay-to-win, tidak ada stat boost berbayar

**Opsi C — One-time Purchase**
- "Hunter Premium Pass": Rp25.000 → hapus semua iklan + bonus frame koleksi
- Transparent: "Beli sekali, dukung developer"

### 11.3 Sustainability Zero-Cost Stack

```
Service         | Free Tier Limit        | Cukup untuk?
----------------|------------------------|------------------
Firebase Auth   | 10.000 MAU            | ~10.000 user
Supabase DB     | 500MB + 2GB transfer   | ~50.000 creatures
Vercel (jika ada web companion) | 100GB bandwidth | Cukup
GitHub Actions  | 2.000 mnt/bulan       | CI/CD penuh
Google Play     | $25 one-time           | Selamanya
```

---

## 12. ARSITEKTUR PENYIMPANAN (IMPROVED)

### 12.1 Skema Database Lokal (Hive)

```dart
// Box: creatures
@HiveType()
class CreatureModel {
  @HiveField(0) String id;           // UUID v4
  @HiveField(1) String species;      // "Felis catus"
  @HiveField(2) String commonName;   // "Kucing"
  @HiveField(3) String creatureName; // "Umbren Claw"
  @HiveField(4) String element;      // "shadow"
  @HiveField(5) String rarity;       // "epic"
  @HiveField(6) int level;           // 1–50
  @HiveField(7) int xp;
  @HiveField(8) int hp;
  @HiveField(9) int atk;
  @HiveField(10) int def;
  @HiveField(11) int spd;
  @HiveField(12) List<String> skills;
  @HiveField(13) String imagePath;   // path thumbnail
  @HiveField(14) String rawImagePath; // path foto asli
  @HiveField(15) String seed;        // untuk reproducibility
  @HiveField(16) DateTime capturedAt;
  @HiveField(17) String? locationTag; // "Sumedang" (opsional)
  @HiveField(18) bool isFavorite;
}

// Box: player
@HiveType()
class PlayerModel {
  @HiveField(0) String id;
  @HiveField(1) String name;
  @HiveField(2) int level;
  @HiveField(3) int xp;
  @HiveField(4) int gold;
  @HiveField(5) int streak;
  @HiveField(6) DateTime lastLogin;
  @HiveField(7) List<String> achievements;
  @HiveField(8) List<String> battleTeam; // max 3 creature IDs
}

// Box: bestiary
@HiveType()
class BestiaryEntry {
  @HiveField(0) String species;
  @HiveField(1) bool discovered;
  @HiveField(2) int captureCount;
  @HiveField(3) DateTime? firstCaptured;
}
```

### 12.2 Strategi Image Storage

```
/storage/morphanimal/
  ├── originals/        ← foto asli (JPEG 80%, max 1080px)
  │     ├── C001_orig.jpg
  │     └── C002_orig.jpg
  └── thumbnails/       ← thumbnail untuk list view (200×200px)
        ├── C001_thumb.jpg
        └── C002_thumb.jpg

Ukuran estimasi:
- Original: ~200–400KB per foto
- Thumbnail: ~15–30KB per foto
- 100 creatures: ~22–43MB total
- 500 creatures: ~110–215MB total
```

### 12.3 Backup & Export System

```dart
// Export koleksi sebagai JSON
Future<File> exportCollection() async {
  final data = {
    "version": "2.0",
    "exported_at": DateTime.now().toIso8601String(),
    "player": playerBox.get('player')?.toJson(),
    "creatures": creaturesBox.values.map((c) => c.toJson()).toList(),
    "bestiary": bestiaryBox.values.map((b) => b.toJson()).toList(),
  };
  // Simpan ke Downloads/morphanimal_backup_[date].json
}

// Import
Future<void> importCollection(File jsonFile) async {
  // Validate version
  // Merge atau overwrite (user pilih)
  // Validasi integritas data sebelum tulis
}
```

### 12.4 Backend (Supabase) — Data yang Disync

```sql
-- Hanya data ringan, TIDAK ada gambar
CREATE TABLE player_profiles (
  id UUID PRIMARY KEY,
  username TEXT,
  hunter_level INT,
  total_captures INT,
  legendary_count INT,
  updated_at TIMESTAMP
);

CREATE TABLE leaderboard (
  player_id UUID REFERENCES player_profiles,
  score INT,        -- total BST semua creature
  rank INT,
  week TEXT         -- "2024-W50" untuk weekly leaderboard
);
```

---

## 13. TECH STACK (IMPROVED)

### 13.1 Stack Lengkap

| Layer | Teknologi | Versi | Alasan |
|---|---|---|---|
| Framework | Flutter | 3.19+ | Cross-platform, performant |
| Language | Dart | 3.3+ | — |
| AI Inference | TFLite Flutter | 0.10+ | Offline inference |
| AI Model | iNaturalist TFLite | — | Akurasi hewan terbaik |
| Local DB | Hive | 2.x | Lebih cepat dari SQLite untuk objek |
| State Mgmt | Riverpod | 2.x | Sudah familiar (dari GanetZ) |
| Navigation | go_router | 13.x | Deklaratif, lebih clean |
| Image proc | flutter_image_compress | — | Kompresi sebelum simpan |
| Camera | camera | — | Kontrol penuh |
| Sharing | share_plus + screenshot | — | Share Morphanimal card |
| Animation | flutter_animate | — | Lightweight, powerful |
| Backend | Supabase Flutter | 2.x | Auth + realtime + leaderboard |
| Storage | path_provider | — | Akses direktori lokal |

### 13.2 Struktur Project (Clean Architecture)

```
lib/
├── core/
│   ├── constants/       ← element colors, rarity configs
│   ├── utils/           ← seed generator, image utils
│   └── theme/           ← app theme, color palette
├── data/
│   ├── models/          ← CreatureModel, PlayerModel
│   ├── repositories/    ← CreatureRepo, PlayerRepo
│   └── datasources/
│       ├── local/       ← HiveDataSource
│       └── remote/      ← SupabaseDataSource
├── domain/
│   ├── entities/        ← Creature, Player, Skill (pure Dart)
│   ├── usecases/        ← CaptureCreature, BattleCreature
│   └── repositories/    ← interfaces
├── presentation/
│   ├── screens/
│   │   ├── home/
│   │   ├── capture/
│   │   ├── battle/
│   │   ├── collection/
│   │   └── profile/
│   ├── widgets/         ← shared widgets
│   └── providers/       ← Riverpod providers
├── ai/
│   ├── animal_detector.dart
│   ├── species_classifier.dart
│   └── preprocessing.dart
└── game/
    ├── creature_generator.dart
    ├── battle_engine.dart
    ├── mission_generator.dart
    └── progression_calculator.dart
```

---

## 14. UI/UX DESIGN DIRECTION (IMPROVED)

### 14.1 Visual Identity

**Tema:** Dark Fantasy RPG — seperti dunia antara realita dan dimensi lain

**Color Palette:**
```
Background:    #0A0A0F  (near-black dengan hint biru gelap)
Surface:       #12121A  (card background)
Surface High:  #1C1C2A  (elevated card)
Primary:       #7B61FF  (violet — warna Hunter/magic)
Accent:        #FF6B35  (orange — warna capture/action)
Text Primary:  #F0F0FF  (putih kebiruan)
Text Muted:    #6B6B8A

Element Colors:
Fire:     #FF4500   Water: #00BFFF   Nature: #32CD32
Electric: #FFD700   Shadow: #8B00FF  Light:  #FFFACD
Wind:     #87CEEB   Earth:  #8B4513  Ice:    #E0FFFF
Poison:   #9400D3
```

**Typography:**
```
Display (nama creature, rarity reveal): Cinzel — serif fantasy
UI / Body: Inter — bersih, readable di dark mode
Stats / Numbers: JetBrains Mono — tegas, game-feel
```

### 14.2 Rarity Visual Treatment

```
Common    → Frame abu-abu, glow lemah
Rare      → Frame biru, glow biru
Epic      → Frame ungu, glow ungu + particle sparks
Legendary → Frame emas animasi, full glow + aura bergerak
```

### 14.3 Anti-Pattern yang Harus Dihindari

- Jangan gunakan Material default Card tanpa kustomisasi
- Jangan gunakan warna putih sebagai background (melanggar dark theme)
- Jangan gunakan icon default tanpa konsistensi visual style
- Jangan tampilkan loading tanpa indikator progress yang jelas
- Jangan ada dead-end screens tanpa navigasi kembali yang jelas

---

## 15. SPECIES DATABASE — SUPPORTED ANIMALS (BARU)

### 15.1 Phase 1 — 30 Spesies Prioritas

Dipilih berdasarkan: sering ditemukan di Indonesia, akurasi model tinggi

**Mamalia (12):**
Kucing domestik, Anjing domestik, Kucing kampung, Monyet ekor panjang,
Kelinci, Hamster, Marmut, Kucing hutan, Anjing liar, Sapi, Kambing, Domba

**Burung (10):**
Merpati, Burung gereja, Ayam, Bebek, Burung kutilang, Burung kenari,
Kakaktua, Elang jawa, Burung hantu, Merak

**Reptil & Amfibi (5):**
Tokek, Cicak, Iguana, Kura-kura, Katak

**Serangga & Lainnya (3):**
Kupu-kupu, Capung, Lebah

### 15.2 Phase 2 — Tambah 20 Spesies

Fokus hewan unik Asia Tenggara dan hewan liar yang lebih jarang:
Biawak, Ular sawah, Tupai, Kelelawar buah, Musang, dll.

### 15.3 Unknown Beast Pool

Untuk hewan yang tidak dikenali model, assign ke 5 kategori luas:
- Unknown Mammal, Unknown Bird, Unknown Reptile, Unknown Insect, Unknown Aquatic

---

## 16. ROADMAP PENGEMBANGAN (IMPROVED)

### Phase 1 — MVP Core (Estimasi: 6–8 minggu)
**Goal:** Aplikasi bisa dipakai dan menyenangkan untuk dikembalikan setiap hari

- [ ] Setup project Flutter + clean architecture
- [ ] Integrasi TFLite + iNaturalist model
- [ ] Camera flow + preprocessing
- [ ] Morphanimal generation system (species + element + rarity + seed)
- [ ] Stat generation + IV system
- [ ] Local storage (Hive) — save/load Morphanimal
- [ ] Collection screen (list + detail)
- [ ] Reveal animation (minimal tapi impactful)
- [ ] FTUE (onboarding + tutorial capture)
- [ ] Daily streak tracker

### Phase 2 — Engagement (Estimasi: 4–6 minggu)
**Goal:** User punya alasan kembali setiap hari

- [ ] Daily mission system
- [ ] Achievement system
- [ ] Bestiary / Pokédex screen
- [ ] Morphanimal rename + favorites
- [ ] Share card generator
- [ ] Export/import JSON backup
- [ ] Weather integration (OpenWeatherMap free)
- [ ] Unknown Morphanimal mechanic
- [ ] UI polish + animasi lebih kaya

### Phase 3 — Battle (Estimasi: 6–8 minggu)
**Goal:** Depth gameplay meningkat

- [ ] Battle engine (turn-based)
- [ ] PvE arena (CPU opponent)
- [ ] Morphanimal leveling + XP
- [ ] Evolution system
- [ ] Skill system lengkap
- [ ] Battle team builder (max 3)
- [ ] Item system (Capture Boost, Moonstone)

### Phase 4 — Social (Estimasi: 4–6 minggu)
**Goal:** Retensi komunitas + monetisasi opsional

- [ ] Supabase auth (guest → login)
- [ ] Weekly leaderboard (skor BST total)
- [ ] PvP asinkron
- [ ] AdMob integration (rewarded ads)
- [ ] Basic IAP (frame kosmetik)
- [ ] Notifikasi harian (Flutter Local Notifications)

---

## 17. RISIKO & MITIGASI (BARU)

| Risiko | Kemungkinan | Dampak | Mitigasi |
|---|---|---|---|
| Akurasi AI rendah di kondisi nyata | Tinggi | Tinggi | 2-stage pipeline, fallback Unknown Beast |
| APK size terlalu besar (model besar) | Sedang | Sedang | Gunakan quantized INT8 model, lazy-load |
| Storage pengguna cepat penuh | Sedang | Sedang | Kompresi agresif + opsi hapus raw foto |
| Supabase free tier habis | Rendah | Rendah | Data minimal di backend, bisa upgrade murah |
| Cheat/manipulate seed | Sedang | Rendah | Hash dengan deviceId + userId, validasi server |
| Plagiasi konsep | Rendah | Sedang | Publikasi di GitHub + timestamp commit |
| User bosan setelah koleksi penuh | Tinggi | Tinggi | Prestige system, seasonal events, battle |

---

## PENUTUP

Dokumen ini adalah GDD lengkap yang siap digunakan sebagai panduan implementasi. Langkah selanjutnya yang disarankan:

1. **Buat `DATA_SCHEMA.md`** — finalisasi semua Hive model
2. **Buat `MORPHANIMAL_BIBLE.md`** — daftar lengkap nama, skill, dan lore tiap spesies Morphanimal
3. **Buat wireframe** — minimal untuk FTUE, Home, Capture flow, dan Collection
4. **Mulai Phase 1 Sprint 1** — setup project + kamera + AI pipeline dulu

---

*Dokumen ini dapat dikembangkan lebih lanjut menjadi laporan akademik, proposal skripsi, atau pitching deck.*

**Versi:** 2.0.0 | **Author:** Morphanimal Dev | **Last Updated:** 2025
