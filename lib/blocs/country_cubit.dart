import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/country_repository.dart';
import 'country_state.dart';

/// Cubit for managing country list state and business logic
/// Handles loading, searching, and favorite operations
class CountryCubit extends Cubit<CountryState> {
  // Repository for data operations
  final CountryRepository _repository;

  // Constructor: Starts with CountryInitial state
  CountryCubit(this._repository) : super(CountryInitial());

  /// Loads all countries from the API
  /// Emits: CountryLoading -> CountryLoaded or CountryError
  Future<void> loadCountries() async {
    // Emit loading state to show shimmer UI
    emit(CountryLoading());
    
    try {
      // Fetch countries from API
      final countries = await _repository.getAllCountries();
      
      // Load favorites from local storage
      final favorites = await _repository.getFavorites();
      
      // Emit success state with data
      emit(CountryLoaded(countries, favorites));
    } catch (e) {
      // Emit error state with user-friendly message
      emit(CountryError('Failed to load countries. Please try again.'));
    }
  }

  /// Searches for countries by name
  /// Parameters: query - The search term entered by user
  /// Emits: CountryLoading -> CountryLoaded or CountryError
  Future<void> searchCountries(String query) async {
    // If search is empty, reload all countries
    if (query.isEmpty) {
      loadCountries();
      return;
    }
    
    // Emit loading state
    emit(CountryLoading());
    
    try {
      // Search countries via API
      final countries = await _repository.searchCountries(query);
      
      // Load favorites
      final favorites = await _repository.getFavorites();
      
      // Emit success state with search results
      emit(CountryLoaded(countries, favorites));
    } catch (e) {
      // Emit error state for no results
      emit(CountryError('No countries found. Try a different search.'));
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
      emit(CountryLoaded(currentState.countries, favorites));
    }
  }
}
