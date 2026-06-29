# Morphanimal

> Setiap hewan yang kamu temui di dunia nyata bisa menjadi pejuang fantasi milikmu — unik, tak tergantikan, dan hanya kamu yang punya.

**Morphanimal** adalah game Flutter Android offline-first yang mengubah foto hewan nyata menjadi creature fantasi menggunakan AI.

## Tech Stack

| Layer | Teknologi |
|---|---|
| Framework | Flutter 3.19+ |
| Language | Dart 3.3+ |
| AI Inference | TFLite Flutter |
| Local DB | Hive |
| State Management | Riverpod |
| Navigation | go_router |

## Cara Memulai

```bash
# Clone
git clone https://github.com/risuunava/morphanimal.git
cd morphanimal

# Install dependencies
flutter pub get

# Run
flutter run
```

## Struktur Project

```
lib/
├── core/        → constants, utils, theme, errors
├── data/        → models, repositories, datasources
├── domain/      → entities, usecases, repositories (interfaces)
├── presentation → screens, widgets, providers
├── ai/          → TFLite pipeline
└── game/        → creature generator, battle engine, progression
```

## Dokumentasi

Seluruh dokumentasi ada di folder [Markdown](./Markdown/):
- [PRD Game Design Document](./Markdown/MORPHANIMAL_PRD.md)
- [Design System & UI Spec](./Markdown/DESIGN.md)
- [Development Plan](./Markdown/PLAN.md)
- [Commit Convention](./Markdown/COMMIT.md)
