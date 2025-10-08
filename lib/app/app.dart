import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:knovatortask/app/presentation/controllers/coins_controller.dart';
import 'package:knovatortask/app/presentation/views/dashboard.dart';
import 'package:knovatortask/app/presentation/views/splash.dart';

import 'di_setup.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller from DI
    final portfolioController = getIt<PortfolioController>();
    Get.put(portfolioController); // Make it available globally

    return GetMaterialApp(key: const ValueKey('MyApp'), debugShowCheckedModeBanner: false, home: const SplashScreen());
  }
}
