# PLAN.md — Morphanimal

## Development Plan v1.0.0

**Target:** Flutter Android App (offline-first, zero-cost)
**Referensi:** GDD v2.0 + DESIGN.md v1.0
**Total Estimasi:** 20–28 minggu (solo developer, part-time)

---

## CARA MEMBACA DOKUMEN INI

```
STATUS TASK:
[ ] = Belum dimulai
[~] = Sedang dikerjakan
[x] = Selesai

ESTIMASI:
⏱ = estimasi waktu per task
📁 = file/folder yang dibuat
✅ = acceptance criteria (definisi "selesai")
⚠️  = potensi masalah / catatan penting
```

---

## PHASE 0 — SETUP & FONDASI

**Goal:** Project siap dikoding, semua tool terpasang, struktur folder bersih.
**Estimasi Total:** 3–5 hari

---

### TASK 0.1 — Persiapan Environment

⏱ 2–4 jam

**Checklist:**

- [ ] Install Flutter SDK versi stabil terbaru (≥ 3.19)
- [ ] Install Android Studio + Android SDK (API level 24 minimum, target 34)
- [ ] Pasang VS Code extension: Flutter, Dart, Riverpod Snippets
- [ ] Install FVM (Flutter Version Manager) untuk lock versi Flutter

**Perintah:**

```bash
# Cek instalasi
flutter doctor -v

# Install FVM
dart pub global activate fvm

# Lock versi Flutter di project nanti
fvm install stable
fvm use stable
```

✅ `flutter doctor` tidak ada tanda X (kecuali iOS, boleh diabaikan)
✅ `flutter --version` menampilkan versi ≥ 3.19

---

### TASK 0.2 — Buat Project Flutter

⏱ 1 jam

**Perintah:**

```bash
flutter create \
  --org com.morphanimal \
  --project-name morphanimal \
  --platforms android \
  morphanimal

cd morphanimal
```

📁 Struktur awal yang dibuat Flutter:

```
morphanimal/
├── android/
├── lib/
│   └── main.dart
├── pubspec.yaml
└── test/
```

✅ `flutter run` berhasil menampilkan counter app default di emulator/device
⚠️ Pilih nama package dengan hati-hati — susah diubah nanti

---

### TASK 0.3 — Setup Struktur Folder Clean Architecture

⏱ 2–3 jam

**Buat struktur folder ini secara manual atau dengan script:**

```bash
mkdir -p lib/{core/{constants,utils,theme,errors},data/{models,repositories,datasources/{local,remote}},domain/{entities,usecases,repositories},presentation/{screens/{home,capture,battle,collection,bestiary,profile,onboarding},widgets,providers},ai,game}

mkdir -p assets/{fonts,icons/elements,animations,images,backgrounds}
```

📁 Hasil akhir `lib/`:

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart      ← config nilai (threshold AI, dll)
│   │   ├── element_constants.dart  ← mapping elemen per spesies
│   │   └── rarity_constants.dart   ← rarity weights, stat ranges
│   ├── utils/
│   │   ├── seed_generator.dart     ← SHA256 seed logic
│   │   ├── image_utils.dart        ← compress, blur detect
│   │   └── date_utils.dart         ← golden hour check, streak logic
│   ├── theme/
│   │   ├── app_theme.dart          ← MaterialTheme setup
│   │   ├── app_colors.dart         ← semua warna dari DESIGN.md
│   │   ├── app_text_styles.dart    ← semua TextStyle
│   │   └── app_spacing.dart        ← spacing, radius, shadow constants
│   └── errors/
│       └── app_exceptions.dart     ← custom exception classes
├── data/
│   ├── models/
│   │   ├── creature_model.dart     ← Hive TypeAdapter
│   │   ├── player_model.dart
│   │   ├── skill_model.dart
│   │   └── bestiary_model.dart
│   ├── repositories/
│   │   ├── creature_repository_impl.dart
│   │   └── player_repository_impl.dart
│   └── datasources/
│       ├── local/
│       │   └── hive_datasource.dart
│       └── remote/
│           └── supabase_datasource.dart  ← stub dulu, Phase 4
├── domain/
│   ├── entities/
│   │   ├── creature.dart
│   │   ├── player.dart
│   │   └── skill.dart
│   ├── usecases/
│   │   ├── capture_creature.dart
│   │   ├── get_collection.dart
│   │   └── update_player.dart
│   └── repositories/
│       ├── creature_repository.dart   ← abstract interface
│       └── player_repository.dart
├── presentation/
│   ├── screens/ (masing-masing folder punya screen.dart + provider.dart)
│   ├── widgets/
│   │   ├── creature_card.dart
│   │   ├── element_badge.dart
│   │   ├── rarity_badge.dart
│   │   ├── stat_bar.dart
│   │   └── stat_grid.dart
│   └── providers/
│       └── providers.dart          ← semua Riverpod provider
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

✅ Semua folder dan file placeholder (kosong tapi ada) sudah dibuat
✅ Tidak ada file yang masih di luar struktur ini

---

### TASK 0.4 — Setup pubspec.yaml (Semua Dependencies)

⏱ 1–2 jam

**Isi `pubspec.yaml`:**

```yaml
name: morphanimal
description: Morphanimal
version: 1.0.0+1
publish_to: "none"

environment:
  sdk: ">=3.3.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

  # Navigation
  go_router: ^13.2.0

  # Local Database
  hive_flutter: ^1.1.0

  # AI / ML
  tflite_flutter: ^0.10.4

  # Camera & Image
  camera: ^0.10.5+9
  flutter_image_compress: ^2.2.0
  image: ^4.1.7

  # File System
  path_provider: ^2.1.3
  path: ^1.9.0

  # UI & Animation
  flutter_animate: ^4.5.0
  flutter_svg: ^2.0.9
  lottie: ^3.1.0
  confetti: ^0.7.0
  shimmer: ^3.0.0
  smooth_page_indicator: ^1.1.0
  gap: ^3.0.1

  # Fonts
  google_fonts: ^6.2.1

  # Sharing
  screenshot: ^2.1.0
  share_plus: ^9.0.0

  # Utils
  uuid: ^4.4.0
  crypto: ^3.0.3        ← untuk SHA256 seed
  intl: ^0.19.0

  # Backend (stub untuk Phase 4)
  supabase_flutter: ^2.5.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1
  build_runner: ^2.4.9
  riverpod_generator: ^2.4.3
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/fonts/
    - assets/icons/
    - assets/icons/elements/
    - assets/animations/
    - assets/images/
    - assets/models/        ← untuk file .tflite
```

**Perintah setelah edit:**

```bash
flutter pub get
```

✅ `flutter pub get` tidak ada error
✅ `flutter pub outdated` tidak ada package yang conflict
⚠️ `tflite_flutter` butuh setup NDK khusus di android/app/build.gradle — dikerjakan di Task 1.3

---

### TASK 0.5 — Setup Theme & Design System di Kode

⏱ 3–4 jam

**File yang dibuat:**

`lib/core/theme/app_colors.dart` — semua warna dari DESIGN.md (neutral palette, element palettes, rarity colors, semantic colors)

`lib/core/theme/app_text_styles.dart` — semua TextStyle (displayLarge, headingLarge, headingMedium, bodyLarge, bodyMedium, labelLarge, labelSmall, statNumber, statNumberLarge, numberBadge)

`lib/core/theme/app_spacing.dart` — semua konstanta spacing, radius, shadow

`lib/core/theme/app_theme.dart`:

```dart
// Konfigurasi MaterialTheme dengan:
// - colorScheme dari AppColors (light theme)
// - textTheme dari AppTextStyles
// - cardTheme: border radius 20dp, elevation 0
// - appBarTheme: backgroundColor transparent, elevation 0
// - bottomNavigationBarTheme: sesuai DESIGN.md
// - inputDecorationTheme: rounded
```

**Update `lib/main.dart`:**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  runApp(const ProviderScope(child: MorphanimalApp()));
}

class MorphanimalApp extends ConsumerWidget {
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Morphanimal',
      theme: AppTheme.light,
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
```

✅ App berjalan dengan background warna `#F5F5F5` (bukan putih default)
✅ Font Nunito terload (cek di emulator)
✅ Tidak ada warning "Material Design" di console

---

### TASK 0.6 — Setup Navigation (go_router)

⏱ 2–3 jam

📁 Buat `lib/core/router/app_router.dart`:

```dart
// Routes yang didefinisikan:
// /                → SplashScreen
// /onboarding      → OnboardingScreen
// /home            → HomeScreen (shell route)
// /home/collection → CollectionScreen
// /home/capture    → CaptureScreen
// /home/battle     → BattleScreen (stub)
// /home/bestiary   → BestiaryScreen
// /home/profile    → ProfileScreen
// /creature/:id    → CreatureDetailScreen
// /reveal          → RevealScreen (dengan extra data creature)

// Bottom nav sebagai ShellRoute
```

✅ Semua route terdaftar meski screen-nya masih placeholder
✅ Tombol back di setiap screen berfungsi
✅ Deep link `/creature/:id` bisa diakses langsung

---

### TASK 0.7 — Setup Git & GitHub

⏱ 30 menit

```bash
git init
echo "# Morphanimal — Morphanimal" > README.md
git add .
git commit -m "chore: initial project setup with clean architecture"

# Buat repo di GitHub (manual), lalu:
git remote add origin https://github.com/[username]/morphanimal.git
git push -u origin main
```

📁 Buat `.gitignore` yang mengecualikan:

```
.dart_tool/
build/
*.g.dart          ← generated Hive adapter (commit yang sudah final saja)
assets/models/    ← file .tflite terlalu besar untuk git, gunakan Git LFS
.env
```

✅ Repo ter-push ke GitHub
✅ File `.tflite` tidak masuk commit biasa

---

## PHASE 1 — CORE GAMEPLAY (MVP)

**Goal:** Bisa foto hewan → dapat Morphanimal → simpan ke koleksi. Loop utama jalan.
**Estimasi Total:** 6–8 minggu

---

### SPRINT 1.A — LOCAL DATABASE (HIVE)

**Estimasi:** 4–5 hari

---

#### TASK 1.A.1 — Definisi Entity & Model

⏱ 3–4 jam

📁 `lib/domain/entities/creature.dart`:

```dart
// Pure Dart class (no Hive annotation di sini)
class Creature {
  final String id;
  final String species;         // "Felis catus"
  final String commonName;      // "Kucing Domestik"
  final String creatureName;    // "Umbren Claw"
  final String element;         // "shadow"
  final String rarity;          // "epic"
  final int level;
  final int xp;
  final int hp; final int atk; final int def; final int spd;
  final Map<String, int> ivs;   // {"hp": 24, "atk": 18, ...}
  final List<String> skillIds;
  final String imagePath;       // path thumbnail
  final String rawImagePath;    // path foto asli
  final String seed;
  final DateTime capturedAt;
  final String? locationTag;
  final bool isFavorite;
}
```

📁 `lib/domain/entities/player.dart`:

```dart
class Player {
  final String id;
  final String name;
  final int level;
  final int xp;
  final int gold;
  final int streak;
  final DateTime lastLogin;
  final List<String> achievements;
  final List<String> battleTeamIds;  // max 3
}
```

📁 `lib/domain/entities/skill.dart`:

```dart
class Skill {
  final String id;
  final String name;
  final String element;
  final int power;
  final int accuracy;
  final int ppMax;
  final String? statusEffect;  // "burn" | "paralyze" | null
}
```

✅ Semua entity adalah pure Dart, tidak ada import Hive/Flutter di layer ini

---

#### TASK 1.A.2 — Hive Models (Data Layer)

⏱ 3–4 jam

📁 `lib/data/models/creature_model.dart`:

```dart
@HiveType(typeId: 0)
class CreatureModel extends HiveObject {
  @HiveField(0) late String id;
  @HiveField(1) late String species;
  // ... semua field sesuai entity Creature
  // Tambah method:
  // toEntity() → Creature
  // fromEntity(Creature) → CreatureModel
}
```

📁 `lib/data/models/player_model.dart` (typeId: 1)
📁 `lib/data/models/skill_model.dart` (typeId: 2)
📁 `lib/data/models/bestiary_model.dart` (typeId: 3):

```dart
@HiveType(typeId: 3)
class BestiaryModel extends HiveObject {
  @HiveField(0) late String species;
  @HiveField(1) late bool discovered;
  @HiveField(2) late int captureCount;
  @HiveField(3) DateTime? firstCaptured;
}
```

**Generate adapter:**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

📁 File generated: `*.g.dart` untuk setiap model

✅ `build_runner` tidak error
✅ File `creature_model.g.dart` berisi `CreatureModelAdapter`

---

#### TASK 1.A.3 — Hive Datasource

⏱ 4–5 jam

📁 `lib/data/datasources/local/hive_datasource.dart`:

```dart
class HiveLocalDatasource {
  static const String creaturesBox = 'creatures';
  static const String playerBox    = 'player';
  static const String bestiaryBox  = 'bestiary';
  static const String skillsBox    = 'skills';

  // Inisialisasi (dipanggil di main.dart):
  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CreatureModelAdapter());
    Hive.registerAdapter(PlayerModelAdapter());
    Hive.registerAdapter(SkillModelAdapter());
    Hive.registerAdapter(BestiaryModelAdapter());
    await Hive.openBox<CreatureModel>(creaturesBox);
    await Hive.openBox<PlayerModel>(playerBox);
    await Hive.openBox<BestiaryModel>(bestiaryBox);
    await Hive.openBox<SkillModel>(skillsBox);
  }

  // CRUD Creature:
  Future<void> saveCreature(CreatureModel creature);
  Future<CreatureModel?> getCreature(String id);
  Future<List<CreatureModel>> getAllCreatures();
  Future<void> updateCreature(CreatureModel creature);
  Future<void> deleteCreature(String id);

  // Player:
  Future<void> savePlayer(PlayerModel player);
  Future<PlayerModel?> getPlayer();

  // Bestiary:
  Future<void> markSpeciesDiscovered(String species);
  Future<List<BestiaryModel>> getAllBestiaryEntries();
}
```

✅ Unit test: save Morphanimal → get Morphanimal → data sama
✅ Unit test: save player → update XP → get player → XP terupdate

---

#### TASK 1.A.4 — Repository Implementation

⏱ 3 jam

📁 `lib/domain/repositories/creature_repository.dart` (interface):

```dart
abstract class CreatureRepository {
  Future<void> save(Creature creature);
  Future<Creature?> findById(String id);
  Future<List<Creature>> getAll({String? filterElement, String? filterRarity});
  Future<void> update(Creature creature);
  Future<void> delete(String id);
}
```

📁 `lib/data/repositories/creature_repository_impl.dart` (implementasi):

- Inject `HiveLocalDatasource`
- Konversi antara `Morphanimal` entity ↔ `MorphanimalModel`
- Implementasi semua method interface

📁 `lib/presentation/providers/providers.dart`:

```dart
// Riverpod providers:
final hiveDatasourceProvider = Provider((ref) => HiveLocalDatasource());
final creatureRepositoryProvider = Provider((ref) =>
  CreatureRepositoryImpl(ref.watch(hiveDatasourceProvider)));
final collectionProvider = FutureProvider<List<Creature>>((ref) =>
  ref.watch(creatureRepositoryProvider).getAll());
```

✅ `collectionProvider` dapat diwatch dari widget tanpa error

---

### SPRINT 1.B — AI PIPELINE

**Estimasi:** 7–10 hari

---

#### TASK 1.B.1 — Download & Setup Model TFLite

⏱ 2–3 jam

**Download model:**

```bash
# iNaturalist model (pilih salah satu):
# Option A: Seek app model (dari GitHub iNaturalist/SeekReactNative)
# Option B: TFLite model zoo — MobileNetV3

# Simpan ke:
mkdir -p assets/models
# Letakkan file:
# assets/models/animal_classifier.tflite     ← iNaturalist/MobileNet
# assets/models/animal_labels.txt            ← label per class
```

**Setup `android/app/build.gradle`:**

```groovy
android {
    aaptOptions {
        noCompress "tflite"  // Jangan compress file model
    }
}
```

**Update `pubspec.yaml`:**

```yaml
flutter:
  assets:
    - assets/models/animal_classifier.tflite
    - assets/models/animal_labels.txt
```

✅ `flutter run` tidak crash saat akses asset model
⚠️ File `.tflite` bisa >20MB — gunakan `git lfs track "*.tflite"` sebelum commit

---

#### TASK 1.B.2 — Image Preprocessing

⏱ 4–5 jam

📁 `lib/ai/preprocessing.dart`:

```dart
class ImagePreprocessor {
  // 1. Blur detection (Laplacian variance)
  static Future<bool> isBlurry(File imageFile) async {
    // Load image → grayscale → hitung Laplacian variance
    // Return true jika variance < 100 (terlalu blur)
  }

  // 2. Resize & center crop ke 224×224
  static Future<Uint8List> prepareForModel(File imageFile) async {
    // Baca file → decode → resize ke 224×224
    // Normalize pixel: (pixel / 255.0 - 0.5) / 0.5
    // Return Float32List untuk input TFLite
  }

  // 3. Compress untuk storage
  static Future<File> compressForStorage(File imageFile, String outputPath) async {
    // Gunakan flutter_image_compress
    // Quality: 80, maxWidth: 1080
  }

  // 4. Generate thumbnail
  static Future<File> generateThumbnail(File imageFile, String outputPath) async {
    // Quality: 70, maxWidth: 300, maxHeight: 300
  }
}
```

✅ Unit test: foto blur di-reject (return `isBlurry: true`)
✅ Unit test: foto bersih di-accept
✅ Output `prepareForModel` adalah `Uint8List` ukuran 224×224×3×4 bytes

---

#### TASK 1.B.3 — Animal Detector (Stage 1)

⏱ 4–5 jam

📁 `lib/ai/animal_detector.dart`:

```dart
class AnimalDetector {
  late Interpreter _interpreter;
  late List<String> _labels;

  Future<void> initialize() async {
    _interpreter = await Interpreter.fromAsset('assets/models/animal_classifier.tflite');
    final labelData = await rootBundle.loadString('assets/models/animal_labels.txt');
    _labels = labelData.split('\n');
  }

  // Return true jika ada hewan terdeteksi dengan confidence ≥ 0.60
  Future<bool> isAnimal(Uint8List preprocessedInput) async {
    // Run inference
    // Cek apakah top-1 label masuk kategori hewan
    // Threshold: 0.60
  }

  void dispose() => _interpreter.close();
}
```

✅ Test dengan foto kucing → return `true`
✅ Test dengan foto batu/pemandangan → return `false`
⚠️ Model harus di-load sekali saja (singleton/provider), bukan tiap capture

---

#### TASK 1.B.4 — Species Classifier (Stage 2)

⏱ 5–6 jam

📁 `lib/ai/species_classifier.dart`:

```dart
class DetectionResult {
  final String species;       // "Felis catus"
  final String commonName;    // "Kucing Domestik"
  final String animalGroup;   // "cat", "dog", "bird", etc.
  final double confidence;
}

class SpeciesClassifier {
  // Map dari label model → group & common name
  static const Map<String, AnimalInfo> speciesDatabase = {
    'Felis catus':          AnimalInfo(group: 'cat',   commonName: 'Kucing Domestik'),
    'Canis lupus familiaris': AnimalInfo(group: 'dog', commonName: 'Anjing'),
    'Columba livia':        AnimalInfo(group: 'bird',  commonName: 'Merpati'),
    // ... 30 spesies dari GDD Section 15
    'unknown':              AnimalInfo(group: 'unknown', commonName: 'Unknown Beast'),
  };

  Future<List<DetectionResult>> classify(Uint8List input) async {
    // Run inference → ambil top-5 results
    // Filter: confidence ≥ 0.15 (sangat toleran)
    // Map label ke speciesDatabase
    // Return List<DetectionResult> sorted by confidence
  }

  // Decision logic sesuai GDD:
  DetectionResult? pickResult(List<DetectionResult> results) {
    if (results.isEmpty) return null;
    final top = results.first;
    if (top.confidence >= 0.65) return top;  // Auto-pick
    if (top.confidence >= 0.40) return null;  // Minta user pilih (return null = ambiguous)
    return DetectionResult.unknown();          // Unknown Beast
  }
}
```

✅ Test dengan foto kucing → species "Felis catus", confidence > 0.65
✅ Test dengan foto buram → return Unknown Beast atau reject
✅ Test dengan foto hewan tidak dikenal → return Unknown Beast

---

#### TASK 1.B.5 — Integrasi AI ke Provider

⏱ 3–4 jam

📁 Update `lib/presentation/providers/providers.dart`:

```dart
// Singleton AI providers (lazy initialized):
final animalDetectorProvider = Provider<AnimalDetector>((ref) {
  final detector = AnimalDetector();
  ref.onDispose(() => detector.dispose());
  return detector;
});

final speciesClassifierProvider = Provider<SpeciesClassifier>(...);

// State untuk proses capture:
enum CaptureStatus { idle, scanning, ambiguous, failed, success }

@riverpod
class CaptureNotifier extends _$CaptureNotifier {
  CaptureState build() => CaptureState.idle();

  Future<void> analyzeImage(File imageFile) async {
    // 1. Cek blur
    // 2. Stage 1: isAnimal?
    // 3. Stage 2: classify species
    // 4. Update state sesuai hasil
  }
}
```

✅ State `CaptureStatus` berubah dengan benar di setiap tahap
✅ Tidak ada memory leak (dispose dipanggil)

---

### SPRINT 1.C — MORPHANIMAL GENERATION SYSTEM

**Estimasi:** 5–7 hari

---

#### TASK 1.C.1 — Seed Generator

⏱ 2–3 jam

📁 `lib/core/utils/seed_generator.dart`:

```dart
import 'package:crypto/crypto.dart';

class SeedGenerator {
  // Deterministik: sama foto + user + timestamp = sama seed
  static String generate({
    required Uint8List imageBytes,
    required String userId,
    required DateTime captureTime,
  }) {
    final input = [
      ...imageBytes.sublist(0, min(1024, imageBytes.length)),
      ...utf8.encode(userId),
      ...utf8.encode(captureTime.millisecondsSinceEpoch.toString()),
    ];
    return sha256.convert(input).toString();
  }

  // Random number dari seed (deterministik)
  static double seededDouble(String seed, String salt) {
    final hash = sha256.convert(utf8.encode(seed + salt)).bytes;
    final value = (hash[0] << 24 | hash[1] << 16 | hash[2] << 8 | hash[3]);
    return value / 0xFFFFFFFF;
  }

  static int seededInt(String seed, String salt, int min, int max) {
    final d = seededDouble(seed, salt);
    return (min + d * (max - min)).floor();
  }
}
```

✅ Unit test: seed sama → seededDouble sama (deterministik)
✅ Unit test: seed berbeda → seededDouble berbeda (tidak collision)

---

#### TASK 1.C.2 — Element & Rarity Resolver

⏱ 3–4 jam

📁 `lib/core/constants/element_constants.dart`:

```dart
// Map animal group → element primer + secondary options
const Map<String, ElementMapping> animalElementMap = {
  'cat':      ElementMapping(primary: 'shadow',   secondary: ['fire', 'electric']),
  'dog':      ElementMapping(primary: 'nature',   secondary: ['light', 'water']),
  'bird':     ElementMapping(primary: 'wind',     secondary: ['light', 'electric']),
  'raptor':   ElementMapping(primary: 'fire',     secondary: ['shadow', 'wind']),
  'reptile':  ElementMapping(primary: 'earth',    secondary: ['shadow', 'poison']),
  'fish':     ElementMapping(primary: 'water',    secondary: ['electric', 'ice']),
  'insect':   ElementMapping(primary: 'poison',   secondary: ['nature', 'wind']),
  'amphibian':ElementMapping(primary: 'water',    secondary: ['nature', 'earth']),
  'primate':  ElementMapping(primary: 'nature',   secondary: ['light', 'earth']),
  'unknown':  ElementMapping(primary: null,       secondary: ['fire','water','shadow','electric','nature']),
};
```

📁 `lib/game/creature_generator.dart` — `ElementResolver`:

```dart
class ElementResolver {
  static String resolve(String animalGroup, DateTime captureTime, String seed) {
    final mapping = animalElementMap[animalGroup] ?? animalElementMap['unknown']!;
    final hour = captureTime.hour;

    // Time modifier (sesuai GDD 3.4)
    bool isNight = hour >= 20 || hour < 5;
    bool isGoldenHour = (hour >= 6 && hour < 8) || (hour >= 17 && hour < 19);

    // Jika ada time modifier kuat, ada 30% chance override
    if (isNight && SeedGenerator.seededDouble(seed, 'night') < 0.30) {
      return 'shadow';
    }
    if (isGoldenHour && SeedGenerator.seededDouble(seed, 'golden') < 0.30) {
      return 'light';
    }

    // 70% primary, 30% secondary
    if (mapping.primary != null && SeedGenerator.seededDouble(seed, 'elem') < 0.70) {
      return mapping.primary!;
    }

    // Pilih dari secondary secara random
    final idx = SeedGenerator.seededInt(seed, 'elem2', 0, mapping.secondary.length);
    return mapping.secondary[idx];
  }
}
```

📁 `lib/game/creature_generator.dart` — `RarityResolver`:

```dart
class RarityResolver {
  static String resolve(String seed, int streakDays) {
    final roll = SeedGenerator.seededDouble(seed, 'rarity');
    final bonus = min(streakDays * 0.01, 0.05);
    final final_roll = roll + bonus;

    if (final_roll < 0.55) return 'common';
    if (final_roll < 0.80) return 'rare';
    if (final_roll < 0.95) return 'epic';
    return 'legendary';
  }
}
```

✅ Unit test: seed sama → element dan rarity sama
✅ Unit test: 100 run → distribusi rarity sesuai probabilitas (~55% common, ~25% rare, ~15% epic, ~5% legendary)

---

#### TASK 1.C.3 — Stat Calculator

⏱ 3–4 jam

📁 `lib/core/constants/rarity_constants.dart`:

```dart
// Stat ranges sesuai GDD Section 5.1
const Map<String, StatRange> rarityStatRanges = {
  'common':    StatRange(hp:[80,120],  atk:[40,70],  def:[30,60],  spd:[40,80]),
  'rare':      StatRange(hp:[120,180], atk:[70,110], def:[60,100], spd:[80,120]),
  'epic':      StatRange(hp:[180,260], atk:[110,160],def:[100,150],spd:[120,170]),
  'legendary': StatRange(hp:[260,350], atk:[160,220],def:[150,200],spd:[170,230]),
};

// Species modifier (GDD 5.2)
const Map<String, StatModifier> speciesModifiers = {
  'cat': StatModifier(hp:-0.10, atk:+0.15, def:0, spd:+0.10),
  'dog': StatModifier(hp:+0.15, atk:-0.10, def:+0.10, spd:0),
  // ...
};
```

📁 `lib/game/creature_generator.dart` — `StatCalculator`:

```dart
class StatCalculator {
  static CreatureStats calculate(String rarity, String animalGroup, String seed) {
    final range = rarityStatRanges[rarity]!;
    final modifier = speciesModifiers[animalGroup] ?? StatModifier.zero();

    // Base stats dari seed (deterministik dalam range)
    int baseHp  = SeedGenerator.seededInt(seed, 'hp',  range.hp[0],  range.hp[1]);
    int baseAtk = SeedGenerator.seededInt(seed, 'atk', range.atk[0], range.atk[1]);
    int baseDef = SeedGenerator.seededInt(seed, 'def', range.def[0], range.def[1]);
    int baseSpd = SeedGenerator.seededInt(seed, 'spd', range.spd[0], range.spd[1]);

    // IV (0–31 per stat, sesuai GDD 5.3)
    int ivHp  = SeedGenerator.seededInt(seed, 'iv_hp',  0, 31);
    int ivAtk = SeedGenerator.seededInt(seed, 'iv_atk', 0, 31);
    int ivDef = SeedGenerator.seededInt(seed, 'iv_def', 0, 31);
    int ivSpd = SeedGenerator.seededInt(seed, 'iv_spd', 0, 31);

    // Apply species modifier
    baseHp  = (baseHp  * (1 + modifier.hp)).round();
    baseAtk = (baseAtk * (1 + modifier.atk)).round();
    // ...

    // Final stat formula: floor((base*2 + iv) * level/100 + 5)
    // Level awal = 1, jadi:
    return CreatureStats(
      hp:  ((baseHp  * 2 + ivHp)  * 1 / 100 + 5).floor(),
      atk: ((baseAtk * 2 + ivAtk) * 1 / 100 + 5).floor(),
      def: ((baseDef * 2 + ivDef) * 1 / 100 + 5).floor(),
      spd: ((baseSpd * 2 + ivSpd) * 1 / 100 + 5).floor(),
      ivs: {'hp': ivHp, 'atk': ivAtk, 'def': ivDef, 'spd': ivSpd},
      baseHp: baseHp, baseAtk: baseAtk, baseDef: baseDef, baseSpd: baseSpd,
    );
  }
}
```

✅ Unit test: stat selalu dalam range rarity yang sesuai
✅ Unit test: BST (sum semua stat) sesuai tabel GDD

---

#### TASK 1.C.4 — Name Generator

⏱ 2–3 jam

📁 `lib/game/creature_generator.dart` — `NameGenerator`:

```dart
const Map<String, List<String>> elementPrefixes = {
  'fire':     ['Embara', 'Pyrion', 'Ignar', 'Blazen', 'Ashur'],
  'water':    ['Aquon', 'Tidalis', 'Marinu', 'Deepon', 'Waven'],
  'shadow':   ['Umbren', 'Nyxar', 'Shaden', 'Voidex', 'Duskon'],
  'electric': ['Voltis', 'Zaphar', 'Strikun', 'Sparken', 'Jolton'],
  'nature':   ['Viron', 'Leafar', 'Thornex', 'Groven', 'Bloomin'],
  'light':    ['Lumis', 'Radion', 'Glowex', 'Solaen', 'Auron'],
  'wind':     ['Zephyr', 'Gustin', 'Airon', 'Galeton', 'Drafton'],
  'earth':    ['Terron', 'Rockus', 'Clayen', 'Mudix', 'Stonex'],
  'ice':      ['Glacen', 'Frostin', 'Cryox', 'Chillon', 'Blizon'],
  'poison':   ['Toxen', 'Venaris', 'Corron', 'Sporon', 'Acidex'],
};

const Map<String, List<String>> animalSuffixes = {
  'cat':    ['Claw', 'Paw', 'Fang', 'Whisker', 'Tail'],
  'dog':    ['Hound', 'Fang', 'Howl', 'Guard', 'Paw'],
  'bird':   ['Wing', 'Talon', 'Feather', 'Sky', 'Beak'],
  // ...
};

class NameGenerator {
  static String generate(String element, String animalGroup, String rarity, String seed) {
    final prefixes = elementPrefixes[element] ?? elementPrefixes['shadow']!;
    final suffixes = animalSuffixes[animalGroup] ?? ['Beast'];

    final prefixIdx = SeedGenerator.seededInt(seed, 'name_prefix', 0, prefixes.length);
    final suffixIdx = SeedGenerator.seededInt(seed, 'name_suffix', 0, suffixes.length);

    final base = '${prefixes[prefixIdx]} ${suffixes[suffixIdx]}';

    // Legendary: tambahkan epitet
    if (rarity == 'legendary') {
      const epithets = ['the Undying', 'of the Ember', 'the Ancient', 'the Silent', 'Prime'];
      final epIdx = SeedGenerator.seededInt(seed, 'epithet', 0, epithets.length);
      return '$base ${epithets[epIdx]}';
    }
    return base;
  }
}
```

✅ Test: nama selalu terdiri dari prefix + suffix minimal
✅ Test: Legendary selalu punya epithet
✅ Test: seed sama → nama sama (deterministik)

---

#### TASK 1.C.5 — Skill Assigner

⏱ 3–4 jam

📁 `lib/core/constants/skill_database.dart`:

```dart
// Daftar semua skill per elemen (sesuai GDD 6.4)
// Setiap elemen punya 5–8 skill
const Map<String, List<SkillData>> skillsByElement = {
  'fire': [
    SkillData(id:'fire_1', name:'Ember Strike',   power:60, accuracy:95, pp:10),
    SkillData(id:'fire_2', name:'Inferno Blast',  power:90, accuracy:80, pp:5, effect:'burn'),
    SkillData(id:'fire_3', name:'Heat Wave',      power:70, accuracy:90, pp:8),
    SkillData(id:'fire_4', name:'Flame Claw',     power:50, accuracy:100,pp:15),
    SkillData(id:'fire_5', name:'Solar Burst',    power:120,accuracy:70, pp:3, effect:'burn'),
  ],
  'shadow': [
    SkillData(id:'shad_1', name:'Shadow Claw',    power:70, accuracy:90, pp:8, effect:'paralyze'),
    SkillData(id:'shad_2', name:'Night Slash',    power:60, accuracy:95, pp:10),
    SkillData(id:'shad_3', name:'Void Pulse',     power:80, accuracy:85, pp:6),
    SkillData(id:'shad_4', name:'Dark Shroud',    power:40, accuracy:100,pp:15, effect:'confuse'),
    SkillData(id:'shad_5', name:'Umbral Strike',  power:100,accuracy:75, pp:4),
  ],
  // ... semua 10 elemen
};
```

📁 `lib/game/creature_generator.dart` — `SkillAssigner`:

```dart
class SkillAssigner {
  // Sesuai GDD: 1-2 skill dari element primer (dijamin), 1 dari species, 1 random
  static List<String> assign(String element, String animalGroup, String rarity, String seed) {
    final elementSkills = skillsByElement[element] ?? [];
    final skills = <String>[];

    // Skill 1: dari element (guaranteed)
    skills.add(_pickSkill(elementSkills, seed, 'skill1'));

    // Skill 2: dari element jika Rare+
    if (rarity != 'common' && elementSkills.length > 1) {
      skills.add(_pickSkill(elementSkills, seed, 'skill2', exclude: skills));
    }

    // Skill 3: dari species (jika ada mappingnya)
    final speciesSkill = speciesSkillMap[animalGroup];
    if (speciesSkill != null) skills.add(speciesSkill);

    // Skill 4: random dari semua skill, hanya Epic+
    if (rarity == 'epic' || rarity == 'legendary') {
      final allSkills = skillsByElement.values.expand((s) => s).toList();
      skills.add(_pickSkill(allSkills, seed, 'skill4', exclude: skills));
    }

    return skills.map((s) => s.id).toList();
  }
}
```

✅ Common → 1–2 skill
✅ Legendary → 4 skill
✅ Tidak ada skill duplikat dalam satu Morphanimal

---

#### TASK 1.C.6 — MorphanimalGenerator (Orchestrator)

⏱ 2–3 jam

📁 `lib/game/creature_generator.dart` — class utama:

```dart
class CreatureGenerator {
  static Creature generate({
    required DetectionResult detection,
    required File imageFile,
    required String userId,
    required Player player,
  }) {
    final captureTime = DateTime.now();
    final seed = SeedGenerator.generate(
      imageBytes: imageFile.readAsBytesSync(),
      userId: userId,
      captureTime: captureTime,
    );

    final element = ElementResolver.resolve(detection.animalGroup, captureTime, seed);
    final rarity  = RarityResolver.resolve(seed, player.streak);
    final stats   = StatCalculator.calculate(rarity, detection.animalGroup, seed);
    final name    = NameGenerator.generate(element, detection.animalGroup, rarity, seed);
    final skills  = SkillAssigner.assign(element, detection.animalGroup, rarity, seed);

    return Creature(
      id:           const Uuid().v4(),
      species:      detection.species,
      commonName:   detection.commonName,
      creatureName: name,
      element:      element,
      rarity:       rarity,
      level:        1,
      xp:           0,
      hp:           stats.hp,
      atk:          stats.atk,
      def:          stats.def,
      spd:          stats.spd,
      ivs:          stats.ivs,
      skillIds:     skills,
      imagePath:    '',         // diisi setelah save gambar
      rawImagePath: '',
      seed:         seed,
      capturedAt:   captureTime,
      isFavorite:   false,
    );
  }
}
```

✅ Integration test: berikan foto + user → Morphanimal lengkap ter-generate
✅ Morphanimal yang sama (seed sama) → selalu sama atributnya

---

### SPRINT 1.D — CAMERA & CAPTURE FLOW

**Estimasi:** 5–7 hari

---

#### TASK 1.D.1 — Permission Handler

⏱ 2 jam

📁 `lib/core/utils/permission_handler.dart`:

```dart
// Minta permission: camera, storage (READ_EXTERNAL_STORAGE / WRITE)
// Tampilkan dialog ramah sebelum request (bukan langsung minta)
// Handle: denied → explain, permanentlyDenied → buka settings
```

**Update `android/app/src/main/AndroidManifest.xml`:**

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"
    android:maxSdkVersion="28" />
```

✅ Di Android 13+: permission kamera muncul dengan dialog sistem
✅ Jika ditolak: muncul penjelasan + tombol "Buka Pengaturan"

---

#### TASK 1.D.2 — CaptureScreen UI

⏱ 4–5 jam

📁 `lib/presentation/screens/capture/capture_screen.dart`:

**Komponen yang dirender:**

1. Live camera viewfinder (full screen, pakai `CameraPreview`)
2. Overlay semi-transparent dengan crosshair target di tengah
3. Teks "Arahkan ke hewan..." di bawah crosshair
4. Bottom bar: ikon galeri kiri, tombol capture tengah, toggle flash kanan
5. AppBar transparan dengan tombol kembali

**State machine UI:**

```dart
// State: idle → scanning → result

// IDLE: tampilkan viewfinder + tombol capture normal
// SCANNING: tombol capture disable, overlay "AI Menganalisis..." + progress bar
// AMBIGUOUS: bottom sheet muncul dengan 3 opsi pilih spesies
// FAILED: snackbar merah + shake animation + tips retry
// SUCCESS: navigate ke RevealScreen dengan data creature
```

✅ Viewfinder mengisi layar penuh tanpa letterbox
✅ Tombol capture punya efek scale 0.92 saat ditekan
✅ Loading state tampil dengan teks informatif

---

#### TASK 1.D.3 — Image Save Flow

⏱ 3–4 jam

📁 `lib/core/utils/image_utils.dart`:

```dart
class ImageUtils {
  static Future<String> getStorageDir() async {
    // Gunakan path_provider
    // Return: /data/data/com.morphanimal/files/morphanimal/
  }

  static Future<({String original, String thumbnail})> saveCreatureImages(
    File capturedFile,
    String creatureId,
  ) async {
    // 1. Compress original → simpan ke /originals/[id]_orig.jpg
    // 2. Buat thumbnail → simpan ke /thumbnails/[id]_thumb.jpg
    // 3. Return kedua path
  }

  static Future<void> deleteCreatureImages(String creatureId) async {
    // Hapus original + thumbnail berdasarkan ID
  }
}
```

✅ Original file size < 500KB setelah kompresi
✅ Thumbnail file size < 50KB
✅ Path tersimpan benar di Morphanimal entity

---

#### TASK 1.D.4 — CaptureNotifier (Use Case Orchestration)

⏱ 4–5 jam

📁 `lib/presentation/screens/capture/capture_provider.dart`:

```dart
@riverpod
class CaptureNotifier extends _$CaptureNotifier {
  Future<void> onCapture(File imageFile) async {
    state = CaptureState.scanning();

    // 1. Blur check
    if (await ImagePreprocessor.isBlurry(imageFile)) {
      state = CaptureState.failed(reason: FailReason.blurry);
      return;
    }

    // 2. Preprocess
    final input = await ImagePreprocessor.prepareForModel(imageFile);

    // 3. Stage 1: animal check
    final isAnimal = await ref.read(animalDetectorProvider).isAnimal(input);
    if (!isAnimal) {
      state = CaptureState.failed(reason: FailReason.notAnimal);
      return;
    }

    // 4. Stage 2: classify
    final results = await ref.read(speciesClassifierProvider).classify(input);
    final top = ref.read(speciesClassifierProvider).pickResult(results);

    if (top == null) {
      // Ambiguous — minta user pilih
      state = CaptureState.ambiguous(options: results.take(3).toList());
      return;
    }

    // 5. Generate creature
    final player = await ref.read(playerRepositoryProvider).get();
    final creature = CreatureGenerator.generate(
      detection: top,
      imageFile: imageFile,
      userId: player.id,
      player: player,
    );

    // 6. Save images
    final paths = await ImageUtils.saveCreatureImages(imageFile, creature.id);
    final creatureWithPaths = creature.copyWith(
      imagePath: paths.thumbnail,
      rawImagePath: paths.original,
    );

    // 7. Save to Hive
    await ref.read(creatureRepositoryProvider).save(creatureWithPaths);

    // 8. Update player (XP, streak, bestiary)
    await _updatePlayerAfterCapture(player, creatureWithPaths);

    state = CaptureState.success(creature: creatureWithPaths);
  }
}
```

✅ End-to-end: foto → state.success dengan Morphanimal lengkap
✅ Jika gagal di manapun: state.failed dengan reason yang tepat

---

### SPRINT 1.E — REVEAL ANIMATION

**Estimasi:** 3–4 hari

---

#### TASK 1.E.1 — RevealScreen

⏱ 5–8 jam

📁 `lib/presentation/screens/capture/reveal_screen.dart`:

**10-step sequential animation (sesuai DESIGN.md 7.3):**

```dart
// Gunakan flutter_animate dengan delay chaining

// Step 1 (0ms):     Background fade ke warna elemen (300ms)
// Step 2 (300ms):   Egg/orb muncul dari bawah, scale 0→1 (400ms, easeOutBack)
// Step 3 (700ms):   Orb pulse/shake (500ms)
// Step 4 (1200ms):  Flash putih full screen (100ms)
// Step 5 (1300ms):  Foto creature muncul, scale 0.5→1.0 (400ms, easeOutBack)
// Step 6 (1700ms):  Rarity glow ring muncul di sekeliling foto (300ms)
// Step 7 (2000ms):  Nama creature slide dari bawah (300ms)
// Step 8 (2300ms):  Element badge + rarity badge fade in (200ms)
// Step 9 (2500ms):  Stat preview (HP/ATK) fade in (200ms)
// Step 10 (2700ms): Tombol "Tambah ke Koleksi" bounce in (300ms)

// LEGENDARY: tambahkan Confetti widget di atas semua layer
```

✅ Animasi tidak skip/glitch di device low-end
✅ Legendary memiliki confetti + glow emas
✅ Tombol CTA muncul setelah animasi selesai (bukan sebelum)

---

### SPRINT 1.F — COLLECTION & DETAIL SCREEN

**Estimasi:** 5–7 hari

---

#### TASK 1.F.1 — Widget: CreatureCard

⏱ 4–5 jam

📁 `lib/presentation/widgets/creature_card.dart`:

- Mode grid (compact 200dp) dan mode list
- Background warna elemen sesuai DESIGN.md `ElementColors`
- Hero widget pada artwork (untuk shared element transition)
- Hero widget pada background (warna elemen)
- Tampilkan: nama, nomor (formatted "No.042"), element badge, rarity badge, artwork emoji/foto

✅ Warna background sesuai elemen creature
✅ Shadow berwarna sesuai elemen (bukan abu-abu biasa)
✅ Tap ripple menggunakan `InkWell` dengan splash color dari elemen

---

#### TASK 1.F.2 — Widget: StatBar

⏱ 2–3 jam

📁 `lib/presentation/widgets/stat_bar.dart`:

- Animated width dari 0 → target saat pertama kali mount
- Label: HP/ATK/DEF/SPD (fixed 36dp, right-align)
- Bar: warna bisa dikonfigurasi, 7dp tinggi, pill radius
- Value: JetBrains Mono, 38dp fixed right-align

✅✅ Animasi jalan saat screen pertama dibuka
✅✅ Angka tidak meluap dari container

---

#### TASK 1.F.3 — Widget: ElementBadge & RarityBadge

⏱ 1–2 jam

📁 `lib/presentation/widgets/element_badge.dart`
📁 `lib/presentation/widgets/rarity_badge.dart`

Sesuai spesifikasi DESIGN.md Section 5.2 dan 5.3.

✅✅ Badge Electric: teks gelap (bukan putih, karena background kuning terang)
✅✅ Badge Legendary: border emas, teks emas (bukan background solid)

---

#### TASK 1.F.4 — CollectionScreen

⏱ 5–6 jam

📁 `lib/presentation/screens/collection/collection_screen.dart`:

**Layout:**

- AppBar: judul + filter sort (bottom sheet)
- Filter tab horizontal: Semua | Fire | Water | dst (horizontal scroll)
- Grid 2 kolom dengan `SliverGrid`
- Empty state: ilustrasi + teks "Belum ada kreatur. Mulai foto!"

**Fitur sort (bottom sheet):**

- Terbaru (default)
- Rarity (Legendary dulu)
- Level tertinggi
- Nama A-Z

**Provider filter:**

```dart
@riverpod
List<Creature> filteredCollection(FilteredCollectionRef ref, {
  String? elementFilter,
  SortOption sortOption = SortOption.newest,
}) {
  final all = ref.watch(collectionProvider).valueOrNull ?? [];
  // apply filter + sort
  return result;
}
```

✅✅ Filter elemen berfungsi real-time
✅✅ Grid list support staggered animation
✅✅ Search case-insensitive
✅✅ Empty state tampil dengan baik saat koleksi kosong

---

#### TASK 1.F.5 — CreatureDetailScreen

⏱ 6–7 jam

📁 `lib/presentation/screens/collection/creature_detail_screen.dart`:

**Sections (scroll view):**

1. Hero card (280dp) — nama, no, badges, artwork (Hero widget)
2. About grid (2×2) — species, element, tanggal, lokasi
3. Stats — 4 StatBar dengan animasi
4. IV quality bar — "Great (81%)" dengan warna
5. Skills — daftar skill card
6. Action bar bawah — Rename | Set ke Tim | Share

**Rename dialog:**

```dart
// TextField dengan max 20 karakter
// Validasi: tidak boleh kosong, tidak boleh angka saja
// Setelah save: update di Hive, refresh collection
```

✅ Shared element transition dari collection card berjalan mulus
✅ Rename tersimpan dan tampil langsung tanpa reload
✅ Share button membuka share_plus dengan creature card sebagai gambar

---

### SPRINT 1.G — HOME SCREEN & ONBOARDING

**Estimasi:** 4–5 hari

---

#### TASK 1.G.1 — HomeScreen

⏱ 5–6 jam

📁 `lib/presentation/screens/home/home_screen.dart`:

**Sections:**

1. AppBar: avatar + nama hunter + notif ikon
2. Hunter Card (XP bar, streak, total kreatur)
3. Daily Mission preview (2 card horizontal)
4. Koleksi Terbaru (horizontal scroll, 4 card)
5. Bestiary progress bar

**Streak logic (di PlayerRepository):**

```dart
// Saat app dibuka: cek lastLogin
// Jika lastLogin.date == yesterday → streak++
// Jika lastLogin.date < yesterday → streak = 0 (reset)
// Jika lastLogin.date == today → tidak berubah
// Update lastLogin = now
```

✅ XP bar beranimasi saat XP bertambah
✅ Streak bertambah tepat saat buka app keesokan harinya

---

#### TASK 1.G.2 — OnboardingScreen & FTUE

⏱ 3–4 jam

📁 `lib/presentation/screens/onboarding/onboarding_screen.dart`:

**Flow:**

1. Splash (1.5s) → cek apakah first time
2. Jika first time: 3 onboarding slide (PageView)
   - Slide 1: "Dunia nyata, monster fantasi"
   - Slide 2: "Foto hewan → jadi kreatur"
   - Slide 3: "Koleksi, battle, jadi Hunter terkuat!"
3. Input nama hunter
4. Tutorial capture: auto-buka kamera, prompt foto hewan, dijamin dapat Rare
5. Reveal animasi → masuk HomeScreen

**First time detection:**

```dart
// Simpan flag di Hive: 'isFirstTime' → bool
// Jika false: langsung ke HomeScreen
```

✅ Onboarding hanya tampil sekali (flag Hive)
✅ Tutorial capture dijamin Rare (seed khusus "tutorial_seed")
✅ Animasi slide smooth dengan smooth_page_indicator

---

## PHASE 2 — ENGAGEMENT

**Goal:** User punya alasan kembali setiap hari.
**Estimasi Total:** 4–6 minggu

---

### TASK 2.1 — Daily Mission System

⏱ 5–7 hari

📁 `lib/game/mission_generator.dart`:

```dart
// Generate 3 misi harian dengan seed = tanggal hari ini
// 6 tipe misi sesuai GDD 7.3
// State per misi: progress + completed flag
// Reset tiap tengah malam
```

📁 `lib/presentation/screens/home/mission_card.dart`:

- Progress bar per misi
- Animasi "centang" saat selesai
- XP + Gold reward tampil saat claim

✅ Misi sama untuk semua user dalam satu hari (seed tanggal)
✅ Progress tersimpan (tidak reset saat app ditutup)
✅ Reward diklaim hanya sekali per misi

---

### TASK 2.2 — Achievement System

⏱ 3–4 hari

📁 `lib/core/constants/achievement_constants.dart`:

```dart
// 15 achievement sesuai GDD 7.4
// Setiap achievement: id, nama, deskripsi, tier, criteria
```

📁 `lib/game/achievement_checker.dart`:

```dart
// Dipanggil setiap kali ada event penting (capture, battle, login)
// Cek semua achievement yang belum unlock
// Return list achievement baru yang unlock
```

📁 `lib/presentation/widgets/achievement_toast.dart`:

- Toast khusus achievement: ikon + nama + tier badge
- Muncul dari atas, 3 detik, lalu slide kembali ke atas

✅ Achievement "First Blood" unlock setelah capture pertama
✅ Toast tidak tumpang-tindih jika 2 achievement unlock sekaligus (queue)

---

### TASK 2.3 — BestiaryScreen

⏱ 3–4 hari

📁 `lib/presentation/screens/bestiary/bestiary_screen.dart`:

- Grid spesies dengan filter kategori (Mamalia, Burung, Reptil, dll)
- Spesies belum ditemukan: silhouette hitam + tanda tanya
- Spesies ditemukan: foto representative + nama + jumlah capture
- Progress bar atas: "18 / 50 spesies ditemukan"

✅ Spesies yang belum ditemukan tidak reveal nama (hanya "???")
✅ Tap spesies yang sudah ditemukan → lihat semua creature dari spesies itu

---

### TASK 2.4 — Share Card Generator

⏱ 2–3 hari

📁 `lib/presentation/screens/collection/share_card.dart`:

```dart
// Widget 1080×1080 yang di-screenshot
// Layout:
// - Background: gradient warna elemen
// - Foto creature (centered, besar)
// - Nama + rarity badge
// - Stats singkat (HP/ATK)
// - "Captured by [nama]" + hashtag #Morphanimalollector
// - Logo app kecil di corner

// Proses:
// 1. Render widget di off-screen (ScreenshotController)
// 2. Capture sebagai Uint8List
// 3. Save ke temp file
// 4. Buka share_plus dengan file tersebut
```

✅ Share card resolusi 1080×1080
✅ Teks tidak terpotong di berbagai nama creature

---

### TASK 2.5 — Export / Import JSON Backup

⏱ 2–3 hari

📁 `lib/data/repositories/backup_repository.dart`:

- Export: serialize semua Creature + Player ke JSON → simpan ke Downloads
- Import: baca JSON → validasi schema → merge atau overwrite
- UI: di ProfileScreen, dua tombol "Ekspor Koleksi" dan "Impor Koleksi"

✅ File backup bisa dibuka di text editor dan valid JSON
✅ Import mendeteksi file rusak/tidak valid dan tampilkan error yang jelas

---

### TASK 2.6 — Unknown Beast Polish

⏱ 1–2 hari

- Pastikan Unknown Beast di-generate dengan rarity boost +10%
- Tambahkan nama khusus dari pool "Phantom/Void/Ancient/Enigma"
- Tambahkan deskripsi flavor: "Makhluk yang tidak dikenal oleh sains..."
- Di Bestiary: Unknown Beast punya slot khusus "Misterius"

✅ Unknown Beast bisa dikumpulkan dan tampil di koleksi normal
✅ User mendapat feedback positif (bukan hanya error) saat dapat Unknown Beast

---

### TASK 2.7 — UI Polish & Animasi Phase 2

⏱ 4–5 hari

- Tambahkan Lottie animation untuk:
  - AI scanning (radar effect di CaptureScreen)
  - Level up (burst effect di HomeScreen)
- Tambahkan shimmer loading di CollectionScreen saat data loading
- Tambahkan page transition custom (slide dari kanan untuk detail screen)
- Polish HomeScreen: section header konsisten, spacing rata
- Audit semua screen: pastikan tidak ada default Material widget tanpa styling

✅ Tidak ada default grey Card tanpa styling
✅ Loading state semua screen menggunakan shimmer bukan spinner kosong

---

## PHASE 3 — BATTLE SYSTEM

**Goal:** Depth gameplay meningkat, user punya tujuan melatih Morphanimal.
**Estimasi Total:** 6–8 minggu

---

### TASK 3.1 — Battle Engine (Core Logic)

⏱ 7–10 hari

📁 `lib/game/battle_engine.dart`:

```dart
class BattleEngine {
  // Turn order: SPD lebih tinggi attack duluan
  // Damage formula sesuai GDD 6.3
  // Status effect: burn (-5% HP/turn), paralyze (25% skip turn), confuse (30% hit self)
  // Element advantage matrix sesuai GDD 5.4
  // Battle selesai: salah satu HP ≤ 0
}

class BattleState {
  final Creature playerCreature;
  final Creature opponentCreature;
  final int playerCurrentHp;
  final int opponentCurrentHp;
  final List<BattleLog> logs;  // untuk battle replay
  final BattlePhase phase;     // selecting, animating, ended
}
```

✅ Unit test: type advantage (Fire vs Nature) → damage × 1.5
✅ Unit test: burn → HP berkurang tiap akhir turn
✅ Unit test: Morphanimal HP 0 → phase = ended

---

### TASK 3.2 — CPU Opponent Generator

⏱ 3–4 hari

📁 `lib/game/battle_engine.dart` — `CpuOpponent`:

```dart
class CpuOpponent {
  // Generate creature lawan berdasarkan player level
  // Level lawan = player level ± 2
  // Rarity: Common–Rare untuk level rendah, Epic untuk level tinggi
  // AI sederhana: pilih skill dengan power tertinggi yang tidak miss
}
```

✅ Lawan tidak terlalu mudah (tidak selalu kalah) maupun terlalu susah
✅ CPU menggunakan skill dengan type advantage jika tersedia

---

### TASK 3.3 — BattleScreen UI

⏱ 7–10 hari

📁 `lib/presentation/screens/battle/battle_screen.dart`:

**Layout:**

```
[HP bar lawan]  [Foto creature lawan]
                                      (area battle)
[Foto creature player]  [HP bar player]

[LOG BATTLE]
"Umbren Claw menggunakan Shadow Claw!"
"Damage: 87 | Efektif!"

[PILIH SKILL]
[Shadow Claw] [Night Slash] [Void Pulse] [Dark Shroud]
```

**Animasi:**

- Creature shake saat terkena serangan
- Damage number melayang dan fade out
- HP bar berkurang dengan animasi (bukan langsung loncat)
- Flash merah di HP bar saat HP rendah

✅ Turn berjalan dengan urutan yang benar (SPD)
✅ Skill yang PP habis ditampilkan disable (abu-abu)
✅ Hasil battle (menang/kalah) tampil dengan reward jelas

---

### TASK 3.4 — Creature Leveling & XP

⏱ 3–4 hari

📁 `lib/game/progression_calculator.dart`:

```dart
class ProgressionCalculator {
  // XP dari battle: 10–50 XP tergantung rarity lawan
  // XP dari capture: 50/100/200/500 sesuai rarity
  // Level up formula: xpRequired(level) = level * level * 50

  static int xpToNextLevel(int currentLevel) {
    return currentLevel * currentLevel * 50;
  }

  static int calculateFinalStat(int baseStat, int iv, int level) {
    return ((baseStat * 2 + iv) * level / 100 + 5).floor();
  }
}
```

✅ Stat creature benar-benar meningkat saat level naik
✅ Level cap 50 — tidak bisa XP di atas itu

---

### TASK 3.5 — Battle Team Builder

⏱ 2–3 hari

📁 `lib/presentation/screens/battle/team_builder_screen.dart`:

- Tampilkan semua Morphanimal di koleksi
- Pilih max 3 untuk tim
- Tampilkan "power rating" tim (total BST ÷ 3)
- Simpan team ke PlayerModel

✅ Hanya bisa pilih 3 creature max
✅ Creature yang sudah di-team ditandai dengan badge "Tim"

---

### TASK 3.6 — Item System (Basic)

⏱ 2–3 hari

Item yang ada di Phase 3:

- **Capture Boost** (+5% rarity roll, berlaku 1 capture)
- **Moonstone** (syarat evolusi Epic)
- **Rare Candy** (+100 XP untuk satu Morphanimal)

📁 `lib/domain/entities/item.dart`
📁 `lib/data/models/item_model.dart`

Inventory: di PlayerModel, Map `{itemId: count}`

✅ Item berkurang saat digunakan
✅ Item tidak bisa digunakan saat stok 0

---

## PHASE 4 — SOCIAL & ONLINE

**Goal:** Retensi komunitas, online features, monetisasi opsional.
**Estimasi Total:** 4–6 minggu

---

### TASK 4.1 — Supabase Setup

⏱ 2–3 hari

- Buat project Supabase (gratis)
- Buat tabel: `player_profiles`, `leaderboard` (sesuai GDD 12.4)
- Setup Row Level Security (RLS) — user hanya bisa edit data sendiri
- Implement `SupabaseDataSource` (yang sudah distub sejak Phase 0)
- Guest mode: data lokal tanpa akun, bisa "claim" nanti

✅ Data player bisa disync ke Supabase setelah login
✅ Data lokal tetap ada meski tidak login

---

### TASK 4.2 — Auth (Supabase Anonymous + Email)

⏱ 3–4 hari

📁 `lib/presentation/screens/profile/auth_screen.dart`:

- Login dengan email + OTP (bukan password — lebih simple)
- Anonymous login otomatis saat pertama buka app
- Upgrade dari anonim ke akun email → data tersimpan

✅ User tidak perlu login untuk bermain
✅ Upgrade akun tidak kehilangan data

---

### TASK 4.3 — Leaderboard

⏱ 2–3 hari

- Weekly leaderboard berdasarkan total BST semua creature
- Tampil di ProfileScreen → tab "Peringkat"
- Update otomatis setiap capture/battle

✅ Leaderboard menampilkan top 50 hunter
✅ Posisi user sendiri selalu terlihat (sticky)

---

### TASK 4.4 — Local Notifications

⏱ 1–2 hari

```yaml
# Tambah package:
flutter_local_notifications: ^17.0.0
```

Notifikasi yang dijadwalkan:

- Daily reminder jam 09:00: "Misi harianmu sudah siap!"
- Streak reminder jam 21:00 jika belum login: "Jangan putus streak-mu!"

✅ Notifikasi muncul meski app ditutup
✅ Tap notifikasi membuka app ke halaman yang relevan

---

### TASK 4.5 — AdMob Integration (Opsional)

⏱ 2–3 hari

```yaml
# Tambah package:
google_mobile_ads: ^5.0.0
```

Placement:

- Rewarded video: "Tonton iklan → Capture Boost"
- Banner: di halaman koleksi (bawah screen)

⚠️ Hanya tambahkan jika memutuskan untuk monetisasi
✅ Iklan tidak muncul di halaman gameplay aktif (capture, battle, reveal)

---

## CHECKLIST SEBELUM RELEASE

### Technical

- [ ] `flutter build apk --release` berhasil tanpa error
- [ ] APK size < 80MB (termasuk model TFLite)
- [ ] Test di minimal 2 device berbeda (low-end + mid-range)
- [ ] Tidak ada crash selama 30 menit sesi penggunaan normal
- [ ] Tidak ada memory leak (cek dengan DevTools)
- [ ] Semua gambar terkompresi (tidak ada file > 1MB di assets)

### Fungsional

- [ ] Onboarding berjalan penuh tanpa skip crash
- [ ] Capture → Reveal → Koleksi: loop berjalan tanpa error
- [ ] CollectionScreen filter & sort berfungsi
- [ ] Morphanimal detail: rename, share, set ke tim berfungsi
- [ ] Backup export/import berfungsi
- [ ] Streak reset dengan benar

### UI/UX

- [ ] Semua elemen menggunakan warna dari AppColors (bukan hardcode)
- [ ] Font Nunito tampil di semua teks
- [ ] Tidak ada overflow/RenderFlex error di layar 5" maupun 6.5"
- [ ] Dark mode (jika diimplementasi) tidak ada teks invisible
- [ ] Semua tap target minimal 44×44dp

### Play Store

- [ ] Privacy policy URL tersedia
- [ ] App icon 512×512px tersedia
- [ ] Screenshot 3–5 buah untuk Play Store listing
- [ ] `versionCode` dan `versionName` benar di `pubspec.yaml`
- [ ] Signing keystore sudah dibuat dan disimpan aman

---

## RINGKASAN ESTIMASI

| Phase     | Fokus               | Estimasi          |
| --------- | ------------------- | ----------------- |
| Phase 0   | Setup & Fondasi     | 3–5 hari          |
| Phase 1   | Core Gameplay (MVP) | 6–8 minggu        |
| Phase 2   | Engagement          | 4–6 minggu        |
| Phase 3   | Battle System       | 6–8 minggu        |
| Phase 4   | Social & Online     | 4–6 minggu        |
| **Total** |                     | **~20–28 minggu** |

**Rekomendasi urutan jika waktu terbatas:**

1. Phase 0 + Phase 1 wajib (minimal viable)
2. Phase 2 Task 2.1–2.3 (daily mission + achievement + bestiary)
3. Phase 3 bisa dilewati jika fokus ke showcase/portofolio
4. Phase 4 hanya jika ingin rilis ke Play Store sungguhan

---

_PLAN.md v1.0.0 | Morphanimal | Referensi: GDD v2.0 + DESIGN.md v1.0_
