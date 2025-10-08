import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../di_setup.dart';
import '../controllers/coins_controller.dart';
import 'dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final PortfolioController controller = getIt<PortfolioController>();

  @override
  void initState() {
    super.initState();

    // Setup fade animation for subtitle
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.repeat(reverse: true);

    // Load coins list in background
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      await controller.fetchCoinList();
    } catch (_) {
      // Handle error silently or show snackbar if needed
    } finally {
      // After data is fetched, navigate to Dashboard
      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Dashboard()));
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(AppAssets.logo, height: size.height * 0.2),

            const SizedBox(height: 24),

            // Title
            Text(
              AppStrings.appName,
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.darkYellow),
            ),

            const SizedBox(height: 12),

            // Animated Subtitle
            FadeTransition(
              opacity: _fadeAnimation,
              child: Text(
                'Track your crypto portfolio', // You can use another AppStrings constant if you want
                style: TextStyle(fontSize: 18, color: AppColors.subtitleColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
