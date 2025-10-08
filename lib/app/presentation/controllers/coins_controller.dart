import 'dart:convert';

import 'package:get/get.dart';

import '../../core/utils/storage_service.dart';
import '../../domain/usecases/fetch_coin_price.dart';
import '../../domain/usecases/fetch_coins_list.dart';

class PortfolioController extends GetxController {
  final StorageService storageService;
  final FetchCoinListUseCase fetchCoinListUseCase;
  final FetchCoinPriceUseCase fetchCoinPriceUseCase;

  PortfolioController({
    required this.storageService,
    required this.fetchCoinListUseCase,
    required this.fetchCoinPriceUseCase,
  });

  var isLoadingCoins = false.obs;
  var isLoadingPrices = false.obs;
  var coins = <Map<String, dynamic>>[].obs;
  var portfolio = <Map<String, dynamic>>[].obs;
  var searchResults = <Map<String, dynamic>>[].obs;

  final String _portfolioKey = 'user_portfolio';

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  Future<void> _initialize() async {
    await storageService.initializeStorage();
    await loadPortfolio();
    await fetchCoinList();
  }

  /// ==== Fetch coin list via use case ====
  Future<void> fetchCoinList() async {
    try {
      isLoadingCoins.value = true;
      coins.value = await fetchCoinListUseCase.call(null);
      searchResults.value = coins;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch coins');
    } finally {
      isLoadingCoins.value = false;
    }
  }

  /// ==== Search coins ====
  void searchCoins(String query) {
    if (query.isEmpty) {
      searchResults.value = coins;
      return;
    }
    final lower = query.toLowerCase();
    searchResults.value = coins
        .where((c) => c['name'].toLowerCase().contains(lower) || c['symbol'].toLowerCase().contains(lower))
        .toList();
  }

  /// ==== Fetch coin price via use case ====
  Future<double?> fetchPrice(String id) async {
    try {
      return await fetchCoinPriceUseCase.call(id);
    } catch (_) {
      return null;
    }
  }

  /// ==== Add or update portfolio entry ====
  Future<void> addOrUpdateCoin({
    required String id,
    required String name,
    required String symbol,
    required double quantity,
    required double price,
  }) async {
    final index = portfolio.indexWhere((e) => e['id'] == id);
    if (index != -1) {
      portfolio[index]['quantity'] += quantity;
    } else {
      portfolio.add({'id': id, 'name': name, 'symbol': symbol, 'quantity': quantity, 'price': price});
    }
    await savePortfolio();
    portfolio.refresh();
  }

  /// ==== Remove coin ====
  Future<void> removeCoin(String id) async {
    portfolio.removeWhere((e) => e['id'] == id);
    await savePortfolio();
  }

  /// ==== Total portfolio value ====
  double get totalValue => portfolio.fold(0.0, (sum, e) => sum + ((e['price'] ?? 0.0) * (e['quantity'] ?? 0.0)));

  /// ==== Refresh all prices via use case ====
  Future<void> refreshAllPrices() async {
    if (portfolio.isEmpty) return;
    try {
      isLoadingPrices.value = true;
      for (var coin in portfolio) {
        final price = await fetchCoinPriceUseCase.call(coin['id']);
        if (price != null) coin['price'] = price;
      }
      await savePortfolio();
      portfolio.refresh();
    } finally {
      isLoadingPrices.value = false;
    }
  }

  /// ==== Storage ====
  Future<void> savePortfolio() async {
    final encoded = jsonEncode(portfolio);
    await storageService.saveValue(_portfolioKey, encoded);
  }

  Future<void> loadPortfolio() async {
    final data = await storageService.getValue(_portfolioKey);
    if (data != null) {
      portfolio.value = List<Map<String, dynamic>>.from(jsonDecode(data));
    }
  }
}
