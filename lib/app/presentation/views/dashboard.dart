import 'package:flutter/material.dart';

import 'coins_search_page.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Coins Engage"),
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => CoinsSearchPage()));
            },
            child: Icon(Icons.zoom_in),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(children: [Text("Your Market value"), Text("\$ ${2000}")]),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                const coin = {};
                return Container(
                  child: ListTile(
                    leading: CircleAvatar(child: Text(coin['symbol']!.toUpperCase())),
                    title: Text(coin['name'] ?? 'Title'),
                    subtitle: Text(coin['symbol'] ?? 'price'),
                    trailing: const Icon(Icons.add_circle_rounded),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
