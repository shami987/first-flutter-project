import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Loading skeleton widget with shimmer effect
/// Displayed while countries are being fetched from API
class CountryListShimmer extends StatelessWidget {
  const CountryListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Show 10 placeholder items
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,      // Base color for shimmer
            highlightColor: Colors.grey[100]!, // Highlight color for shimmer effect
            child: Row(
              children: [
                // Placeholder for flag image
                Container(
                  width: 56,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Placeholder for text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Placeholder for country name
                      Container(
                        width: double.infinity,
                        height: 16,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      
                      // Placeholder for population text
                      Container(
                        width: 120,
                        height: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
