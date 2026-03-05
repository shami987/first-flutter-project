import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/country_repository.dart';
import '../models/country_summary.dart';
import 'country_state.dart';

/// Cubit for managing country list state and business logic
/// Handles loading, searching, and favorite operations
class CountryCubit extends Cubit<CountryState> {
  // Repository for data operations
  final CountryRepository _repository;
  List<CountrySummary> _allCountries = [];
  String _searchQuery = '';
  CountrySortOption _sortOption = CountrySortOption.name;

  // Constructor: Starts with CountryInitial state
  CountryCubit(this._repository) : super(CountryInitial());

  /// Loads all countries from the API
  /// Emits: CountryLoading -> CountryLoaded or CountryError
  Future<void> loadCountries() async {
    // Emit loading state to show shimmer UI
    emit(CountryLoading());
    
    try {
      // Fetch countries from API
      _allCountries = await _repository.getAllCountries();
      
      // Load favorites from local storage
      final favorites = await _repository.getFavorites();
      
      // Reset sort option to none when loading
      _sortOption = CountrySortOption.none;
      
      // Emit success state with data
      emit(
        CountryLoaded(
          _buildCountryList(),
          favorites,
          sortOption: _sortOption,
        ),
      );
    } catch (e) {
      // Emit error state with user-friendly message
      emit(CountryError('Failed to load countries. Please try again.'));
    }
  }

  /// Searches for countries by name
  /// Parameters: query - The search term entered by user
  /// Emits: CountryLoading -> CountryLoaded or CountryError
  Future<void> searchCountries(String query) async {
    _searchQuery = query.trim();

    if (_allCountries.isEmpty) {
      await loadCountries();
      return;
    }

    final currentState = state;
    if (currentState is CountryLoaded) {
      emit(
        CountryLoaded(
          _buildCountryList(),
          currentState.favorites,
          sortOption: _sortOption,
        ),
      );
    }
  }

  Future<void> setSortOption(CountrySortOption option) async {
    _sortOption = option;

    if (_allCountries.isEmpty) {
      await loadCountries();
      return;
    }

    final currentState = state;
    if (currentState is CountryLoaded) {
      emit(
        CountryLoaded(
          _buildCountryList(),
          currentState.favorites,
          sortOption: _sortOption,
        ),
      );
    }
  }

  /// Toggles favorite status for a country
  /// Parameters: cca2 - The country code to toggle
  /// Updates the UI immediately with new favorite status
  Future<void> toggleFavorite(String cca2) async {
    // Get current state
    final currentState = state;
    
    // Only proceed if we have loaded data
    if (currentState is CountryLoaded) {
      // Toggle favorite in local storage
      await _repository.toggleFavorite(cca2);
      
      // Reload favorites from storage
      final favorites = await _repository.getFavorites();
      
      // Emit updated state with same countries but new favorites
      // This triggers UI rebuild to show/hide heart icon
      emit(
        CountryLoaded(
          currentState.countries,
          favorites,
          sortOption: _sortOption,
        ),
      );
    }
  }

  List<CountrySummary> _buildCountryList() {
    final query = _searchQuery.toLowerCase();
    final filtered = _allCountries
        .where((country) => country.name.toLowerCase().contains(query))
        .toList();

    if (_sortOption == CountrySortOption.name) {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    } else if (_sortOption == CountrySortOption.population) {
      filtered.sort((a, b) => b.population.compareTo(a.population));
    }
    // If _sortOption is none, don't sort - keep original order

    return filtered;
  }
}
