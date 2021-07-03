import 'dart:async';

import 'package:streamberry_host/src/blocs/button_panel/data_update_templates/volume_data_update.dart';

abstract class DataUpdateTemplate {
  String get type;
  Future<MapEntry<String, String>> getUpdate();

  static List<DataUpdateTemplate> dataUpdates = [
    VolumeDataUpdate(),
  ];

  static StreamController<Map<String, String>> dataUpdateStream = StreamController.broadcast();

  static bool _running = true;

  static Future<void> getUpdates() async {
    while (_running) {
      Map<String, String> updates = {};
      for (DataUpdateTemplate element in dataUpdates) {
        MapEntry<String, String> update = await element.getUpdate();
        updates[update.key] = update.value;
      }
      dataUpdateStream.sink.add(updates);
      await Future.delayed(Duration(milliseconds: 16));
    }
    return Future.value();
  }

  static void dispose() {
    _running = false;
  }
}