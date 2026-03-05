import 'package:freezed_annotation/freezed_annotation.dart';

part 'country_details_new.freezed.dart';

@freezed
class CountryDetails with _$CountryDetails {
  const factory CountryDetails({
    required String name,
    required String flag,
    required int population,
    required String capital,
    required String region,
    required String subregion,
    required double area,
    required List<String> timezones,
  }) = _CountryDetails;

  factory CountryDetails.fromJson(Map<String, dynamic> json) {
    return CountryDetails(
      name: json['name']['common'] ?? '',
      flag: json['flags']['png'] ?? '',
      population: json['population'] ?? 0,
      capital: (json['capital'] as List?)?.isNotEmpty == true ? json['capital'][0] : 'N/A',
      region: json['region'] ?? '',
      subregion: json['subregion'] ?? '',
      area: (json['area'] ?? 0).toDouble(),
      timezones: List<String>.from(json['timezones'] ?? []),
    );
  }
}

extension CountryDetailsJson on CountryDetails {
  Map<String, dynamic> toJson() {
    return {
      'name': {'common': name},
      'flags': {'png': flag},
      'population': population,
      'capital': capital == 'N/A' ? <dynamic>[] : [capital],
      'region': region,
      'subregion': subregion,
      'area': area,
      'timezones': timezones,
    };
  }
}
