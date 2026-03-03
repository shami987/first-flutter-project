import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/country_repository.dart';
import 'country_state.dart';

class CountryCubit extends Cubit<CountryState> {
  final CountryRepository _repository;

  CountryCubit(this._repository) : super(CountryInitial());

  Future<void> loadCountries() async {
    emit(CountryLoading());
    try {
      final countries = await _repository.getAllCountries();
      final favorites = await _repository.getFavorites();
      emit(CountryLoaded(countries, favorites));
    } catch (e) {
      emit(CountryError('Failed to load countries. Please try again.'));
    }
  }

  Future<void> searchCountries(String query) async {
    if (query.isEmpty) {
      loadCountries();
      return;
    }
    
    emit(CountryLoading());
    try {
      final countries = await _repository.searchCountries(query);
      final favorites = await _repository.getFavorites();
      emit(CountryLoaded(countries, favorites));
    } catch (e) {
      emit(CountryError('No countries found. Try a different search.'));
    }
  }

  Future<void> toggleFavorite(String cca2) async {
    final currentState = state;
    if (currentState is CountryLoaded) {
      await _repository.toggleFavorite(cca2);
      final favorites = await _repository.getFavorites();
      emit(CountryLoaded(currentState.countries, favorites));
    }
  }
}
