import 'dart:io';

import 'package:flutter/material.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/audio/audio_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:win32/win32.dart';
import 'dart:ffi' as ffi;
import 'dart:io' show Platform;

import 'package:ffi/ffi.dart';

class MuteAudioAction extends ButtonAction {
  @override
  get actionName => 'muteAudioAction';

  // ignore: non_constant_identifier_names
  final VK_VOLUME_MUTE = 0xAD;

  @override
  Widget buildSettings(ButtonPanelCubit buttonPanelCubit,
      ButtonData parentButtonData, Function(ButtonAction newAction) madeChanges) {
    ffi.DynamicLibrary volumeLib = ffi.DynamicLibrary.open(Platform.script
        .resolve('build/windows/volume_library/Debug/volume.dll')
        //.resolve('data/volume_get.dll')
        .toFilePath(windows: true));

    final int Function() getVolume = volumeLib
        .lookup<ffi.NativeFunction<ffi.Uint32 Function()>>("volume_get")
        .asFunction();

    final int Function() getMute = volumeLib
        .lookup<ffi.NativeFunction<ffi.Uint8 Function()>>("mute_get")
        .asFunction();

    bool muted = getMute() != 0;

    int currentVol = getVolume();

    return SizedBox(
      height: 50,
      child: Center(
        child: TextButton(
          onPressed: () {
            runFunction(buttonPanelCubit);
          },
          child: Text('Mute/Unmute   $currentVol    $muted'),
        ),
      ),
    );
  }

  @override
  Map<String, String> getParams() => {};

  @override
  ButtonFunctions getParentType() => AudioFunctions();

  @override
  bool isVisible(BuildContext context) => true;

  @override
  Future<void> runFunction(ButtonPanelCubit buttonPanelCubit) async {
    final kbd = calloc<INPUT>();
    kbd.ref.type = INPUT_KEYBOARD;
    kbd.ki.wVk = VK_VOLUME_MUTE;
    var result = SendInput(1, kbd, ffi.sizeOf<INPUT>());
    free(kbd);

    buttonPanelCubit.refresh();

    return Future.value();
  }

  @override
  void setParams(Map<String, String> params) {}

  @override
  get title => 'Mute/Unmute Audio';

  @override
  get tooltip => 'Toggles the system audio';
}
