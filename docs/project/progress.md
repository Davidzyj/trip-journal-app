# Trip Journal Progress

## 2026-05-26

- Created the project from an empty directory.
- Product direction selected: an offline iPhone travel journal for packing preparation, transportation records, visited places, and personal notes.
- App names:
  - English: Trip Journal
  - Simplified Chinese: 途记
- Bundle ID: `com.zhouyajie.tripjournal`.
- Version: `1.0.0`.
- Support email: `jay212315@gmail.com`.
- Technical stack: SwiftUI, SwiftData, iPhone only, iOS 17+.
- Localization decision:
  - In-app UI forces Simplified Chinese when the device region is China (`CN`), otherwise English.
  - `CFBundleDisplayName` is localized through `InfoPlist.strings` as required by iOS. iOS chooses this by system language, which is Apple's supported mechanism for the home screen display name.
- App runtime has no network requests. The settings screen only opens user-initiated external links for privacy policy and support pages.
- Implemented the initial SwiftUI app:
  - Trip list and empty state.
  - Trip creation form.
  - Trip detail screen.
  - Packing item records.
  - Transportation records.
  - Visited place records.
  - Journal entries with mood.
  - Settings screen with privacy and support links.
- Added English and Simplified Chinese localizations for app UI and `CFBundleDisplayName`.
- Added GitHub Pages-ready privacy and support pages in English and Simplified Chinese.
- Generated the app icon asset set. The 1024 marketing icon is RGB PNG, 1024 x 1024, with no alpha channel.
- Verified simulator build:
  - Command: `xcodebuild -project TripJournal.xcodeproj -scheme TripJournal -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.2' build`
  - Result: `BUILD SUCCEEDED`.
- Initialized git and created the first commit:
  - Commit: `b6fc192 Initial Trip Journal app`.
- Created GitHub repository:
  - `https://github.com/Davidzyj/trip-journal-app`.
- Enabled GitHub Pages from `main` branch `/docs` folder:
  - `https://davidzyj.github.io/trip-journal-app/`.
  - Status at enable time: `building`.

## MVP Scope

- Create, view, and delete trips.
- Record trip title, destination, start/end dates, and opening note.
- Track packing items and packed state.
- Record transportation type, route, date, and notes.
- Record visited places and impressions.
- Record journal entries and mood.
- Provide localized privacy policy and support links.

## Pending

- Prepare App Store metadata.

## 2026-05-27

- GitHub Pages finished building successfully.
  - Public site: `https://davidzyj.github.io/trip-journal-app/`
  - Privacy policy: `https://davidzyj.github.io/trip-journal-app/privacy.html`
  - Support page: `https://davidzyj.github.io/trip-journal-app/support.html`
  - Chinese privacy policy: `https://davidzyj.github.io/trip-journal-app/zh/privacy.html`
  - Chinese support page: `https://davidzyj.github.io/trip-journal-app/zh/support.html`
- Captured App Store screenshots for 6.5-inch iPhone only.
  - English set: `screenshots/6.5/en/01-home.png`, `screenshots/6.5/en/02-detail.png`
  - Simplified Chinese set: `screenshots/6.5/zh-Hans/01-home.png`, `screenshots/6.5/zh-Hans/02-detail.png`
- Added a deterministic screenshot script with automatic white-screen detection and retry logic.
- Confirmed the final screenshot previews render correctly in both languages.
- Added a reusable App Store Connect fill template and documented the no-browse default workflow for routine App Store metadata preparation.

## Notes for Future Agents

- Do not add analytics, remote sync, accounts, or third-party SDKs before re-checking the privacy policy and App Store privacy declaration.
- For routine App Store listing content, use `docs/app-store-connect-template.md` and do not browse Apple documentation unless the user asks for latest-rule verification or App Store Connect rejects a field.
- If App Store Connect requires a development team, set `DEVELOPMENT_TEAM` in the target build settings without changing the bundle identifier.
- The in-app China-region language behavior is implemented in `TripJournal/AppLocale.swift`.
- Home screen app name localization depends on iOS language selection through `InfoPlist.strings`, which is Apple's supported behavior.
