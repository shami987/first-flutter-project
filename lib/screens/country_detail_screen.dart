import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/country_detail_cubit.dart';
import '../blocs/country_detail_state.dart';
import '../data/repositories/country_repository.dart';
import '../utils/format_utils.dart';

/// Detail screen showing full country information
class CountryDetailScreen extends StatelessWidget {
  final String countryCode;
  final String countryName;

  const CountryDetailScreen({
    super.key,
    required this.countryCode,
    required this.countryName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Create new Cubit instance for this screen
      create: (context) => CountryDetailCubit(
        context.read<CountryRepository>(),
      )..loadCountryDetails(countryCode),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            countryName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: BlocBuilder<CountryDetailCubit, CountryDetailState>(
          builder: (context, state) {
            // LOADING STATE: Show loading indicator
            if (state is CountryDetailLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            
            // SUCCESS STATE: Show country details
            else if (state is CountryDetailLoaded) {
              final country = state.country;
              
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Large flag image
                    Container(
                      width: double.infinity,
                      height: 240,
                      color: const Color(0xFF7FB5A5),
                      child: Image.network(
                        country.flag,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.flag,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Key Statistics section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Key Statistics',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Area
                          _buildStatRow(
                            'Area',
                            '${country.area.toStringAsFixed(0)} sq km',
                          ),
                          const SizedBox(height: 12),
                          
                          // Population
                          _buildStatRow(
                            'Population',
                            FormatUtils.formatPopulation(country.population),
                          ),
                          const SizedBox(height: 12),
                          
                          // Region
                          _buildStatRow('Region', country.region),
                          const SizedBox(height: 12),
                          
                          // Sub Region
                          _buildStatRow('Sub Region', country.subregion),
                          
                          const SizedBox(height: 32),
                          
                          // Timezone section
                          const Text(
                            'Timezone',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Timezone chips
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: country.timezones.map((tz) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  tz,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              );
                            }).toList(),
                          ),
                          
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            
            // ERROR STATE: Show error with retry
            else if (state is CountryDetailError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context
                            .read<CountryDetailCubit>()
                            .loadCountryDetails(countryCode),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }
            
            return const SizedBox();
          },
        ),
      ),
    );
  }

  /// Builds a statistic row with label and value
  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
