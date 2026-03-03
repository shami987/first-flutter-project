import 'package:dio/dio.dart';
import '../../models/country_summary.dart';
import '../../models/country_details.dart';

/// API Client for REST Countries API
/// Handles all HTTP requests to fetch country data
class CountryApiClient {
  // Private Dio instance for making HTTP requests
  final Dio _dio;
  
  // Base URL for the REST Countries API
  static const String _baseUrl = 'https://restcountries.com/v3.1';

  // Constructor: Initializes Dio with base URL and timeout settings
  CountryApiClient() : _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 10), // Wait max 10s to connect
    receiveTimeout: const Duration(seconds: 10), // Wait max 10s for response
  ));

  /// Fetches all countries with minimal data (for list display)
  /// Returns: List of CountrySummary objects
  /// Throws: DioException if network request fails
  Future<List<CountrySummary>> getAllCountries() async {
    // Make GET request with required fields including capital
    final response = await _dio.get('/all?fields=name,flags,population,cca2,capital');
    
    // Convert JSON array to List of CountrySummary objects
    return (response.data as List)
        .map((json) => CountrySummary.fromJson(json))
        .toList();
  }

  /// Searches countries by name
  /// Parameters: name - The country name to search for
  /// Returns: List of matching CountrySummary objects
  /// Throws: DioException if no countries found or network fails
  Future<List<CountrySummary>> searchCountries(String name) async {
    // Make GET request to search endpoint with country name including capital
    final response = await _dio.get('/name/$name?fields=name,flags,population,cca2,capital');
    
    // Convert JSON array to List of CountrySummary objects
    return (response.data as List)
        .map((json) => CountrySummary.fromJson(json))
        .toList();
  }

  /// Fetches detailed information for a specific country
  /// Parameters: code - The country code (cca2) like 'US', 'GB'
  /// Returns: CountryDetails object with full information
  /// Throws: DioException if country not found or network fails
  Future<CountryDetails> getCountryDetails(String code) async {
    // Make GET request with all required fields for detail screen
    final response = await _dio.get('/alpha/$code?fields=name,flags,population,capital,region,subregion,area,timezones');
    
    // Convert JSON object to CountryDetails
    return CountryDetails.fromJson(response.data);
  }
}
