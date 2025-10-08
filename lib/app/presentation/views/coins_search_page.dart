import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/coins_controller.dart';
import 'coins_detail_bottomsheet.dart';

class CoinsSearchPage extends StatefulWidget {
  const CoinsSearchPage({super.key});

  @override
  State<CoinsSearchPage> createState() => _CoinsSearchPageState();
}

class _CoinsSearchPageState extends State<CoinsSearchPage> {
  final TextEditingController _controller = TextEditingController();
  final coinsController = Get.find<PortfolioController>();
  List<Map<String, dynamic>> filteredCoins = [];

  @override
  void initState() {
    super.initState();
    filteredCoins = coinsController.coins.value;
    _controller.addListener(_filterCoins);
  }

  void _filterCoins() {
    final query = _controller.text.toLowerCase();
    setState(() {
      filteredCoins = coinsController.coins
          .where((coin) =>
      coin['name']!.toLowerCase().contains(query) ||
          coin['symbol']!.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> _showCoinBottomSheet(Map<String, dynamic> coin) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return CoinDetailSheet(coin: coin);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            hintText: 'Search coins...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Obx(() {
          if (coinsController.isLoadingCoins.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: filteredCoins.length,
            itemBuilder: (context, index) {
              final coin = filteredCoins[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text(coin['name'] ?? ''),
                  subtitle: Text(coin['symbol'] ?? ''),
                  onTap: () => _showCoinBottomSheet(coin),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
