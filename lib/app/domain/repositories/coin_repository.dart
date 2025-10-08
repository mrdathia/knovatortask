abstract class CoinRepository {
  /// Fetches the complete list of available coins.
  Future<List<Map<String, dynamic>>> fetchCoinList();

  /// Fetches the latest USD price of a given coin by its [coinId].
  Future<double?> fetchPrice(String coinId);
}
