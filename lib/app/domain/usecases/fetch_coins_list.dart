import '../../core/usecases/use_case.dart';
import '../../domain/repositories/coin_repository.dart';

class FetchCoinListUseCase extends UseCase<List<Map<String, dynamic>>, void> {
  final CoinRepository repository;

  FetchCoinListUseCase(this.repository);

  @override
  Future<List<Map<String, dynamic>>> call(void params) async {
    return await repository.fetchCoinList();
  }
}
