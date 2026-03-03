# Visual Learning Guide

## 🎯 Understanding the App Flow with Examples

---

## Example 1: App Startup

### What You See:
```
┌─────────────────────┐
│    Countries        │  ← AppBar
├─────────────────────┤
│ 🔍 Search...        │  ← Search bar
├─────────────────────┤
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │  ← Shimmer loading
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │
│ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓  │
└─────────────────────┘
```

### What Happens Behind the Scenes:

```dart
// 1. App starts
main() → runApp(MyApp())

// 2. BLoC Provider created
BlocProvider(
  create: CountryCubit(
    CountryRepository(CountryApiClient())
  )
)

// 3. HomeScreen appears
HomeScreen.initState()

// 4. Load countries
context.read<CountryCubit>().loadCountries()

// 5. Cubit emits loading state
emit(CountryLoading)

// 6. UI shows shimmer
BlocBuilder sees CountryLoading → shows CountryListShimmer()

// 7. API call
Repository → ApiClient → HTTP GET → REST Countries API

// 8. Data received
JSON → List<CountrySummary>

// 9. Load favorites
SharedPreferences → Set<String>

// 10. Cubit emits loaded state
emit(CountryLoaded(countries, favorites))

// 11. UI updates
BlocBuilder sees CountryLoaded → shows ListView with countries
```

### Result:
```
┌─────────────────────┐
│    Countries        │
├─────────────────────┤
│ 🔍 Search...        │
├─────────────────────┤
│ 🇪🇸 Spain          ♡│
│    Population: 47.1M│
├─────────────────────┤
│ 🇬🇧 United Kingdom ♡│
│    Population: 67.3M│
├─────────────────────┤
│ 🇩🇪 Germany        ♡│
│    Population: 83.2M│
└─────────────────────┘
```

---

## Example 2: Searching for a Country

### User Action:
```
User types: "United"
```

### Code Flow:

```dart
// 1. TextField detects change
TextField(
  onChanged: _onSearch,  // ← Triggered
)

// 2. Search method called
void _onSearch(String query) {
  context.read<CountryCubit>().searchCountries(query);
}

// 3. Cubit processes search
Future<void> searchCountries(String query) async {
  // Check if empty
  if (query.isEmpty) {
    loadCountries();  // Show all
    return;
  }
  
  // Emit loading
  emit(CountryLoading);
  
  try {
    // Search API
    final countries = await _repository.searchCountries(query);
    final favorites = await _repository.getFavorites();
    
    // Emit results
    emit(CountryLoaded(countries, favorites));
  } catch (e) {
    // Emit error
    emit(CountryError('No countries found...'));
  }
}

// 4. Repository calls API
Future<List<CountrySummary>> searchCountries(String name) {
  return _apiClient.searchCountries(name);
}

// 5. API client makes request
Future<List<CountrySummary>> searchCountries(String name) async {
  final response = await _dio.get('/name/$name?fields=...');
  return (response.data as List)
      .map((json) => CountrySummary.fromJson(json))
      .toList();
}
```

### API Request:
```
GET https://restcountries.com/v3.1/name/United?fields=name,flags,population,cca2
```

### API Response:
```json
[
  {
    "name": {"common": "United States"},
    "flags": {"png": "https://..."},
    "population": 331002651,
    "cca2": "US"
  },
  {
    "name": {"common": "United Kingdom"},
    "flags": {"png": "https://..."},
    "population": 67215293,
    "cca2": "GB"
  }
]
```

### Result on Screen:
```
┌─────────────────────┐
│    Countries        │
├─────────────────────┤
│ 🔍 United           │  ← User's search
├─────────────────────┤
│ 🇺🇸 United States  ♡│  ← Filtered results
│    Population: 331M │
├─────────────────────┤
│ 🇬🇧 United Kingdom ♡│
│    Population: 67.2M│
└─────────────────────┘
```

---

## Example 3: Adding to Favorites

### User Action:
```
User taps heart icon on "Spain"
```

### Code Flow:

```dart
// 1. Heart icon tapped
IconButton(
  onPressed: onFavoriteToggle,  // ← Triggered
)

// 2. Callback in HomeScreen
CountryListItem(
  onFavoriteToggle: () {
    context.read<CountryCubit>().toggleFavorite(country.cca2);
  },
)

// 3. Cubit toggles favorite
Future<void> toggleFavorite(String cca2) async {
  final currentState = state;
  
  if (currentState is CountryLoaded) {
    // Toggle in storage
    await _repository.toggleFavorite(cca2);
    
    // Reload favorites
    final favorites = await _repository.getFavorites();
    
    // Emit updated state
    emit(CountryLoaded(currentState.countries, favorites));
  }
}

// 4. Repository toggles
Future<void> toggleFavorite(String cca2) async {
  final prefs = await SharedPreferences.getInstance();
  final favorites = prefs.getStringList(_favoritesKey)?.toSet() ?? {};
  
  if (favorites.contains(cca2)) {
    favorites.remove(cca2);  // Remove if exists
  } else {
    favorites.add(cca2);     // Add if doesn't exist
  }
  
  await prefs.setStringList(_favoritesKey, favorites.toList());
}
```

### Storage Before:
```json
{
  "favorite_countries": ["US", "GB", "DE"]
}
```

### Storage After:
```json
{
  "favorite_countries": ["US", "GB", "DE", "ES"]  ← Spain added
}
```

### UI Update:
```
Before:                After:
┌──────────────┐      ┌──────────────┐
│ 🇪🇸 Spain   ♡│  →   │ 🇪🇸 Spain   ♥│  ← Heart filled
│ Population...│      │ Population...│
└──────────────┘      └──────────────┘
```

---

## Example 4: Viewing Favorites

### User Action:
```
User taps "Favorites" tab
```

### Code Flow:

```dart
// 1. Bottom nav tapped
BottomNavigationBar(
  onTap: (index) => setState(() => _selectedIndex = index),
)

// 2. State updates
_selectedIndex = 1  // Favorites tab

// 3. Body switches
body: _selectedIndex == 0 
    ? _buildHomeContent() 
    : const FavoritesScreen(),  // ← Shows this

// 4. FavoritesScreen filters
BlocBuilder<CountryCubit, CountryState>(
  builder: (context, state) {
    if (state is CountryLoaded) {
      // Filter only favorites
      final favoriteCountries = state.countries
          .where((country) => state.favorites.contains(country.cca2))
          .toList();
      
      // Show list
      return ListView.builder(...);
    }
  },
)
```

### Data:
```dart
// All countries
countries = [Spain, UK, Germany, Italy, France, ...]

// Favorites set
favorites = {"ES", "GB", "DE"}

// Filtered result
favoriteCountries = [Spain, UK, Germany]
```

### Result:
```
┌─────────────────────┐
│    Favorites        │  ← AppBar changed
├─────────────────────┤
│ 🇪🇸 Spain          ♥│  ← Only favorited
│    Population: 47.1M│     countries shown
├─────────────────────┤
│ 🇬🇧 United Kingdom ♥│
│    Population: 67.3M│
├─────────────────────┤
│ 🇩🇪 Germany        ♥│
│    Population: 83.2M│
└─────────────────────┘
```

---

## Example 5: Error Handling

### Scenario: No Internet Connection

### Code Flow:

```dart
// 1. User opens app
loadCountries()

// 2. Emit loading
emit(CountryLoading)

// 3. Try API call
try {
  final countries = await _repository.getAllCountries();
  // ...
} catch (e) {  // ← Exception caught
  emit(CountryError('Failed to load countries. Please try again.'));
}

// 4. UI shows error
if (state is CountryError) {
  return Center(
    child: Column(
      children: [
        Icon(Icons.error_outline),  // Error icon
        Text(state.message),        // Error message
        ElevatedButton(             // Retry button
          onPressed: () => loadCountries(),
          child: Text('Retry'),
        ),
      ],
    ),
  );
}
```

### Result:
```
┌─────────────────────┐
│    Countries        │
├─────────────────────┤
│                     │
│        ⚠️          │
│                     │
│  Failed to load     │
│  countries. Please  │
│  try again.         │
│                     │
│   ┌───────────┐    │
│   │   Retry   │    │  ← Tappable button
│   └───────────┘    │
│                     │
└─────────────────────┘
```

---

## Example 6: Empty Search Results

### User Action:
```
User searches: "xyz"
```

### Code Flow:

```dart
// 1. Search triggered
searchCountries("xyz")

// 2. API call fails (404)
catch (e) {
  emit(CountryError('No countries found. Try a different search.'));
}

// 3. UI shows empty state
if (state is CountryLoaded && state.countries.isEmpty) {
  return Center(
    child: Column(
      children: [
        Icon(Icons.search_off),
        Text('No countries found'),
      ],
    ),
  );
}
```

### Result:
```
┌─────────────────────┐
│    Countries        │
├─────────────────────┤
│ 🔍 xyz              │  ← User's search
├─────────────────────┤
│                     │
│        🔍          │
│         ╱           │
│                     │
│  No countries found │
│                     │
└─────────────────────┘
```

---

## State Transition Diagram

```
┌─────────────┐
│   Initial   │  App starts
└──────┬──────┘
       │
       ↓ loadCountries()
┌─────────────┐
│   Loading   │  Shows shimmer
└──────┬──────┘
       │
       ├─→ Success
       │   ↓
       │ ┌─────────────┐
       │ │   Loaded    │  Shows list
       │ └──────┬──────┘
       │        │
       │        ├─→ searchCountries()
       │        │   ↓
       │        │ ┌─────────────┐
       │        │ │   Loading   │
       │        │ └──────┬──────┘
       │        │        │
       │        │        ├─→ Success
       │        │        │   ↓
       │        │        │ ┌─────────────┐
       │        │        │ │   Loaded    │
       │        │        │ └─────────────┘
       │        │        │
       │        │        └─→ Error
       │        │            ↓
       │        │          ┌─────────────┐
       │        │          │    Error    │
       │        │          └─────────────┘
       │        │
       │        └─→ toggleFavorite()
       │            ↓
       │          ┌─────────────┐
       │          │   Loaded    │  Updated favorites
       │          └─────────────┘
       │
       └─→ Error
           ↓
         ┌─────────────┐
         │    Error    │  Shows error + retry
         └──────┬──────┘
                │
                └─→ Retry
                    ↓
                  ┌─────────────┐
                  │   Loading   │
                  └─────────────┘
```

---

## Data Transformation Example

### From API to UI:

```
API Response (JSON)
↓
{
  "name": {
    "common": "United States",
    "official": "United States of America"
  },
  "flags": {
    "png": "https://flagcdn.com/w320/us.png",
    "svg": "https://flagcdn.com/us.svg"
  },
  "population": 331002651,
  "cca2": "US"
}

↓ CountrySummary.fromJson()

CountrySummary Object
↓
CountrySummary(
  name: "United States",
  flag: "https://flagcdn.com/w320/us.png",
  population: 331002651,
  cca2: "US"
)

↓ FormatUtils.formatPopulation()

Formatted for Display
↓
"Population: 331.0M"

↓ CountryListItem Widget

UI Display
↓
┌──────────────────────┐
│ 🇺🇸 United States  ♡│
│    Population: 331.0M│
└──────────────────────┘
```

---

## Summary

### Key Patterns:

1. **User Action** → **Event** → **State Change** → **UI Update**
2. **UI** → **Cubit** → **Repository** → **API/Storage**
3. **Data** → **Transform** → **State** → **Render**

### Remember:

- **States** control what UI shows
- **Cubit** manages business logic
- **Repository** handles data operations
- **Widgets** react to state changes

### Flow:
```
User Interaction
      ↓
   Cubit Method
      ↓
  Repository Call
      ↓
   API/Storage
      ↓
  Data Returned
      ↓
   Emit State
      ↓
  UI Rebuilds
```

This is the core pattern used throughout the app! 🎯
