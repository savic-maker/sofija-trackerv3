Beba Tracker (Flutter) - SR

Funkcije:
- Profili (vise beba)
- Unos: hranjenje, mokra pelena, stolica (+ boja)
- Automatsko brojanje po danu
- Podsetnik za hranjenje: 3h nakon poslednjeg unosa hranjenja
- Nedeljni grafikoni (po danima: hranjenja, mokre pelene, stolice)

POKRETANJE:
1) Instaliraj Flutter
2) U folderu projekta:
   flutter pub get
   flutter packages pub run build_runner build --delete-conflicting-outputs
3) flutter run

BUILD APK:
flutter build apk --release
APK: build/app/outputs/flutter-apk/app-release.apk

---

BUILD APK BEZ LOKALNE INSTALACIJE (GitHub Actions)
1) Napravi novi private repo na GitHub-u
2) Uploaduj ceo sadržaj ovog projekta
3) Idi na: Actions → "Build Android APK" → Run workflow
4) Kad se završi, uđeš u run i preuzmeš Artifact: **app-release-apk**
   (unutra je: app-release.apk)
5) Prebaci APK na telefon i instaliraj.

Napomena: Na telefonu može biti potrebno da dozvoliš instalaciju iz "Unknown sources".
