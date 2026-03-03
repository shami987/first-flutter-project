import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/country_cubit.dart';
import '../blocs/country_state.dart';
import '../widgets/country_list_item.dart';
import '../widgets/country_list_shimmer.dart';
import 'favorites_screen.dart';
import 'country_detail_screen.dart';

/// Main screen with country list, search, and navigation
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Track which tab is selected (0 = Home, 1 = Favorites)
  int _selectedIndex = 0;
  
  // Controller for search text field
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load countries when screen first appears
    context.read<CountryCubit>().loadCountries();
  }

  @override
  void dispose() {
    // Clean up controller to prevent memory leaks
    _searchController.dispose();
    super.dispose();
  }

  /// Called when user types in search field
  void _onSearch(String query) {
    context.read<CountryCubit>().searchCountries(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      
      // Show different AppBar based on selected tab
      appBar: _selectedIndex == 0
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'Countries',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Search bar below title (only on Home tab)
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearch, // Trigger search on each keystroke
                    decoration: InputDecoration(
                      hintText: 'Search for a country',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                ),
              ),
            )
          : AppBar(
              // Simple AppBar for Favorites tab
              backgroundColor: Colors.white,
              elevation: 0,
              title: const Text(
                'Favorites',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
      
      // Show different content based on selected tab
      body: _selectedIndex == 0 ? _buildHomeContent() : const FavoritesScreen(),
      
      // Bottom navigation bar
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index), // Switch tabs
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }

  /// Builds the home tab content based on current state
  Widget _buildHomeContent() {
    return BlocBuilder<CountryCubit, CountryState>(
      builder: (context, state) {
        // LOADING STATE: Show shimmer skeleton
        if (state is CountryLoading) {
          return const CountryListShimmer();
        } 
        
        // SUCCESS STATE: Show country list
        else if (state is CountryLoaded) {
          // Empty state: No countries found (search returned nothing)
          if (state.countries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No countries found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }
          
          // Display list of countries
          return ListView.builder(
            itemCount: state.countries.length,
            itemBuilder: (context, index) {
              final country = state.countries[index];
              return CountryListItem(
                country: country,
                // Check if this country is in favorites
                isFavorite: state.favorites.contains(country.cca2),
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
                  // Toggle favorite status when heart icon tapped
                  context.read<CountryCubit>().toggleFavorite(country.cca2);
                },
              );
            },
          );
        } 
        
        // ERROR STATE: Show error message with retry button
        else if (state is CountryError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                const SizedBox(height: 16),
                Text(
                  state.message, // Display error message from state
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                // Retry button to reload countries
                ElevatedButton(
                  onPressed: () => context.read<CountryCubit>().loadCountries(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        // Default: Empty widget (should never reach here)
        return const SizedBox();
      },
    );
  }
}
