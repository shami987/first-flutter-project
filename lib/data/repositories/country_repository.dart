import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../datasources/country_api_client.dart';
import '../../models/country_summary.dart';
import '../../models/country_details.dart';

class CountryRepository {
  final CountryApiClient _apiClient;
  static const String _favoritesKey = 'favorite_countries';
  static const String _countriesCacheKey = 'countries_cache';
  static const String _detailsCachePrefix = 'country_details_';
  
  CountryRepository(this._apiClient);

  Future<List<CountrySummary>> getAllCountries() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_countriesCacheKey);
    
    if (cached != null) {
      final List<dynamic> decoded = jsonDecode(cached);
      return decoded.map((json) => CountrySummary.fromJson(json)).toList();
    }
    
    final countries = await _apiClient.getAllCountries();
    await prefs.setString(_countriesCacheKey, jsonEncode(countries.map((c) => c.toJson()).toList()));
    return countries;
  }

  Future<List<CountrySummary>> searchCountries(String name) async {
    final countries = await getAllCountries();
    return countries.where((c) => c.name.toLowerCase().contains(name.toLowerCase())).toList();
  }

  Future<CountryDetails> getCountryDetails(String code) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_detailsCachePrefix$code';
    final cached = prefs.getString(cacheKey);
    
    if (cached != null) {
      return CountryDetails.fromJson(jsonDecode(cached));
    }
    
    final details = await _apiClient.getCountryDetails(code);
    await prefs.setString(cacheKey, jsonEncode(details.toJson()));
    return details;
  }

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
