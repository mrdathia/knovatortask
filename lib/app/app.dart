import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(key: const ValueKey('MyApp'),
      debugShowCheckedModeBanner: false,
      home: const CoinsPage()
    );
  }
}

class CoinsPage extends StatelessWidget{
  const CoinsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
