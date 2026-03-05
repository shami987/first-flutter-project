import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/country_cubit.dart';
import '../blocs/country_state.dart';
import '../blocs/theme_cubit.dart';
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
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<CountryCubit>().loadCountries();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<CountryCubit>().searchCountries(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
              title: const Text(
                'Countries',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                BlocBuilder<CountryCubit, CountryState>(
                  builder: (context, state) {
                    final selectedSort = state is CountryLoaded
                        ? state.sortOption
                        : CountrySortOption.name;

                    return PopupMenuButton<CountrySortOption>(
                      icon: const Icon(Icons.sort),
                      tooltip: 'Sort countries',
                      initialValue: selectedSort,
                      onSelected: (option) {
                        context.read<CountryCubit>().setSortOption(option);
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: CountrySortOption.name,
                          child: Text('Sort by name'),
                        ),
                        PopupMenuItem(
                          value: CountrySortOption.population,
                          child: Text('Sort by population'),
                        ),
                      ],
                    );
                  },
                ),
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, themeMode) {
                    return IconButton(
                      icon: Icon(context.read<ThemeCubit>().themeIcon),
                      onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                    );
                  },
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(60),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearch,
                    decoration: InputDecoration(
                      hintText: 'Search for a country',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceVariant,
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
              title: const Text(
                'Favorites',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              actions: [
                BlocBuilder<ThemeCubit, ThemeMode>(
                  builder: (context, themeMode) {
                    return IconButton(
                      icon: Icon(context.read<ThemeCubit>().themeIcon),
                      onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                    );
                  },
                ),
              ],
            ),
      
      body: _selectedIndex == 0 ? _buildHomeContent() : const FavoritesScreen(),
      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
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

  Widget _buildHomeContent() {
    return BlocBuilder<CountryCubit, CountryState>(
      builder: (context, state) {
        if (state is CountryLoading) {
          return const CountryListShimmer();
        } 
        
        else if (state is CountryLoaded) {
          if (state.countries.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off, 
                    size: 64, 
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No countries found',
                    style: TextStyle(
                      fontSize: 18, 
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }
          
          return RefreshIndicator(
            onRefresh: () async {
              context.read<CountryCubit>().loadCountries();
            },
            child: ListView.builder(
              itemCount: state.countries.length,
              itemBuilder: (context, index) {
                final country = state.countries[index];
                return CountryListItem(
                  country: country,
                  isFavorite: state.favorites.contains(country.cca2),
                  onTap: () {
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
                    context.read<CountryCubit>().toggleFavorite(country.cca2);
                  },
                );
              },
            ),
          );
        } 
        
        else if (state is CountryError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline, 
                  size: 64, 
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16),
                Text(
                  state.message,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.read<CountryCubit>().loadCountries(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
        
        return const SizedBox();
      },
    );
  }
}
