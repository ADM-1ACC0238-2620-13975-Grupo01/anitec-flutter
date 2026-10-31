# AniTec Flutter

Rancher dashboard of AniTec (course 1ACC0238, UPC), built with Flutter. It mirrors the **Home** screen of the
native Android app (`anitec-android`): greeting, farm selector, counters, upcoming activities and recent health
records. Only the `Rancher` role can use it; a `Veterinarian` account gets a message at sign-in and no session
is kept.

Android only (`applicationId` `com.anitec.platform.flutter`). English is the default language; Spanish (es-419)
can be switched in the app and is remembered.

## Run

```bash
flutter pub get
flutter run                      # debug: http://10.0.2.2:5191/api/v1/ (host machine, from the Android emulator)
flutter run --release            # release: https://anitec-backend-android.onrender.com/api/v1/
flutter run --dart-define=API_BASE_URL=http://192.168.1.10:5191/api/v1/   # physical device or other server
```

The first request to Render can take about a minute (free tier cold start); timeouts are 60 s.
Debug builds allow cleartext HTTP (`android/app/src/debug/AndroidManifest.xml`); release builds are HTTPS only.

## Release APK

Copy `android/key.properties.example` to `android/key.properties` (git ignores it) and fill in the keystore data; it has the same format as `keystore.properties` of the native app, so the same file and the same keystore can be used. Without it the APK is signed with the debug key and Gradle prints a warning.

```bash
flutter build apk --release      # build/app/outputs/flutter-apk/app-release.apk
```

Raise the number after `+` in `version:` of `pubspec.yaml` before every new upload. The APK is distributed through Firebase App Distribution with the app `com.anitec.platform.flutter`; the steps (project, upload, testers, invite link) are in the README of `anitec-android`, section *Release build and distribution*.

Public invite links of the group `Equipo AniTec` (shared with the native app; Firebase lists the same links from both apps):

- <https://appdistribution.firebase.dev/i/417dc4e6d8ae3e32>
- <https://appdistribution.firebase.dev/i/862507cca1d4abc6>

## Checks

```bash
dart format --set-exit-if-changed lib test
flutter analyze
flutter test
```

After editing `lib/l10n/*.arb`, run `flutter gen-l10n` (the generated files are committed).

## Structure

Folders per bounded context, with state (Riverpod notifiers) separate from the UI:

| Folder | Content |
| --- | --- |
| `lib/core` | design tokens and components, Dio client (Bearer + 401 handling), session, language, errors |
| `lib/iam` | sign-in (`authentication/sign-in`), terms of service |
| `lib/livestock` | herds and animals, client-side visibility rules |
| `lib/sanitary` | health events |
| `lib/activities` | farm activities (`farm-events`) |
| `lib/app` | router (go_router) and the Home dashboard |

The API returns records for every user, so the client filters by `ownerId` as the Android app does
(`livestock/domain/Policies.kt`). The JWT lasts 7 days and cannot be refreshed: a 401 on an authenticated
request signs the user out and returns to sign-in.

Out of scope for now: local SQLite cache and offline writes (the banner only reports that the last refresh failed
for lack of connection), and every screen other than sign-in, terms and Home.
