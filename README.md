# Swoop — Surplus Materials Marketplace

**Find what you need. Spend less. Waste less.**

Swoop is a marketplace where people and businesses can buy and sell surplus materials that still have useful value — fabric scraps, acrylic offcuts, electronic components, mechanical spare parts, and more.

## Getting Started

### Prerequisites
- Flutter SDK (3.7+)
- Android SDK (for Android builds)

### Running the App

```bash
# Get dependencies
flutter pub get

# Run on connected device or emulator
flutter run

# Build APK
flutter build apk
```

### Project Structure

```
lib/
├── main.dart              # Entry point
├── app.dart               # Root widget + state provider
├── theme/
│   └── app_theme.dart     # Swoop brand theme
├── models/
│   └── listing.dart       # Listing data model
├── data/
│   ├── mock_listings.dart # Demo marketplace data
│   └── categories.dart    # Categories & options
├── state/
│   └── app_state.dart     # App state management
├── screens/
│   ├── main_shell.dart    # Bottom nav shell
│   ├── home_screen.dart   # Home / landing
│   ├── explore_screen.dart# Search & browse
│   ├── listing_details_screen.dart
│   ├── sell_screen.dart   # List materials
│   ├── saved_screen.dart  # Bookmarks
│   └── profile_screen.dart
└── widgets/
    ├── search_field.dart
    ├── category_chip.dart
    ├── listing_card.dart
    └── empty_state.dart
```

### Working Features

- ✅ Home screen with branding, hero card, categories, and product discovery
- ✅ Explore screen with search, category filtering, and sorting
- ✅ Product detail view with full listing information
- ✅ Save/unsave listings from anywhere
- ✅ "I'm interested" action with demo confirmation
- ✅ Sell screen with full form validation
- ✅ New listings appear in Home and Explore
- ✅ Environmental impact section
- ✅ Profile with demo stats
- ✅ Image loading with error fallbacks
- ✅ Empty states throughout
- ✅ Android back navigation

### Design

- Material 3 with custom colour scheme
- Forest green primary, warm cream backgrounds
- Soft lime accents
- Rounded cards, pill-shaped chips
- Clean typography with generous whitespace
- Smooth transitions and touch-friendly controls

### Note

This is a designathon prototype. All data is local and in-memory. No backend, authentication, or real transactions are involved.
