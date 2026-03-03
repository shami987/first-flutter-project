import 'package:shared_preferences/shared_preferences.dart';
import '../datasources/country_api_client.dart';
import '../../models/country_summary.dart';
import '../../models/country_details.dart';

class CountryRepository {
  final CountryApiClient _apiClient;
  static const String _favoritesKey = 'favorite_countries';

  CountryRepository(this._apiClient);

  Future<List<CountrySummary>> getAllCountries() => _apiClient.getAllCountries();

  Future<List<CountrySummary>> searchCountries(String name) => _apiClient.searchCountries(name);

  Future<CountryDetails> getCountryDetails(String code) => _apiClient.getCountryDetails(code);

  Future<Set<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey)?.toSet() ?? {};
  }

  Future<void> toggleFavorite(String cca2) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey)?.toSet() ?? {};
    
    if (favorites.contains(cca2)) {
      favorites.remove(cca2);
    } else {
      favorites.add(cca2);
    }
    
    await prefs.setStringList(_favoritesKey, favorites.toList());
  }
}
