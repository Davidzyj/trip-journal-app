# Agent Handoff

## Current State

The repository contains a buildable SwiftUI iPhone app named Travel Memo App / 旅途记.

- Bundle ID: `com.zhouyajie.tripjournal`
- Version: `1.0.0`
- Minimum iOS: 17.0
- Storage: SwiftData, local-only
- Network: no app runtime network requests
- External links: privacy and support pages from settings
- GitHub Pages: live at `https://davidzyj.github.io/trip-journal-app/`

## Important Files

- `TripJournal.xcodeproj/project.pbxproj`: Xcode project.
- `TripJournal/TripJournalApp.swift`: app entry point and SwiftData container.
- `TripJournal/AppLocale.swift`: China-region language selection and URL routing.
- `TripJournal/Models/TripModels.swift`: SwiftData models.
- `TripJournal/Views/`: SwiftUI screens.
- `TripJournal/Resources/en.lproj/Localizable.strings`: English UI copy.
- `TripJournal/Resources/zh-Hans.lproj/Localizable.strings`: Simplified Chinese UI copy.
- `TripJournal/Resources/*/InfoPlist.strings`: localized display names.
- `docs/`: GitHub Pages site and project documentation.
- `docs/app-store-connect-template.md`: preferred no-browse template for App Store Connect fields.
- `tools/generate_app_icon.swift`: deterministic icon generator.

## Verification

Last successful command:

```bash
xcodebuild -project TripJournal.xcodeproj -scheme TripJournal -destination 'platform=iOS Simulator,name=iPhone 17,OS=26.2' build
```

## Remaining Work

1. Prepare final App Store metadata in App Store Connect.
2. Archive/upload through Xcode after Apple Developer Team ID is available.
3. Build the App Store listing once the Apple account details are ready.

## App Store Metadata Workflow

For routine App Store listing preparation, use `docs/app-store-connect-template.md`, `docs/app-store-metadata.md`, and `docs/app-store.md` as the source of truth. Do not browse Apple documentation by default. Only check official Apple documentation if the user explicitly asks for the latest rules, App Store Connect rejects a field, or the app scope changes in a way that affects privacy, review, screenshots, payments, accounts, or compliance.
