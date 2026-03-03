import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/country_cubit.dart';
import '../blocs/country_state.dart';
import '../widgets/country_list_item.dart';
import 'country_detail_screen.dart';

/// Screen that displays user's favorite countries
/// Filters the main country list to show only favorited items
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Listen to state changes from CountryCubit
    return BlocBuilder<CountryCubit, CountryState>(
      builder: (context, state) {
        // Only show favorites when data is loaded
        if (state is CountryLoaded) {
          // Filter countries to only include those in favorites set
          final favoriteCountries = state.countries
              .where((country) => state.favorites.contains(country.cca2))
              .toList();

          // Empty state: No favorites added yet
          if (favoriteCountries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No favorites yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add countries to your favorites',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          // Display list of favorite countries
          return ListView.builder(
            itemCount: favoriteCountries.length,
            itemBuilder: (context, index) {
              final country = favoriteCountries[index];
              return CountryListItem(
                country: country,
                isFavorite: true, // All items here are favorites
                showCapital: true, // Show capital instead of population
                onTap: () {
                  // Navigate to detail screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CountryDetailScreen(
                        countryCode: country.cca2,
                        countryName: country.name,
                      ),
                    ),
                  );
                },
                onFavoriteToggle: () {
                  // Remove from favorites when heart icon tapped
                  context.read<CountryCubit>().toggleFavorite(country.cca2);
                },
              );
            },
          );
        }
        
        // Return empty widget if state is not loaded
        return const SizedBox();
      },
    );
  }
}
