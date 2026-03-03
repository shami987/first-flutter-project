import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/datasources/country_api_client.dart';
import 'data/repositories/country_repository.dart';
import 'blocs/country_cubit.dart';
import 'screens/home_screen.dart';

/// App entry point
void main() {
  runApp(const MyApp());
}

/// Root widget of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create repository instance to share across app
    final repository = CountryRepository(CountryApiClient());
    
    return MultiRepositoryProvider(
      providers: [
        // Provide repository to entire app
        RepositoryProvider.value(value: repository),
      ],
      child: BlocProvider(
        // Provide CountryCubit to entire app
        create: (context) => CountryCubit(repository),
        child: MaterialApp(
          title: 'Countries',
          debugShowCheckedModeBanner: false, // Remove debug banner
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true, // Use Material Design 3
          ),
          home: const HomeScreen(), // Set home screen as initial route
        ),
      ),
    );
  }
}
