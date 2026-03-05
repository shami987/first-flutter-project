import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_summary_new.freezed.dart';

@freezed
class CountrySummary with _$CountrySummary {
  const factory CountrySummary({
    required String name,
    required String flag,
    required int population,
    required String cca2,
    required String capital,
  }) = _CountrySummary;

  factory CountrySummary.fromJson(Map<String, dynamic> json) {
    return CountrySummary(
      name: json['name']['common'] ?? '',
      flag: json['flags']['png'] ?? '',
      population: json['population'] ?? 0,
      cca2: json['cca2'] ?? '',
      capital: (json['capital'] as List?)?.isNotEmpty == true ? json['capital'][0] : 'N/A',
    );
  }
}

extension CountrySummaryJson on CountrySummary {
  Map<String, dynamic> toJson() {
    return {
      'name': {'common': name},
      'flags': {'png': flag},
      'population': population,
      'cca2': cca2,
      'capital': capital == 'N/A' ? <dynamic>[] : [capital],
    };
  }
}
