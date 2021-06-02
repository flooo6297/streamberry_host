

import 'dart:io' show Platform, Directory;
import 'package:path/path.dart' as path;



import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:streamberry_host/src/app.dart';

void main() async {
  timeDilation = 1.0;

  String hiveDirectory = path.join(Directory.current.path, 'config');

  Hive.init(hiveDirectory);
  await Hive.openBox<String>('images');
  runApp(const App());
}
