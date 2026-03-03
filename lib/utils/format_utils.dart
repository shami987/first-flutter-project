/// Utility class for formatting data for display
class FormatUtils {
  /// Formats population numbers into readable format
  /// Examples:
  ///   - 1,300,000,000 -> "1.3B" (Billion)
  ///   - 47,100,000 -> "47.1M" (Million)
  ///   - 5,500 -> "5.5K" (Thousand)
  ///   - 500 -> "500" (No formatting)
  static String formatPopulation(int population) {
    // Format billions (1,000,000,000+)
    if (population >= 1000000000) {
      return '${(population / 1000000000).toStringAsFixed(1)}B';
    } 
    // Format millions (1,000,000+)
    else if (population >= 1000000) {
      return '${(population / 1000000).toStringAsFixed(1)}M';
    } 
    // Format thousands (1,000+)
    else if (population >= 1000) {
      return '${(population / 1000).toStringAsFixed(1)}K';
    }
    // Return as-is for small numbers
    return population.toString();
  }
}
