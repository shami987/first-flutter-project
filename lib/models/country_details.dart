import 'package:equatable/equatable.dart';

class CountryDetails extends Equatable {
  final String name;
  final String flag;
  final int population;
  final String capital;
  final String region;
  final String subregion;
  final double area;
  final List<String> timezones;

  const CountryDetails({
    required this.name,
    required this.flag,
    required this.population,
    required this.capital,
    required this.region,
    required this.subregion,
    required this.area,
    required this.timezones,
  });

  factory CountryDetails.fromJson(Map<String, dynamic> json) {
    return CountryDetails(
      name: json['name']['common'] ?? '',
      flag: json['flags']['png'] ?? '',
      population: json['population'] ?? 0,
      capital: (json['capital'] as List?)?.isNotEmpty == true 
          ? json['capital'][0] 
          : 'N/A',
      region: json['region'] ?? '',
      subregion: json['subregion'] ?? '',
      area: (json['area'] ?? 0).toDouble(),
      timezones: List<String>.from(json['timezones'] ?? []),
    );
  }

  @override
  List<Object?> get props => [name, flag, population, capital, region, subregion, area, timezones];
}
