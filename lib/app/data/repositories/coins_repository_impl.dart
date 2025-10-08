import '../../domain/repositories/coin_repository.dart';
import '../datasources/coin_remote_data_source.dart';

class CoinRepositoryImpl implements CoinRepository {
  final CoinRemoteDataSource remoteDataSource;

  CoinRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Map<String, dynamic>>> fetchCoinList() async {
    return await remoteDataSource.fetchCoinList();
  }

  @override
  Future<double?> fetchPrice(String coinId) async {
    return await remoteDataSource.fetchPrice(coinId);
  }
}
