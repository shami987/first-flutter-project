import 'package:equatable/equatable.dart';

/// Immutable data model for country summary (minimal data for lists)
/// Uses Equatable for value-based equality comparison
class CountrySummary extends Equatable {
  final String name;       // Country's common name (e.g., "United States")
  final String flag;       // URL to flag image (PNG format)
  final int population;    // Total population count
  final String cca2;       // 2-letter country code (e.g., "US", "GB")
  final String capital;    // Capital city (e.g., "Paris")

  // Constructor: All fields are required
  const CountrySummary({
    required this.name,
    required this.flag,
    required this.population,
    required this.cca2,
    required this.capital,
  });

  /// Factory constructor to create CountrySummary from JSON
  /// Parameters: json - Map containing country data from API
  /// Returns: CountrySummary object
  factory CountrySummary.fromJson(Map<String, dynamic> json) {
    return CountrySummary(
      // Extract common name from nested 'name' object
      name: json['name']['common'] ?? '',
      
      // Extract PNG flag URL from nested 'flags' object
      flag: json['flags']['png'] ?? '',
      
      // Extract population, default to 0 if missing
      population: json['population'] ?? 0,
      
      // Extract 2-letter country code
      cca2: json['cca2'] ?? '',
      
      // Extract capital (first element of array, or 'N/A' if missing)
      capital: (json['capital'] as List?)?.isNotEmpty == true 
          ? json['capital'][0] 
          : 'N/A',
    );
  }

  /// Equatable props: Used for value-based equality comparison
  /// Two CountrySummary objects are equal if all these fields match
  @override
  List<Object?> get props => [name, flag, population, cca2, capital];
}
