import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CoinDetailSheet extends StatefulWidget {
  final Map<String, dynamic> coin;

  const CoinDetailSheet({super.key, required this.coin});

  @override
  State<CoinDetailSheet> createState() => _CoinDetailSheetState();
}

class _CoinDetailSheetState extends State<CoinDetailSheet> {
  double? price;
  bool loading = true;
  final TextEditingController quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPrice();
  }

  Future<void> fetchPrice() async {
    final coinId = widget.coin['id'];
    final url =
        'https://api.coingecko.com/api/v3/simple/price?ids=$coinId&vs_currencies=usd';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          price = (data[coinId]?['usd'] as num?)?.toDouble();
          loading = false;
        });
      } else {
        setState(() => loading = false);
      }
    } catch (e) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final coin = widget.coin;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 16,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with close icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                coin['name'] ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
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
                Text(
                  "Current Price: \$${price!.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: quantityController,
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      (quantityController.text.isEmpty) ? Colors.grey : Colors.blue,
                    ),
                    onPressed: quantityController.text.isEmpty
                        ? null
                        : () {
                      Navigator.pop(context); // close bottom sheet
                      Navigator.pop(context, {
                        "coin": coin,
                        "quantity":
                        double.tryParse(quantityController.text) ?? 0,
                        "price": price,
                      }); // also go back with data
                    },
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
