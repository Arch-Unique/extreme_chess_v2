import 'package:extreme_chess_v2/src/global/interfaces/pref_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MyPrefService extends GetxService implements PrefService {
  static final _prefs = GetStorage();

  @override
  T? get<T>(String key) {
    return _prefs.read<T>(key);
  }

  @override
  Future<void> save(String key, value) async {
    await _prefs.write(key, value);
  }

  @override
  Future<void> saveAll(Map<String, dynamic> maps) async {
    for (var element in maps.entries) {
      await _prefs.write(element.key, element.value);
    }
  }

  @override
  Future<void> eraseAllExcept(String key) async {
    final allKeys = List.from(_prefs.getKeys());
    for (var element in allKeys) {
      if (element == key) continue;
      await _prefs.remove(element);
    }
  }

  @override
  listenToKey(String key, ValueSetter callback) {
    _prefs.listenKey(key, (j) {
      callback(j);
    });
  }
}
