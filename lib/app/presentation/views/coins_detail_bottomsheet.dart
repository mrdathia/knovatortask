import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../di_setup.dart';
import '../controllers/coins_controller.dart';

class CoinDetailSheet extends StatefulWidget {
  final Map<String, dynamic> coin;

  const CoinDetailSheet({super.key, required this.coin});

  @override
  State<CoinDetailSheet> createState() => _CoinDetailSheetState();
}

class _CoinDetailSheetState extends State<CoinDetailSheet> {
  final PortfolioController controller = getIt<PortfolioController>();
  final TextEditingController quantityController = TextEditingController();
  double? price;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchPrice();
  }

  Future<void> _fetchPrice() async {
    setState(() => loading = true);
    try {
      price = await controller.fetchPrice(widget.coin['id']);
    } catch (e) {
      price = null;
    } finally {
      setState(() => loading = false);
    }
  }

  void _addCoin() async {
    final qty = double.tryParse(quantityController.text);
    if (qty == null || qty <= 0 || price == null) {
      Get.snackbar('Invalid', 'Please enter a valid quantity');
      return;
    }

    await controller.addOrUpdateCoin(
      id: widget.coin['id'],
      name: widget.coin['name'],
      symbol: widget.coin['symbol'],
      quantity: qty,
      price: price!,
    );

    if (mounted) Navigator.of(context).pop(); // Close bottom sheet
  }

  @override
  Widget build(BuildContext context) {
    final coin = widget.coin;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 16, left: 16, right: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with close icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(coin['name'] ?? '', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ],
          ),
          const SizedBox(height: 10),

          if (loading)
            const Center(child: CircularProgressIndicator())
          else if (price == null)
            const Center(child: Text('Failed to fetch price'))
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Current Price: \$${price!.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 20),
                TextField(
                  controller: quantityController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (quantityController.text.isEmpty) ? Colors.grey : Colors.blue,
                    ),
                    onPressed: quantityController.text.isEmpty ? null : _addCoin,
                    child: const Text("Add"),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }
}
