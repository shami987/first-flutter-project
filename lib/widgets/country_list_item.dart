import 'package:flutter/material.dart';
import '../models/country_summary.dart';
import '../utils/format_utils.dart';

/// Reusable widget for displaying a country in a list
/// Shows flag, name, capital/population, and favorite button
class CountryListItem extends StatelessWidget {
  final CountrySummary country;      // Country data to display
  final bool isFavorite;             // Whether this country is favorited
  final VoidCallback onTap;          // Callback when item is tapped
  final VoidCallback onFavoriteToggle; // Callback when heart icon is tapped
  final bool showCapital;            // Whether to show capital instead of population

  const CountryListItem({
    super.key,
    required this.country,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
    this.showCapital = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // Make entire item tappable
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Country flag image with Hero animation
            Hero(
              tag: 'flag_${country.cca2}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4), // Rounded corners
                child: Image.network(
                  country.flag,
                  width: 56,
                  height: 40,
                  fit: BoxFit.cover, // Fill the box while maintaining aspect ratio
                  // Error handler: Show placeholder if image fails to load
                  errorBuilder: (_, __, ___) => Container(
                    width: 56,
                    height: 40,
                    color: Colors.grey[300],
                    child: const Icon(Icons.flag, size: 20),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16), // Spacing between flag and text
            
            // Country name and population (takes remaining space)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Country name
                  Text(
                    country.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  // Show capital or population based on showCapital flag
                  Text(
                    showCapital 
                        ? 'Capital: ${country.capital}'
                        : 'Population: ${FormatUtils.formatPopulation(country.population)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Favorite button (heart icon)
            IconButton(
              icon: Icon(
                // Show filled heart if favorited, outline if not
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: onFavoriteToggle, // Toggle favorite on tap
            ),
          ],
        ),
      ),
    );
  }
}
