import 'package:equatable/equatable.dart';
import '../models/country_details.dart';

/// Base class for country detail states
abstract class CountryDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state before loading
class CountryDetailInitial extends CountryDetailState {}

/// Loading state while fetching detail data
class CountryDetailLoading extends CountryDetailState {}

/// Success state with country details
class CountryDetailLoaded extends CountryDetailState {
  final CountryDetails country;

  CountryDetailLoaded(this.country);

  @override
  List<Object?> get props => [country];
}

/// Error state when API call fails
class CountryDetailError extends CountryDetailState {
  final String message;

  CountryDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
