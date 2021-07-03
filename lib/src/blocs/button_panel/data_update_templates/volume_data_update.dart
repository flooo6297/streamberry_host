import 'package:streamberry_host/src/blocs/button_panel/data_update_templates/data_update_template.dart';

import 'dart:ffi' as ffi;
import 'dart:io' show Platform;

class VolumeDataUpdate extends DataUpdateTemplate {

  final ffi.DynamicLibrary volumeLib = ffi.DynamicLibrary.open(Platform.script
      .resolve('build/windows/volume_library/Debug/volume.dll')
  //.resolve('data/volume_get.dll')
      .toFilePath(windows: true));

  @override
  Future<MapEntry<String, String>> getUpdate() async {
    final int Function() getVolume = volumeLib
        .lookup<ffi.NativeFunction<ffi.Uint32 Function()>>("volume_get")
        .asFunction();

    return MapEntry(type, '${getVolume()/100}');

  }

  @override
  // TODO: implement type
  String get type => 'volume';

}