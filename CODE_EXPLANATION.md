# Code Explanation Guide

This document explains what each part of the code does in simple terms.

## 📁 Project Structure Overview

```
lib/
├── main.dart              # App starts here
├── models/                # Data structures
├── data/                  # Data fetching & storage
├── blocs/                 # State management
├── screens/               # UI pages
├── widgets/               # Reusable UI components
└── utils/                 # Helper functions
```

---

## 🚀 main.dart - App Entry Point

**What it does:** Starts the app and sets up dependencies

```dart
void main() {
  runApp(const MyApp());  // Start the app
}
```

**Key parts:**
1. **BlocProvider**: Makes CountryCubit available to entire app
2. **CountryRepository**: Creates repository with API client
3. **MaterialApp**: Sets up app theme and home screen

**Think of it as:** The ignition key that starts your car and connects all systems

---

## 📦 Models - Data Structures

### country_summary.dart

**What it does:** Defines the structure for country data in lists

**Fields:**
- `name`: Country name (e.g., "United States")
- `flag`: URL to flag image
- `population`: Number of people
- `cca2`: 2-letter code (e.g., "US")

**fromJson method:**
- Converts API response (JSON) into CountrySummary object
- Example: `{"name": {"common": "USA"}}` → `name: "USA"`

**Equatable:**
- Allows comparing two countries to see if they're the same
- Used by BLoC to detect state changes

**Think of it as:** A form template that organizes country information

---

### country_details.dart

**What it does:** Defines structure for detailed country information

**Additional fields:**
- `capital`: Capital city
- `region`: Geographic region (e.g., "Europe")
- `subregion`: Sub-region (e.g., "Western Europe")
- `area`: Land area in km²
- `timezones`: List of timezones

**Think of it as:** An expanded form with more detailed information

---

## 🌐 Data Layer

### country_api_client.dart

**What it does:** Talks to the REST Countries API to fetch data

**Dio setup:**
```dart
Dio(BaseOptions(
  baseUrl: 'https://restcountries.com/v3.1',
  connectTimeout: Duration(seconds: 10),  // Wait max 10s to connect
  receiveTimeout: Duration(seconds: 10),  // Wait max 10s for response
))
```

**Methods:**

1. **getAllCountries()**
   - Fetches all countries
   - URL: `/all?fields=name,flags,population,cca2`
   - Returns: List of CountrySummary

2. **searchCountries(name)**
   - Searches by country name
   - URL: `/name/{name}?fields=...`
   - Returns: List of matching countries

3. **getCountryDetails(code)**
   - Gets full details for one country
   - URL: `/alpha/{code}?fields=...`
   - Returns: CountryDetails object

**Think of it as:** A messenger that fetches information from the internet

---

### country_repository.dart

**What it does:** Manages both API data and local storage (favorites)

**Why we need it:**
- Separates data logic from UI
- Single place to manage data operations
- Easy to test and modify

**Methods:**

1. **getAllCountries()** → Calls API client
2. **searchCountries(name)** → Calls API client
3. **getCountryDetails(code)** → Calls API client

4. **getFavorites()**
   - Reads favorites from phone storage
   - Returns: Set of country codes (e.g., {"US", "GB"})

5. **toggleFavorite(cca2)**
   - If country is favorited → Remove it
   - If country is not favorited → Add it
   - Saves to phone storage

**SharedPreferences:**
- Stores data on the phone
- Data persists even after closing app
- Key: "favorite_countries"
- Value: List of country codes

**Think of it as:** A librarian who fetches books (API) and keeps track of your favorites (storage)

---

## 🎯 State Management (BLoC/Cubit)

### country_state.dart

**What it does:** Defines all possible states the app can be in

**States:**

1. **CountryInitial**
   - App just started
   - No data yet

2. **CountryLoading**
   - Fetching data from API
   - Shows shimmer loading

3. **CountryLoaded**
   - Data successfully loaded
   - Contains: countries list + favorites set
   - Shows country list

4. **CountryError**
   - Something went wrong
   - Contains: error message
   - Shows error screen with retry button

**Think of it as:** Traffic lights (red, yellow, green) - each state tells UI what to show

---

### country_cubit.dart

**What it does:** Manages state and business logic

**Flow:**

```
User Action → Cubit Method → emit(State) → UI Updates
```

**Methods:**

1. **loadCountries()**
   ```
   emit(CountryLoading)           // Show loading
   ↓
   Fetch from API
   ↓
   Success? → emit(CountryLoaded) // Show list
   Error? → emit(CountryError)    // Show error
   ```

2. **searchCountries(query)**
   ```
   Empty query? → loadCountries() // Show all
   ↓
   emit(CountryLoading)
   ↓
   Search API
   ↓
   emit(CountryLoaded) or emit(CountryError)
   ```

3. **toggleFavorite(cca2)**
   ```
   Toggle in storage
   ↓
   Reload favorites
   ↓
   emit(CountryLoaded with updated favorites)
   ↓
   UI updates heart icon
   ```

**Think of it as:** A traffic controller directing data flow and telling UI what to display

---

## 🎨 UI Components

### home_screen.dart

**What it does:** Main screen with country list and search

**Key parts:**

1. **State variables:**
   - `_selectedIndex`: Which tab is active (0=Home, 1=Favorites)
   - `_searchController`: Manages search text field

2. **initState():**
   - Runs when screen first appears
   - Calls `loadCountries()` to fetch data

3. **dispose():**
   - Runs when screen is destroyed
   - Cleans up search controller

4. **AppBar:**
   - Home tab: Shows "Countries" + search bar
   - Favorites tab: Shows "Favorites" only

5. **Body:**
   - Home tab: Shows `_buildHomeContent()`
   - Favorites tab: Shows `FavoritesScreen()`

6. **BottomNavigationBar:**
   - Two tabs: Home and Favorites
   - Switches content when tapped

7. **_buildHomeContent():**
   - Uses BlocBuilder to listen to state changes
   - Shows different UI based on state:
     - Loading → Shimmer skeleton
     - Loaded → Country list
     - Error → Error message + retry
     - Empty → "No countries found"

**Think of it as:** The main dashboard of your app

---

### favorites_screen.dart

**What it does:** Shows only favorited countries

**How it works:**

1. Listens to CountryState
2. Filters countries where `favorites.contains(country.cca2)`
3. Shows filtered list

**Empty state:**
- No favorites? → Shows heart icon + message

**Think of it as:** A filtered view of your bookmarks

---

### country_list_item.dart

**What it does:** Displays one country in the list

**Layout:**
```
[Flag Image] [Country Name        ] [Heart Icon]
             [Population: 47.1M   ]
```

**Parts:**

1. **InkWell:** Makes entire item tappable
2. **Flag Image:**
   - Loads from URL
   - Shows placeholder if fails
3. **Text Column:**
   - Country name (bold)
   - Population (gray, formatted)
4. **Heart Icon:**
   - Filled red if favorited
   - Outline gray if not favorited
   - Tappable to toggle

**Think of it as:** A business card for each country

---

### country_list_shimmer.dart

**What it does:** Shows loading animation while fetching data

**How it works:**
- Creates 10 placeholder items
- Shimmer effect: gray boxes that "shine"
- Mimics the layout of real country items

**Think of it as:** A "loading..." animation that looks professional

---

## 🛠️ Utilities

### format_utils.dart

**What it does:** Formats large numbers into readable format

**Examples:**
- 1,300,000,000 → "1.3B"
- 47,100,000 → "47.1M"
- 5,500 → "5.5K"
- 500 → "500"

**Logic:**
```dart
if (population >= 1 billion) → format as "B"
else if (population >= 1 million) → format as "M"
else if (population >= 1 thousand) → format as "K"
else → show as-is
```

**Think of it as:** A number abbreviator for better readability

---

## 🔄 Data Flow Example

### Scenario: User opens app

```
1. main.dart runs
   ↓
2. HomeScreen appears
   ↓
3. initState() calls loadCountries()
   ↓
4. CountryCubit.loadCountries()
   ↓
5. emit(CountryLoading)
   ↓
6. UI shows shimmer
   ↓
7. Repository.getAllCountries()
   ↓
8. ApiClient makes HTTP request
   ↓
9. API returns JSON data
   ↓
10. Convert JSON to List<CountrySummary>
    ↓
11. Load favorites from SharedPreferences
    ↓
12. emit(CountryLoaded(countries, favorites))
    ↓
13. UI rebuilds and shows country list
```

---

### Scenario: User searches for "United"

```
1. User types "United" in search bar
   ↓
2. onChanged triggers _onSearch("United")
   ↓
3. CountryCubit.searchCountries("United")
   ↓
4. emit(CountryLoading)
   ↓
5. UI shows shimmer
   ↓
6. ApiClient.searchCountries("United")
   ↓
7. API returns matching countries
   ↓
8. emit(CountryLoaded(results, favorites))
   ↓
9. UI shows filtered list (United States, United Kingdom, etc.)
```

---

### Scenario: User favorites a country

```
1. User taps heart icon on "Spain"
   ↓
2. onFavoriteToggle() called
   ↓
3. CountryCubit.toggleFavorite("ES")
   ↓
4. Repository.toggleFavorite("ES")
   ↓
5. Load current favorites from storage
   ↓
6. "ES" not in favorites? → Add it
   ↓
7. Save updated favorites to storage
   ↓
8. Repository.getFavorites()
   ↓
9. emit(CountryLoaded(countries, updatedFavorites))
   ↓
10. UI rebuilds
    ↓
11. Heart icon changes from outline to filled red
```

---

## 🎓 Key Concepts Explained

### 1. BLoC Pattern

**Problem:** How to separate UI from business logic?

**Solution:** BLoC (Business Logic Component)
- UI sends events/calls methods
- BLoC processes logic
- BLoC emits states
- UI reacts to states

**Benefits:**
- Clean separation
- Easy to test
- Reusable logic

---

### 2. Repository Pattern

**Problem:** UI shouldn't know where data comes from

**Solution:** Repository layer
- UI asks repository for data
- Repository decides: API? Local storage? Cache?
- Easy to change data source without changing UI

---

### 3. Immutable Models

**Problem:** Accidental data changes cause bugs

**Solution:** Immutable models with Equatable
- Can't change data after creation
- Must create new object to "change" data
- Equatable compares values, not references

---

### 4. State Management

**Problem:** How to update UI when data changes?

**Solution:** State-based rendering
- Define all possible states
- UI renders based on current state
- State changes → UI automatically updates

---

## 🐛 Common Issues & Solutions

### Issue: "No countries found" after search

**Cause:** API returned no results or network error

**Solution:** 
- Check internet connection
- Try different search term
- Tap retry button

---

### Issue: Favorites not persisting

**Cause:** SharedPreferences not saving

**Solution:**
- Check permissions
- Ensure toggleFavorite completes
- Check device storage

---

### Issue: Images not loading

**Cause:** Network issue or invalid URL

**Solution:**
- Error handler shows placeholder
- Check internet connection
- API might have changed

---

## 📚 Summary

**Data Flow:**
```
API → ApiClient → Repository → Cubit → State → UI
```

**User Interaction:**
```
UI → Cubit → Repository → Storage/API → Cubit → State → UI
```

**Key Files:**
- `main.dart`: App entry
- `country_cubit.dart`: Business logic
- `country_repository.dart`: Data management
- `home_screen.dart`: Main UI
- `country_list_item.dart`: List item UI

**Key Concepts:**
- BLoC: Separates logic from UI
- Repository: Abstracts data sources
- States: Define UI appearance
- Immutability: Prevents bugs

---

## 🎯 Next Steps to Learn

1. **Add detail screen:**
   - Create new screen
   - Use getCountryDetails() API
   - Navigate on item tap

2. **Add tests:**
   - Test Cubit logic
   - Test API client
   - Test widgets

3. **Add offline mode:**
   - Cache countries locally
   - Show cached data when offline

4. **Add filters:**
   - Filter by region
   - Sort by name/population

This architecture makes all these enhancements easy to add!
