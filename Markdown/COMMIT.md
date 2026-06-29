# COMMIT_CONVENTION.md — Morphanimal
## Panduan Pesan Commit Git v1.0.0

**Referensi:** Conventional Commits v1.0.0 + Angular Commit Guidelines
**Project:** Flutter Android App — Morphanimal

---

## FORMAT DASAR

```
<type>(<scope>): <deskripsi singkat>

[body opsional]

[footer opsional]
```

**Aturan umum:**
- Baris pertama maksimal **72 karakter**
- Deskripsi pakai **huruf kecil**, tanpa titik di akhir
- Gunakan **bahasa Inggris** (standar profesional) atau Bahasa Indonesia konsisten — pilih satu
- Body: jelaskan *apa* dan *kenapa*, bukan *bagaimana*
- Footer: referensi issue/task jika ada

---

## TIPE COMMIT

### `feat` — Fitur Baru
Menambahkan fungsionalitas baru yang sebelumnya tidak ada.

```bash
feat(capture): implement animal detection with tflite model
feat(battle): add turn-based damage calculation engine
feat(collection): add filter by element and rarity
feat(morphanimal): implement SHA256-based deterministic stat generator
feat(auth): add anonymous login via supabase
feat(mission): add daily mission generator logic
feat(notification): schedule daily reminder at 09:00
feat(bestiary): add unknown beast slot with mystery flavor
```

---

### `fix` — Perbaikan Bug
Memperbaiki perilaku yang salah atau tidak sesuai ekspektasi.

```bash
fix(capture): resolve blur detection false positive on dark images
fix(battle): fix turn order when two creatures have equal SPD
fix(morphanimal): correct rarity weight calculation for golden hour
fix(hive): fix TypeAdapter not registered before box open
fix(collection): fix sort by BST showing wrong order
fix(ui): fix RenderFlex overflow on 5-inch screen in BattleScreen
fix(streak): fix streak not resetting after midnight correctly
```

---

### `chore` — Konfigurasi & Pemeliharaan
Perubahan yang tidak mempengaruhi logic app (dependency, config, build).

```bash
chore: add flutter_animate and lottie to pubspec.yaml
chore: run flutter pub get after adding new dependencies
chore: update compileSdkVersion to 34 in build.gradle
chore: configure NDK version for tflite_flutter compatibility
chore: add fvm config file to lock flutter stable version
chore: add .gitignore rules for hive .hive files and build/
chore: set up build_runner for hive and riverpod code gen
```

---

### `refactor` — Refaktor Kode
Mengubah struktur kode tanpa mengubah perilaku/output.

```bash
refactor(morphanimal): extract stat calculation to ProgressionCalculator
refactor(battle): separate CpuOpponent logic from BattleEngine
refactor(theme): move hardcoded colors to AppColors constants
refactor(providers): reorganize riverpod providers into separate files
refactor(capture): split CaptureScreen into smaller widgets
refactor(core): move seed logic from CreatureGenerator to seed_generator.dart
```

---

### `style` — Perubahan Visual/Format
Formatting, spacing, lint fix — tidak ada perubahan logika.

```bash
style: fix trailing commas and dart format across lib/
style(theme): align spacing constants with DESIGN.md spec
style(ui): replace hardcoded padding with AppSpacing constants
style: run dart fix --apply to resolve lint warnings
```

---

### `test` — Menambah atau Memperbaiki Test
```bash
test(battle): add unit test for fire vs nature type advantage
test(battle): add test for burn status reducing HP per turn
test(morphanimal): add test for rarity boost on unknown beast
test(progression): add test for xpToNextLevel formula accuracy
test(seed): add test for SHA256 deterministic stat output
```

---

### `docs` — Dokumentasi
Perubahan pada file .md, komentar kode, atau dokumentasi lainnya.

```bash
docs: update PLAN.md task 0.3 status to done
docs: add inline comments to BattleEngine damage formula
docs: add README with setup instructions and flutter doctor
docs: add dartdoc to CreatureGenerator public methods
```

---

### `perf` — Peningkatan Performa
Perubahan yang meningkatkan kecepatan atau efisiensi memori.

```bash
perf(image): compress captured image to max 800px before processing
perf(collection): add pagination to CollectionScreen list (50 per page)
perf(hive): lazy-load creature boxes instead of opening all at startup
perf(tflite): cache interpreter instance instead of re-creating per capture
```

---

### `build` — Perubahan Build System
Perubahan pada konfigurasi build Android, Gradle, atau CI/CD.

```bash
build: configure proguard rules for tflite_flutter release build
build: set minSdkVersion to 24 in build.gradle
build: add signing config for release APK
build: configure flutter build apk --split-per-abi
```

---

### `revert` — Membatalkan Commit Sebelumnya
```bash
revert: feat(battle): add turn-based damage calculation engine

Reverts commit abc1234.
Reason: caused crash on creature with 0 SPD stat.
```

---

### `wip` — Work In Progress *(gunakan hanya di branch sendiri)*
Jangan di-push ke `main`. Gunakan saat menyimpan progress sementara.

```bash
wip(battle): halfway through BattleScreen UI layout
wip(ai): tflite model loading, inference not connected yet
```

---

## SCOPE — REFERENSI PER PHASE

Scope sesuai modul di Morphanimal:

| Scope | Keterangan |
|---|---|
| `setup` | Task Phase 0: environment, folder, pubspec |
| `theme` | AppColors, AppTextStyles, AppSpacing, AppTheme |
| `core` | Utilities, constants, error handling |
| `hive` | Local database, TypeAdapter, box management |
| `morphanimal` | MorphanimalGenerator, entity, model (hewan in-game) |
| `capture` | CaptureScreen, camera, blur detection |
| `ai` | TFLite model, AnimalDetector, SpeciesClassifier |
| `reveal` | RevealScreen, animasi kemunculan creature |
| `collection` | CollectionScreen, filter, sort |
| `detail` | CreatureDetailScreen, rename, share |
| `battle` | BattleEngine, BattleScreen, CpuOpponent |
| `team` | TeamBuilderScreen |
| `progression` | XP, level, stat growth |
| `item` | Item system, inventory |
| `mission` | Daily/weekly mission generator |
| `achievement` | Achievement system |
| `bestiary` | BestiaryScreen, entry unlock |
| `streak` | Streak logic, golden hour |
| `profile` | ProfileScreen |
| `auth` | Supabase anonymous + email login |
| `leaderboard` | Weekly leaderboard |
| `notification` | Local notification scheduling |
| `router` | GoRouter setup, navigation |
| `provider` | Riverpod providers |
| `ui` | Widget umum, layout, animasi |
| `admob` | AdMob integration (Phase 4 opsional) |

---

## CONTOH COMMIT LENGKAP (DENGAN BODY)

```bash
feat(morphanimal): implement SHA256-based deterministic stat generator

Stats (HP, ATK, DEF, SPD, SP.ATK, SP.DEF) now generated from a
SHA256 hash of the species ID + capture timestamp. This ensures
each creature is unique but reproducible for debugging.

Refs: PLAN.md TASK 1.3
```

```bash
fix(battle): prevent infinite loop when both creatures reach 0 HP simultaneously

Added a check in BattleEngine._resolveTurn() to handle the edge
case where both creatures die from burn damage on the same tick.
Winner is determined by which creature had higher HP before the tick.

Fixes: #12
```

---

## ALUR BRANCH & COMMIT YANG DISARANKAN

```
main            ← production-ready, hanya merge dari develop
develop         ← integration branch
feature/task-X  ← branch per task dari PLAN.md
fix/nama-bug    ← branch untuk hotfix
```

**Contoh alur:**
```bash
# Mulai task baru
git checkout -b feature/task-1.3-morphanimal-generator

# Selama ngerjain — commit kecil-kecil
git commit -m "wip(morphanimal): scaffold MorphanimalGenerator class"
git commit -m "feat(morphanimal): implement rarity weight randomizer"
git commit -m "feat(morphanimal): add SHA256 seed for stat generation"
git commit -m "test(morphanimal): add unit test for stat range boundaries"

# Selesai → squash atau langsung merge ke develop
git checkout develop
git merge feature/task-1.3-morphanimal-generator
```

---

## CHEATSHEET CEPAT

```
feat     → fitur baru
fix      → bug diperbaiki
chore    → dependency / config / build setup
refactor → restrukturisasi kode (no behavior change)
style    → formatting / lint (no logic change)
test     → tambah atau perbaiki test
docs     → dokumentasi / komentar
perf     → optimisasi performa
build    → konfigurasi build / gradle / CI
revert   → batalkan commit sebelumnya
wip      → simpan progress sementara (branch lokal saja)
```

---

## YANG HARUS DIHINDARI ❌

```bash
# Terlalu umum
git commit -m "fix bug"
git commit -m "update"
git commit -m "wip"
git commit -m "asdfgh"

# Terlalu panjang di baris pertama (> 72 karakter)
git commit -m "feat(battle): implement full turn-based battle system with status effects and element advantage matrix"

# Campur banyak perubahan tidak berkaitan dalam satu commit
git commit -m "feat: add collection screen + fix streak bug + update pubspec"
```

---

*COMMIT_CONVENTION.md v1.0.0 | Morphanimal | Referensi: Conventional Commits v1.0.0*
