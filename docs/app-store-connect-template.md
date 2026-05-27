# App Store Connect Fill Template

This document is the default source of truth for preparing this project's App Store Connect listing.

Future agents should use this file together with `docs/app-store-metadata.md` and `docs/app-store.md` when the user asks for App Store listing content. Do not browse Apple documentation for routine listing preparation unless one of these is true:

- The user explicitly asks to check the latest Apple rules.
- App Store Connect rejects a field or shows a new required question.
- The app scope changes in a way that affects review, privacy, or compliance, such as accounts, sync, analytics, ads, in-app purchases, subscriptions, user-generated public content, health data, location permissions, push notifications, or custom encryption.
- New screenshot sizes, device classes, or platform targets are requested.

## App Record

- Platform: iOS
- Name: Trip Journal
- Simplified Chinese name: 途记
- Bundle ID: `com.zhouyajie.tripjournal`
- SKU: `tripjournal_ios_001`
- Version: `1.0.0`
- Primary language: English
- Category: Travel
- Secondary category: Lifestyle
- Copyright: `2026 Zhou Yajie`
- Support email: `jay212315@gmail.com`
- License agreement: Apple's standard EULA

## English Listing

- Name: `Trip Journal`
- Subtitle: `Offline travel notes and packing`
- Promotional text: `Plan what to bring, record where you went, and keep the moments that made each trip yours.`
- Description:

```text
Trip Journal is a private offline notebook for your travels. Create a trip, prepare a packing list, record transportation, save places you visited, and write down what you saw and felt along the way.

Version 1.0.0 is designed to stay simple and local. No account is required, and your travel records are stored on your iPhone.
```

- Keywords: `travel,journal,trip,packing,notes,itinerary,places,offline`
- Support URL: `https://davidzyj.github.io/trip-journal-app/support.html`
- Privacy Policy URL: `https://davidzyj.github.io/trip-journal-app/privacy.html`
- Marketing URL: `https://davidzyj.github.io/trip-journal-app/`

## Simplified Chinese Listing

- 名称：`途记`
- 副标题：`离线旅行手账与清单`
- 推广文本：`记录出发前的准备、一路经过的地方，以及真正属于你的旅途感受。`
- 描述：

```text
途记是一款私密的离线旅行手账。你可以新建一次旅行，准备物品清单，记录乘坐的交通工具，保存去过的地点，并写下旅途中的所见所感。

1.0.0 版本保持简单、本地、安静。不需要账号，你的旅行记录保存在自己的 iPhone 上。
```

- 关键词：`旅行,手账,游记,清单,行程,地点,离线,记录`
- 支持网址：`https://davidzyj.github.io/trip-journal-app/zh/support.html`
- 隐私政策网址：`https://davidzyj.github.io/trip-journal-app/zh/privacy.html`
- 营销网址：`https://davidzyj.github.io/trip-journal-app/zh/`

## App Privacy

Use the current project behavior as the basis:

- Data collection: No data collected
- Tracking: No
- Third-party analytics: No
- Third-party advertising: No
- Account required: No
- Network behavior: no app runtime network requests; only user-initiated external links for support and privacy pages

Suggested review note:

```text
Trip Journal is an offline travel journal app. It does not require an account, does not collect user data, and does not make network requests except when the user manually opens the support or privacy policy links.
```

## Export Compliance

Use the Apple Developer account's current questionnaire. Based on the current project, the app does not implement custom encryption and does not provide network communication features beyond user-opened web links.

If the questionnaire asks about encryption, answer according to the wording shown in App Store Connect and the actual uploaded build. Browse Apple documentation only if the form wording is unclear or has changed.

## Age Rating

Suggested answers for version 1.0.0:

- Violence: None
- Mature or suggestive themes: None
- Medical or treatment information: None
- Alcohol, tobacco, or drug references: None
- Gambling: None
- Contests: No
- Unrestricted web access: No
- User-generated public content: No

Expected result: low age rating, likely 4+.

## Pricing And Availability

- Price: Free
- In-app purchases: No
- Subscriptions: No
- Availability: All countries or regions unless the owner chooses otherwise
- Release: manual release after approval

## Screenshots

Use the existing 6.5-inch local screenshot set:

- English home: `screenshots/6.5/en/01-home.png`
- English detail: `screenshots/6.5/en/02-detail.png`
- Simplified Chinese home: `screenshots/6.5/zh-Hans/01-home.png`
- Simplified Chinese detail: `screenshots/6.5/zh-Hans/02-detail.png`

Do not inspect large screenshot images unless visual QA is specifically requested. The dimensions are recorded in `screenshots/6.5/dimensions.txt`.

## Still Needed From Owner

- App Review contact phone number.
- Apple Developer Team selection in Xcode/App Store Connect.
- Final decision on whether to release manually or automatically after approval.
