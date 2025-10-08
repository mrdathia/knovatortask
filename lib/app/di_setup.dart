import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'core/utils/api_service.dart';
import 'core/utils/session_cache.dart';

final getIt = GetIt.instance;
final _apiModule = ApiModule();
/// Configures all the dependencies for the application.
/// This function bootstraps the Dependency Injection (DI) container
/// by registering core services, APIs, repositories, and use cases.
///
/// The registration strategy differs per category:
/// - Core services: Typically `lazySingleton` (shared instances, heavy to initialize)
/// - APIs: Usually `singleton` (shared network clients, always reused)
/// - Repositories: `lazySingleton` (reuse instances, but only create when required)
/// - Use cases: Often `factory` (lightweight, short-lived objects, created on demand)
///
/// Call this once in main()
Future<void> configureDependencies() async {
  _registerCore();
}

void _registerCore() {
  getIt.registerLazySingleton<http.Client>(() => _apiModule.client);

  getIt.registerLazySingleton<SessionStorageService>(() => SessionStorageService());

  getIt.registerLazySingleton<ApiService>(() => _apiModule.apiService(getIt<http.Client>()));
}