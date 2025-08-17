# ThmanyahTask — SwiftUI + MVVM + Async/Await

## Overview
An iOS app that renders a dynamic **Home** screen composed of multiple sections (podcasts, episodes, etc.) with **infinite scrolling**, plus a **Search** screen with **200 ms debounce**, result caching, and pagination. Tapping any item opens a **UIKit Details** screen via a SwiftUI ↔︎ UIKit bridge.

## Architecture
**MVVM + Repository**
- **Models:** `HomeResponse`, `HomeSection`, `ContentItem`, `Pagination`, `DetailPayload`
- **Repositories:** `HomeRepository`, `SearchRepository` (build URLs, handle absolute/relative `next_page`)
- **ViewModels:** `HomeViewModel`, `SearchViewModel` (initial load, prefetch/infinite scroll, caching, dedupe, min-query guard)
- **Views:** `HomeView`, `SearchView`, `SectionView`, `CardView`, `SquareTile`, `RemoteImage`
- **UIKit:** `DetailsViewController` + `DetailsVCWrapper` (SwiftUI `UIViewControllerRepresentable`)

## Networking
- **Home:** `GET https://api-v2-b2sit6oh3a-uc.a.run.app/home_sections`
- **Search:** `GET https://mock.apidog.com/m1/735111-711675-default/search?q=QUERY`
- Pagination: supports **absolute** and **relative** `next_page` by resolving relative URLs against a base.
- **Robust decoding:** models accept numbers as `Int` or stringified numbers; `SearchRepository` can decode:
  - `{ "sections": [...] }`
  - `{ "results": [...] }`, `{ "items": [...] }`, `{ "data": [...] }`
  - a plain array `[...]`
  - Falls back with a readable error snippet if the shape is unknown.

## UI / UX
- Section layouts: **two-column grid**, **square tiles**, **horizontal list** — chosen by `type` with sensible fallbacks by content kind.
- Search: **200 ms debounce**, ignores queries `< 2` chars, **in-memory cache** per query, infinity scroll.
- Details: UIKit VC pushed from SwiftUI, receives a lightweight `DetailPayload`.

## Typography
- **IBM Plex Sans Arabic** everywhere via:
  - `Font.ibmArabic(weight:size:)` and `View.appFont(...)`
  - `Theme.applyNavigationBarFont()` for navigation bar titles
- Ensure font files are added to **Target Membership** and listed in **Info.plist → UIAppFonts**.

## Dependencies (Swift Package Manager)
- **SDWebImage** (UIKit) and **SDWebImageSwiftUI** (SwiftUI) for image loading & caching
- (Optional) **SDWebImageWebPCoder** for WebP support  
SPM-only — no CocoaPods/Carthage.

## Unit Tests
XCTest **Unit Testing Bundle** covering:
- Flexible **model decoding**
- Repository URL building (first page + relative `next_page`)
- ViewModel logic: initial load, prefetch/infinite scroll, **caching** & **deduping**, min-query guard

Run tests with **⌘U**.  
If you see `No such module 'XCTest'`, ensure test files belong to the **Test target**, not the App target.

## Project Structure
## Screenshot
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-08-18 at 02 36 29" src="https://github.com/user-attachments/assets/55e3c975-e255-4724-b5c1-17173e079a91" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-08-18 at 02 36 39" src="https://github.com/user-attachments/assets/8c3401d9-47b4-46e6-b3a6-9154acf37762" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-08-18 at 02 44 01" src="https://github.com/user-attachments/assets/a36891f2-91a0-4f23-a58d-463d35f4150d" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-08-18 at 02 37 07" src="https://github.com/user-attachments/assets/210e94d3-cbdd-40b8-b89f-ffceb5850bc9" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-08-18 at 02 37 11" src="https://github.com/user-attachments/assets/4ac0e3ec-ff80-47e0-a6af-31f87e06f7cf" />
<img width="1206" height="2622" alt="Simulator Screenshot - iPhone 16 Pro - 2025-08-18 at 02 37 26" src="https://github.com/user-attachments/assets/e1f21cd6-6ffb-475c-bbd0-a82eddb777e4" />

