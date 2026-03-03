import 'package:dio/dio.dart';
import '../../models/country_summary.dart';
import '../../models/country_details.dart';

class CountryApiClient {
  final Dio _dio;
  static const String _baseUrl = 'https://restcountries.com/v3.1';

  CountryApiClient() : _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  Future<List<CountrySummary>> getAllCountries() async {
    final response = await _dio.get('/all?fields=name,flags,population,cca2');
    return (response.data as List)
        .map((json) => CountrySummary.fromJson(json))
        .toList();
  }

  Future<List<CountrySummary>> searchCountries(String name) async {
    final response = await _dio.get('/name/$name?fields=name,flags,population,cca2');
    return (response.data as List)
        .map((json) => CountrySummary.fromJson(json))
        .toList();
  }

  Future<CountryDetails> getCountryDetails(String code) async {
    final response = await _dio.get('/alpha/$code?fields=name,flags,population,capital,region,subregion,area,timezones');
    return CountryDetails.fromJson(response.data);
  }
}
