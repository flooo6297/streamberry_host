import 'dart:io' show Directory;
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';

import 'plugin_load_result.dart';

class PluginLoader extends StatelessWidget {

  final Widget child;

  const PluginLoader({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PluginLoadResult>(
      future: load(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!.success) {
            return child;
          }
        }
        return Container();
      },
    );
  }

  Future<PluginLoadResult> load() async {

    String pluginFolderName = 'plugins';

    Directory directory = await Directory(path.join(Directory.current.path, pluginFolderName)).create(recursive: true);

    return PluginLoadResult(true);
  }
}
