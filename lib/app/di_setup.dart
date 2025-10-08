import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:knovatortask/app/core/utils/session_cache.dart';
import 'package:knovatortask/app/presentation/controllers/coins_controller.dart';

import 'core/utils/api_service.dart';
import 'core/utils/storage_service.dart';
import 'data/datasources/coin_remote_data_source.dart';
import 'data/repositories/coins_repository_impl.dart';
import 'domain/repositories/coin_repository.dart';
import 'domain/usecases/fetch_coin_price.dart';
import 'domain/usecases/fetch_coins_list.dart';

final getIt = GetIt.instance;
final _apiModule = ApiModule();

Future<void> configureDependencies() async {
  _registerCore();
  _registerData();
  _registerUseCases();
  _registerController();
}

void _registerCore() {
  // Storage
  getIt.registerLazySingleton<StorageService>(() => SessionStorageService());

  // API service
  getIt.registerLazySingleton<http.Client>(() => _apiModule.client);
  getIt.registerLazySingleton<ApiService>(() => _apiModule.apiService(getIt<http.Client>()));
}

void _registerData() {
  // Remote data source
  getIt.registerLazySingleton<CoinRemoteDataSource>(() => CoinRemoteDataSourceImpl(getIt<ApiService>()));

  // Repository
  getIt.registerLazySingleton<CoinRepository>(
    () => CoinRepositoryImpl(remoteDataSource: getIt<CoinRemoteDataSource>()),
  );
}

void _registerUseCases() {
  getIt.registerLazySingleton(() => FetchCoinListUseCase(getIt<CoinRepository>()));
  getIt.registerLazySingleton(() => FetchCoinPriceUseCase(getIt<CoinRepository>()));
}

void _registerController() {
  getIt.registerLazySingleton(
    () => PortfolioController(
      storageService: getIt<StorageService>(),
      fetchCoinListUseCase: getIt<FetchCoinListUseCase>(),
      fetchCoinPriceUseCase: getIt<FetchCoinPriceUseCase>(),
    ),
  );
}
