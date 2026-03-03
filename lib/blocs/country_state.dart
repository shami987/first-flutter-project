import 'package:equatable/equatable.dart';
import '../models/country_summary.dart';

abstract class CountryState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CountryInitial extends CountryState {}

class CountryLoading extends CountryState {}

class CountryLoaded extends CountryState {
  final List<CountrySummary> countries;
  final Set<String> favorites;

  CountryLoaded(this.countries, this.favorites);

  @override
  List<Object?> get props => [countries, favorites];
}

class CountryError extends CountryState {
  final String message;

  CountryError(this.message);

  @override
  List<Object?> get props => [message];
}
