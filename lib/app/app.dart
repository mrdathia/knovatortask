import 'package:flutter/material.dart';
import 'package:knovatortask/app/presentation/views/dashboard.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(key: const ValueKey('MyApp'), debugShowCheckedModeBanner: false, home: const Dashboard());
  }
}

