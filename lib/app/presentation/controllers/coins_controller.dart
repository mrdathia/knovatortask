import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
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

  Timer? _priceTimer;
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
    _startPeriodicPriceRefresh();
  }

  Future<void> fetchCoinList() async {
    try {
      isLoadingCoins.value = true;
      coins.value = await fetchCoinListUseCase.call(null);
    } finally {
      isLoadingCoins.value = false;
    }
  }

  Future<double?> fetchPrice(String id) async {
    try {
      return await fetchCoinPriceUseCase.call(id);
    } catch (e) {
      log("Error r");
      log(e.toString());
      if (e.toString().contains('429')) {
        Get.snackbar(
          'Rate Limit Exceeded',
          'Too many requests. Please wait a few seconds and try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.black,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to fetch price: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
      return null;
    }
  }

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

  Future<void> removeCoin(String id) async {
    portfolio.removeWhere((e) => e['id'] == id);
    await savePortfolio();
    portfolio.refresh();
  }

  void removeCoinBySwipe(String id) {
    removeCoin(id);
  }

  Future<void> refreshAllPrices() async {
    if (portfolio.isEmpty) return;

    try {
      isLoadingPrices.value = true;
      bool updated = false;

      for (var coin in portfolio) {
        final newPrice = await fetchCoinPriceUseCase.call(coin['id']);
        if (newPrice != null && coin['price'] != newPrice) {
          coin['price'] = newPrice;
          updated = true;
        }
      }

      if (updated) {
        await savePortfolio();
        portfolio.refresh();

        // Show toast only if prices actually changed
        Get.snackbar(
          'Prices Updated',
          'Your portfolio prices have been refreshed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 1),
        );
      }
    } catch(e){
      log("Error r");
      log(e.toString());
      // log(e[""]);
    }
    finally {
      isLoadingPrices.value = false;
    }
  }

  void _startPeriodicPriceRefresh() {
    _priceTimer?.cancel();
    _priceTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
      if (portfolio.isNotEmpty) {
        await refreshAllPrices();
      }
    });
  }

  double get totalValue => portfolio.fold(0.0, (sum, e) => sum + ((e['price'] ?? 0.0) * (e['quantity'] ?? 0.0)));

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

  @override
  void onClose() {
    _priceTimer?.cancel();
    super.onClose();
  }
}
