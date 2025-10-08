import 'package:knovatortask/app/core/constants/app_colors.dart';
import 'package:knovatortask/app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.horizontal(left: Radius.circular(24), right: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0, left: 24.0, right: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // App Name
            Text(AppStrings.appName, style: Theme.of(context).textTheme.bodyMedium),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
