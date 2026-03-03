# Country Visualization App

A Flutter mobile application that allows users to browse, search, and learn about the world's countries using the REST Countries API.

## Features

- ✅ Browse all countries with flag, name, and population
- ✅ Search countries by name
- ✅ Add/remove countries to favorites (persisted locally)
- ✅ View favorites in a dedicated tab
- ✅ Shimmer loading states
- ✅ Error handling with retry functionality
- ✅ Clean architecture with BLoC state management

## Architecture

### Project Structure
```
lib/
├── blocs/              # State management (Cubit)
├── data/
│   ├── datasources/    # API client
│   └── repositories/   # Data repository
├── models/             # Data models
├── screens/            # UI screens
├── widgets/            # Reusable widgets
├── utils/              # Utility functions
└── main.dart           # App entry point
```

### State Management
- **BLoC/Cubit**: Used for managing application state
- **States**: Loading, Loaded, Error, Initial

### Data Flow
1. **API Client** → Fetches data from REST Countries API
2. **Repository** → Abstracts data operations and manages favorites
3. **Cubit** → Manages state and business logic
4. **UI** → Reacts to state changes

## Technical Implementation

### Dependencies
- `flutter_bloc: ^8.1.6` - State management
- `equatable: ^2.0.5` - Value equality for models
- `dio: ^5.7.0` - HTTP client
- `shared_preferences: ^2.3.3` - Local storage for favorites
- `shimmer: ^3.0.0` - Loading skeleton UI

### API Integration

**Step 1: Minimal Data for Lists**
- Endpoint: `https://restcountries.com/v3.1/all?fields=name,flags,population,cca2`
- Fields: name, flag, population, cca2 (unique identifier)

**Step 2: Full Data for Details** (Ready for implementation)
- Endpoint: `https://restcountries.com/v3.1/alpha/{code}?fields=name,flags,population,capital,region,subregion,area,timezones`

### Data Models

**CountrySummary** (for lists)
- name, flag, population, cca2

**CountryDetails** (for detail screen - ready for future implementation)
- name, flag, population, capital, region, subregion, area, timezones

## Getting Started

### Prerequisites
- Flutter SDK (^3.11.1)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- Android Emulator or iOS Simulator

### Installation

1. **Clone the repository**
```bash
git clone <your-repo-url>
cd country_visualization
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
flutter run
```

### For Windows Users
If you encounter symlink issues, enable Developer Mode:
```bash
start ms-settings:developers
```

## User Stories Implemented

### ✅ User Story 1: View a List of All Countries
- Scrollable list of all countries
- Displays flag, name, and formatted population
- Shimmer loading effect during data fetch
- Error state with retry button
- Bottom navigation with Home and Favorites tabs

### ✅ Additional Features
- Search functionality
- Persistent favorites using local storage
- Empty states for search and favorites
- Clean, Material Design UI

## Code Quality

- ✅ Clean architecture with separation of concerns
- ✅ Immutable data models using Equatable
- ✅ Proper error handling
- ✅ Loading states for better UX
- ✅ Scalable state management with BLoC
- ✅ Reusable widgets
- ✅ Type-safe code

## Future Enhancements

- [ ] Country detail screen with full information
- [ ] Offline caching
- [ ] Filter by region/subregion
- [ ] Sort options (name, population)
- [ ] Unit and widget tests
- [ ] Dark mode support

## Testing

Run tests:
```bash
flutter test
```

## Build for Production

**Android:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

## Resources

- [REST Countries API](https://restcountries.com/)
- [Flutter Documentation](https://docs.flutter.dev/)
- [BLoC Library](https://bloclibrary.dev/)

## License

This project is created for educational purposes.
