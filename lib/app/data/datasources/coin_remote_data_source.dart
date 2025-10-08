import '../../core/constants/api_constants.dart';
import '../../core/utils/api_service.dart';

abstract class CoinRemoteDataSource {
  Future<List<Map<String, dynamic>>> fetchCoinList();

  Future<double?> fetchPrice(String coinId);
}

class CoinRemoteDataSourceImpl implements CoinRemoteDataSource {
  final ApiService apiService;

  CoinRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<Map<String, dynamic>>> fetchCoinList() async {
    final response = await apiService.getRequest(ApiConstants.coinsList, {});
    if (response['success'] == true) {
      final List data = response['response'];
      return data.map((e) => {'id': e['id'], 'symbol': e['symbol'], 'name': e['name']}).toList();
    }
    throw Exception(response['error']);
  }

  @override
  Future<double?> fetchPrice(String coinId) async {
    final response = await apiService.getRequest("${ApiConstants.simplePrice}?ids=$coinId&vs_currencies=usd", {});

    if (response['success'] == true) {
      final data = response['response'];
      return (data[coinId]?['usd'] as num?)?.toDouble();
    }
    throw Exception(response['error']);
  }
}
