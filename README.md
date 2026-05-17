# Dhyan — Focus Recovery App

Flutter app (Android + iOS) to rebuild attention span after shorts/Reels habits.

## Run

```bash
cd d:\Project\Android\Second_app
flutter pub get
flutter run
```

## Features (MVP)

- Onboarding → Recovery / Builder / Master track
- Micro & Deep sessions with warm-up
- **Breath Anchor**, **Still Point** (touch or accelerometer), **One Path** maze
- **Urge Surf** (90s emergency drill)
- Attention Index, progress chart, Hindi/English UI
- Daily session limits (anti second-addiction)

## iOS

Requires Mac + Xcode: `flutter build ios`

## Structure

```
lib/
  core/       theme, router, l10n
  data/       models, Hive repository
  domain/     Attention Index, session policy
  features/   screens & games
  providers/  Riverpod state
```
