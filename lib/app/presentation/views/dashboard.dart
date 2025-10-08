import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knovatortask/app/core/utils/constants.dart';

import '../../di_setup.dart';
import '../controllers/coins_controller.dart';
import 'coins_search_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final PortfolioController controller = getIt<PortfolioController>();
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Start auto price update every 5 seconds
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      if (controller.portfolio.isNotEmpty) {
        await controller.refreshAllPrices();
        // Show toast when updated
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
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = getIt<PortfolioController>();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Your Coins PortFolio"),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CoinsSearchPage()));
            },
            child: const Padding(padding: EdgeInsets.symmetric(horizontal: 12.0), child: Icon(Icons.search)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Portfolio Summary
          Obx(() {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width * 0.96,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16), // Rounded corners
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Your Market Value", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    "\$${controller.totalValue.toStringAsFixed(AppUtilConstants.totalPrecision)}",
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          // Coins List
          Expanded(
            child: Obx(() {
              if (controller.portfolio.isEmpty) {
                return const Center(child: Text("No coins added yet"));
              }

              return RefreshIndicator(
                onRefresh: controller.refreshAllPrices,
                child: ListView.builder(
                  itemCount: controller.portfolio.length,
                  itemBuilder: (context, index) {
                    final coin = controller.portfolio[index];

                    return Dismissible(
                      key: ValueKey(coin['id']),
                      direction: DismissDirection.endToStart, // swipe left to delete
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) {
                        controller.removeCoin(coin['id']);
                        Get.snackbar(
                          'Removed',
                          '${coin['name']} removed from portfolio',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.black87,
                          colorText: Colors.white,
                          margin: const EdgeInsets.all(16),
                          duration: const Duration(seconds: 1),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: CircleAvatar(child: Text(coin['symbol']?.toUpperCase() ?? '?')),
                          title: Text(coin['name'] ?? 'Unknown'),
                          subtitle: Text(
                            "Quantity: ${coin['quantity'] ?? 0} • Price: \$${(coin['price'] ?? 0).toStringAsFixed(2)}",
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
