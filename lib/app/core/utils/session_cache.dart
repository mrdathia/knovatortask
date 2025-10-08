import 'dart:developer';

import 'package:get_storage/get_storage.dart';

import 'storage_service.dart';

class SessionStorageService extends StorageService {
  static final SessionStorageService _instance = SessionStorageService._internal();
  final GetStorage _storage = GetStorage();

  SessionStorageService._internal();

  factory SessionStorageService() => _instance;

  @override
  Future<void> initializeStorage() async {
    await GetStorage.init();
    log("Session storage initialized.");
  }

  @override
  void clearStorage() {
    try {
      _storage.erase();
      log("All session storage cleared.");
    } catch (e) {
      log("Failed to clear session storage: $e");
    }
  }

  @override
  Future<void> saveValue(String key, dynamic value) async {
    try {
      await _storage.write(key, value);
      log("Value saved in session storage for key: $key");
    } catch (e) {
      log("Failed to save value in session storage for key $key: $e");
    }
  }

  @override
  dynamic getValue(String key) {
    try {
      return _storage.read(key);
    } catch (e) {
      log("Failed to read value from session storage for key $key: $e");
      return null;
    }
  }

  @override
  void updateValue(String key, dynamic value) {
    try {
      _storage.write(key, value);
      log("Value updated in session storage for key: $key");
    } catch (e) {
      log("Failed to update value in session storage for key $key: $e");
    }
  }

  @override
  void removeValue(String key) {
    try {
      _storage.remove(key);
      log("Value removed from session storage for key: $key");
    } catch (e) {
      log("Failed to remove value from session storage for key $key: $e");
    }
  }

  void logAll() {
    try {
      List<dynamic> allKeys = _storage.getKeys().toList();
      List<dynamic> allValues = _storage.getValues().toList();
      log("Session storage key, value sets:", level: 2000);
      for (int i = 0; i < allKeys.length; i++) {
        log("${allKeys[i]} : ${allValues[i]}", level: 2000);
      }
    } catch (e) {
      log("Failed to log all session storage values: $e");
    }
  }
}
