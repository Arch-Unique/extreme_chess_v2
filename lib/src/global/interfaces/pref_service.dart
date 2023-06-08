import 'package:flutter/foundation.dart';

abstract class PrefService {
  Future<void> save(String key, dynamic value);
  Future<void> eraseAllExcept(String key);
  Future<void> saveAll(Map<String, dynamic> maps);
  void listenToKey(String key, ValueSetter callback);
  T? get<T>(String key);
}
