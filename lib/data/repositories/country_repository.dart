import 'package:shared_preferences/shared_preferences.dart';
import '../datasources/country_api_client.dart';
import '../../models/country_summary.dart';
import '../../models/country_details.dart';

/// Repository layer that abstracts data operations
/// Acts as a single source of truth for country data
class CountryRepository {
  // API client for fetching data from REST Countries API
  final CountryApiClient _apiClient;
  
  // Key used to store favorites in local storage
  static const String _favoritesKey = 'favorite_countries';

  // Constructor: Requires API client dependency
  CountryRepository(this._apiClient);

  /// Fetches all countries from the API
  /// Returns: List of CountrySummary objects
  Future<List<CountrySummary>> getAllCountries() => _apiClient.getAllCountries();

  /// Searches for countries by name
  /// Parameters: name - The search query
  /// Returns: List of matching CountrySummary objects
  Future<List<CountrySummary>> searchCountries(String name) => _apiClient.searchCountries(name);

  /// Gets detailed information for a specific country
  /// Parameters: code - The country code (cca2)
  /// Returns: CountryDetails object
  Future<CountryDetails> getCountryDetails(String code) => _apiClient.getCountryDetails(code);

  /// Retrieves the list of favorite country codes from local storage
  /// Returns: Set of country codes (cca2) that are favorited
  Future<Set<String>> getFavorites() async {
    // Get SharedPreferences instance for local storage access
    final prefs = await SharedPreferences.getInstance();
    
    // Retrieve the list of favorites, return empty set if none exist
    return prefs.getStringList(_favoritesKey)?.toSet() ?? {};
  }

  /// Toggles a country's favorite status (add if not present, remove if present)
  /// Parameters: cca2 - The country code to toggle
  Future<void> toggleFavorite(String cca2) async {
    // Get SharedPreferences instance
    final prefs = await SharedPreferences.getInstance();
    
    // Load current favorites from storage
    final favorites = prefs.getStringList(_favoritesKey)?.toSet() ?? {};
    
    // Check if country is already in favorites
    if (favorites.contains(cca2)) {
      // Remove from favorites if already present
      favorites.remove(cca2);
    } else {
      // Add to favorites if not present
      favorites.add(cca2);
    }
    
    // Save updated favorites back to local storage
    await prefs.setStringList(_favoritesKey, favorites.toList());
  }
}
