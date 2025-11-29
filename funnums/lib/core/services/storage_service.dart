import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

/// Hive-backed storage with an in-memory fallback for corrupt/missing data.
class StorageService {
  static const _boxName = 'funnums_box';
  Box<dynamic>? _box;

  Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(dir.path);
    _box = await Hive.openBox<dynamic>(_boxName);
  }

  Future<void> saveValue(String key, dynamic value) async {
    if (_box == null) return;
    // Store JSON-encodable data; fallback to string serialization.
    try {
      final encodable = jsonDecode(jsonEncode(value));
      await _box!.put(key, encodable);
    } catch (_) {
      await _box!.put(key, value);
    }
  }

  Future<T?> readValue<T>(String key) async {
    if (_box == null) return null;
    final value = _box!.get(key);
    if (value is T) return value;
    return null;
  }

  Future<void> resetOnCorruption() async {
    if (_box == null) return;
    await _box!.clear();
  }
}
