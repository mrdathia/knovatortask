abstract class CoinRepository {
  Future<List<Map<String, dynamic>>> fetchCoinList();

  Future<double?> fetchPrice(String coinId);
}
