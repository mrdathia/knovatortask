import '../../core/usecases/use_case.dart';
import '../../domain/repositories/coin_repository.dart';

class FetchCoinPriceUseCase extends UseCase<double?, String> {
  final CoinRepository repository;

  FetchCoinPriceUseCase(this.repository);

  @override
  Future<double?> call(String coinId) async {
    return await repository.fetchPrice(coinId);
  }
}
