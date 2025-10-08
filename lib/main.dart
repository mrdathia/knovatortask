import 'package:flutter/material.dart';

import 'app/app.dart';
import 'app/core/utils/storage_service.dart';
import 'app/di_setup.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await configureDependencies();
  await initiateServices();

  runApp(const MyApp());
}

Future<void> initiateServices() async {
  await getIt<StorageService>().initializeStorage();
}
