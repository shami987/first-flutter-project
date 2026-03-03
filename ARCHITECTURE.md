# Architecture Documentation

## Application Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                         UI Layer                             │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
│  │ HomeScreen   │  │ Favorites    │  │   Widgets    │      │
│  │              │  │   Screen     │  │  - ListItem  │      │
│  │ - List       │  │              │  │  - Shimmer   │      │
│  │ - Search     │  │ - Favorites  │  │              │      │
│  └──────┬───────┘  └──────┬───────┘  └──────────────┘      │
│         │                 │                                  │
└─────────┼─────────────────┼──────────────────────────────────┘
          │                 │
          └────────┬────────┘
                   │
┌──────────────────▼──────────────────────────────────────────┐
│                    BLoC Layer (State Management)             │
│  ┌────────────────────────────────────────────────────┐     │
│  │              CountryCubit                          │     │
│  │  - loadCountries()                                 │     │
│  │  - searchCountries(query)                          │     │
│  │  - toggleFavorite(cca2)                            │     │
│  └────────────────────┬───────────────────────────────┘     │
│                       │                                      │
│  ┌────────────────────▼───────────────────────────────┐     │
│  │              CountryState                          │     │
│  │  - CountryInitial                                  │     │
│  │  - CountryLoading                                  │     │
│  │  - CountryLoaded(countries, favorites)             │     │
│  │  - CountryError(message)                           │     │
│  └────────────────────────────────────────────────────┘     │
└──────────────────────┬───────────────────────────────────────┘
                       │
┌──────────────────────▼───────────────────────────────────────┐
│                    Repository Layer                          │
│  ┌────────────────────────────────────────────────────┐     │
│  │           CountryRepository                        │     │
│  │  - getAllCountries()                               │     │
│  │  - searchCountries(name)                           │     │
│  │  - getCountryDetails(code)                         │     │
│  │  - getFavorites()                                  │     │
│  │  - toggleFavorite(cca2)                            │     │
│  └────────┬──────────────────────┬────────────────────┘     │
└───────────┼──────────────────────┼───────────────────────────┘
            │                      │
┌───────────▼──────────┐  ┌────────▼─────────────────────────┐
│   Data Sources       │  │    Local Storage                 │
│  ┌────────────────┐  │  │  ┌────────────────────────────┐  │
│  │ CountryAPI     │  │  │  │  SharedPreferences         │  │
│  │   Client       │  │  │  │  - favorite_countries      │  │
│  │                │  │  │  └────────────────────────────┘  │
│  │ - Dio HTTP     │  │  │                                  │
│  │ - REST API     │  │  │                                  │
│  └────────┬───────┘  │  └──────────────────────────────────┘
└───────────┼──────────┘
            │
┌───────────▼──────────────────────────────────────────────────┐
│                  External API                                │
│         https://restcountries.com/v3.1                       │
│  - /all?fields=name,flags,population,cca2                    │
│  - /name/{name}?fields=name,flags,population,cca2            │
│  - /alpha/{code}?fields=name,flags,population,capital,...    │
└──────────────────────────────────────────────────────────────┘
```

## Data Flow

### 1. Loading Countries
```
User Opens App
      │
      ▼
HomeScreen.initState()
      │
      ▼
CountryCubit.loadCountries()
      │
      ├─► emit(CountryLoading)
      │
      ▼
CountryRepository.getAllCountries()
      │
      ▼
CountryApiClient.getAllCountries()
      │
      ▼
REST API Call
      │
      ├─► Success
      │   │
      │   ▼
      │   CountryRepository.getFavorites()
      │   │
      │   ▼
      │   emit(CountryLoaded(countries, favorites))
      │   │
      │   ▼
      │   UI Updates (shows list)
      │
      └─► Error
          │
          ▼
          emit(CountryError(message))
          │
          ▼
          UI Shows Error + Retry Button
```

### 2. Search Flow
```
User Types in Search Bar
      │
      ▼
onChanged(query)
      │
      ▼
CountryCubit.searchCountries(query)
      │
      ├─► query.isEmpty?
      │   │
      │   ├─► Yes: loadCountries()
      │   │
      │   └─► No: Continue
      │
      ├─► emit(CountryLoading)
      │
      ▼
CountryRepository.searchCountries(query)
      │
      ▼
CountryApiClient.searchCountries(query)
      │
      ▼
REST API Call: /name/{query}
      │
      ├─► Success
      │   │
      │   ▼
      │   emit(CountryLoaded(results, favorites))
      │   │
      │   ▼
      │   UI Updates (shows filtered list)
      │
      └─► Error
          │
          ▼
          emit(CountryError("No countries found"))
          │
          ▼
          UI Shows Empty State
```

### 3. Toggle Favorite Flow
```
User Taps Heart Icon
      │
      ▼
onFavoriteToggle()
      │
      ▼
CountryCubit.toggleFavorite(cca2)
      │
      ▼
CountryRepository.toggleFavorite(cca2)
      │
      ├─► Load current favorites from SharedPreferences
      │
      ├─► Check if cca2 exists
      │   │
      │   ├─► Yes: Remove from set
      │   │
      │   └─► No: Add to set
      │
      ├─► Save updated favorites to SharedPreferences
      │
      ▼
CountryRepository.getFavorites()
      │
      ▼
emit(CountryLoaded(countries, updatedFavorites))
      │
      ▼
UI Updates (heart icon changes)
```

## State Management Pattern

### BLoC/Cubit Pattern
```
┌─────────────┐
│   Events    │  (User Actions)
│  - Load     │
│  - Search   │
│  - Toggle   │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│    Cubit    │  (Business Logic)
│  - Process  │
│  - Validate │
│  - Call API │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│   States    │  (UI State)
│  - Initial  │
│  - Loading  │
│  - Loaded   │
│  - Error    │
└──────┬──────┘
       │
       ▼
┌─────────────┐
│     UI      │  (Rebuild)
│  - Display  │
│  - Update   │
└─────────────┘
```

## Key Design Decisions

### 1. Why BLoC/Cubit?
- ✅ Predictable state management
- ✅ Separation of business logic from UI
- ✅ Easy to test
- ✅ Scalable for complex apps

### 2. Why Repository Pattern?
- ✅ Abstracts data sources
- ✅ Single source of truth
- ✅ Easy to swap implementations
- ✅ Testable

### 3. Why Equatable?
- ✅ Value equality for models
- ✅ Efficient state comparison
- ✅ Prevents unnecessary rebuilds

### 4. Why Dio over http?
- ✅ Better error handling
- ✅ Interceptors support
- ✅ Timeout configuration
- ✅ More features out of the box

### 5. Why SharedPreferences?
- ✅ Simple key-value storage
- ✅ Perfect for favorites
- ✅ Persistent across app restarts
- ✅ Native platform support

## Performance Optimizations

### 1. Minimal API Calls
- Only fetch required fields
- Reduce payload size
- Faster response times

### 2. Efficient List Rendering
- ListView.builder (lazy loading)
- Only builds visible items
- Smooth scrolling

### 3. Image Caching
- Automatic with Image.network
- Reduces network calls
- Faster image loading

### 4. State Optimization
- Equatable prevents unnecessary rebuilds
- Only rebuild when state actually changes

## Error Handling Strategy

```
API Call
   │
   ├─► Network Error
   │   └─► Show: "Failed to load countries. Please try again."
   │       + Retry Button
   │
   ├─► Timeout Error
   │   └─► Show: "Request timed out. Please check your connection."
   │       + Retry Button
   │
   ├─► 404 Not Found (Search)
   │   └─► Show: "No countries found. Try a different search."
   │       + Empty State Icon
   │
   ├─► Image Load Error
   │   └─► Show: Placeholder with flag icon
   │
   └─► Success
       └─► Display Data
```

## Testing Strategy (Future)

### Unit Tests
- Cubit logic
- Repository methods
- Model serialization
- Utility functions

### Widget Tests
- Screen rendering
- User interactions
- State changes
- Navigation

### Integration Tests
- End-to-end flows
- API integration
- Local storage

## Scalability Considerations

### Current Architecture Supports:
- ✅ Adding new features (detail screen)
- ✅ Multiple data sources
- ✅ Offline mode
- ✅ Caching layer
- ✅ Additional filters/sorting
- ✅ Theme switching
- ✅ Localization

### How to Add Detail Screen:
1. Create `country_detail_screen.dart`
2. Add navigation in `onTap` callback
3. Create `CountryDetailCubit`
4. Use existing `getCountryDetails(code)` API
5. Display full country information

The architecture is ready for this enhancement!
