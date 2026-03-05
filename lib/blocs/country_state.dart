import 'package:equatable/equatable.dart';
import '../models/country_summary.dart';

enum CountrySortOption { name, population }

/// Base class for all country-related states
/// Uses Equatable for efficient state comparison in BLoC
abstract class CountryState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state when the app first loads
/// No data has been fetched yet
class CountryInitial extends CountryState {}

/// Loading state while fetching data from API
/// Triggers shimmer loading UI
class CountryLoading extends CountryState {}

/// Success state with loaded data
/// Contains both countries list and favorites set
class CountryLoaded extends CountryState {
  final List<CountrySummary> countries;  // List of countries to display
  final Set<String> favorites;           // Set of favorited country codes (cca2)
  final CountrySortOption sortOption;

  CountryLoaded(
    this.countries,
    this.favorites, {
    this.sortOption = CountrySortOption.name,
  });

  /// Include both fields in equality comparison
  /// State changes when either countries or favorites change
  @override
  List<Object?> get props => [countries, favorites, sortOption];
}

/// Error state when API call fails
/// Contains error message to display to user
class CountryError extends CountryState {
  final String message;  // User-friendly error message

  CountryError(this.message);

  /// Include message in equality comparison
  @override
  List<Object?> get props => [message];
}
