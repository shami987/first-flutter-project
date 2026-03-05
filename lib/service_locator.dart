import 'package:get_it/get_it.dart';
import 'data/datasources/country_api_client.dart';
import 'data/repositories/country_repository.dart';
import 'blocs/country_cubit.dart';
import 'blocs/theme_cubit.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<CountryApiClient>(() => CountryApiClient());
  getIt.registerLazySingleton<CountryRepository>(() => CountryRepository(getIt<CountryApiClient>()));
  getIt.registerFactory<CountryCubit>(() => CountryCubit(getIt<CountryRepository>()));
  getIt.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
}
