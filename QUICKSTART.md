# Quick Start Guide

## Step-by-Step Instructions

### 1. Verify Flutter Installation
```bash
flutter doctor
```
Ensure all checkmarks are green (at least for your target platform).

### 2. Install Dependencies
```bash
cd country_visualization
flutter pub get
```

### 3. Run the Application

**On Android Emulator:**
```bash
flutter run
```

**On iOS Simulator (macOS only):**
```bash
flutter run
```

**On Chrome (Web):**
```bash
flutter run -d chrome
```

### 4. Test the Features

1. **Home Screen**: View all countries with flags and population
2. **Search**: Type in the search bar to find specific countries
3. **Favorites**: Tap the heart icon to add/remove favorites
4. **Favorites Tab**: Switch to the Favorites tab to see saved countries

### 5. Build for Production

**Android APK:**
```bash
flutter build apk --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

**Android App Bundle (for Play Store):**
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

**iOS (macOS only):**
```bash
flutter build ios --release
```

### 6. Push to GitHub

```bash
# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit: Country Visualization App"

# Add remote repository
git remote add origin <your-github-repo-url>

# Push to GitHub
git push -u origin main
```

## Troubleshooting

### Issue: Symlink Error on Windows
**Solution:** Enable Developer Mode
```bash
start ms-settings:developers
```

### Issue: API Not Loading
**Solution:** Check internet connection and API availability

### Issue: Build Errors
**Solution:** Clean and rebuild
```bash
flutter clean
flutter pub get
flutter run
```

## Project Checklist

- [x] Dependencies installed
- [x] Data models created
- [x] API client implemented
- [x] Repository layer added
- [x] State management with BLoC/Cubit
- [x] Home screen with country list
- [x] Search functionality
- [x] Favorites feature with persistence
- [x] Loading states (shimmer)
- [x] Error handling
- [x] Empty states
- [x] Bottom navigation

## Next Steps (Optional Enhancements)

1. **Country Detail Screen**: Implement detailed view with capital, region, area, timezones
2. **Tests**: Add unit tests for Cubit and widget tests
3. **Offline Support**: Cache countries locally
4. **Filters**: Add region/subregion filters
5. **Dark Mode**: Implement theme switching

## Key Files to Review

- `lib/main.dart` - App entry point
- `lib/blocs/country_cubit.dart` - State management logic
- `lib/data/datasources/country_api_client.dart` - API calls
- `lib/screens/home_screen.dart` - Main UI
- `lib/models/` - Data models
