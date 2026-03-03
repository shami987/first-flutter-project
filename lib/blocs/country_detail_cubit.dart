import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/country_repository.dart';
import 'country_detail_state.dart';

/// Cubit for managing country detail screen state
class CountryDetailCubit extends Cubit<CountryDetailState> {
  final CountryRepository _repository;

  CountryDetailCubit(this._repository) : super(CountryDetailInitial());

  /// Loads detailed information for a specific country
  /// Parameters: code - The country code (cca2) like 'US', 'IT'
  Future<void> loadCountryDetails(String code) async {
    emit(CountryDetailLoading());
    
    try {
      final details = await _repository.getCountryDetails(code);
      emit(CountryDetailLoaded(details));
    } catch (e) {
      emit(CountryDetailError('Failed to load country details. Please try again.'));
    }
  }
}
