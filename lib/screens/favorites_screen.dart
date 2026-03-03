import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/country_cubit.dart';
import '../blocs/country_state.dart';
import '../widgets/country_list_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountryCubit, CountryState>(
      builder: (context, state) {
        if (state is CountryLoaded) {
          final favoriteCountries = state.countries
              .where((country) => state.favorites.contains(country.cca2))
              .toList();

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

          return ListView.builder(
            itemCount: favoriteCountries.length,
            itemBuilder: (context, index) {
              final country = favoriteCountries[index];
              return CountryListItem(
                country: country,
                isFavorite: true,
                onTap: () {
                  // Navigate to details screen (to be implemented)
                },
                onFavoriteToggle: () {
                  context.read<CountryCubit>().toggleFavorite(country.cca2);
                },
              );
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
