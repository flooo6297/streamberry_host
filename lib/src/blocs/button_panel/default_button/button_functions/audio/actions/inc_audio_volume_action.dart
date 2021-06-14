import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'dart:ffi' as ffi;
import 'dart:io' show Platform;

class IncAudioVolumeAction extends ButtonAction {
  IncAudioVolumeAction(ButtonFunctions parentType) : super(parentType);

  @override
  get actionName => 'incAudioVolumeAction';

  @override
  Widget buildSettings(
          ButtonPanelCubit buttonPanelCubit,
          ButtonData parentButtonData,
          Map<String, String> params,
          Function(Map<String, String> newParams) madeChanges) =>
      _IncAudioVolumeActionSettings(
        buttonPanelCubit,
        parentButtonData,
        params,
        madeChanges,
      );

  @override
  Map<String, String> getDefaultParams() => {'inc-steps': '5'};

  @override
  bool isVisible(ButtonPanelCubit buttonPanelCubit) => true;

  @override
  Future<void> runFunction(
      ButtonPanelCubit buttonPanelCubit, Map<String, String> params) async {
    ffi.DynamicLibrary volumeLib = ffi.DynamicLibrary.open(Platform.script
        .resolve('build/windows/volume_library/Debug/volume.dll')
        //.resolve('data/volume_get.dll')
        .toFilePath(windows: true));

    final int Function(int volume) setVolume = volumeLib
        .lookup<ffi.NativeFunction<ffi.Uint32 Function(ffi.Uint32)>>(
            "volume_set")
        .asFunction();

    final int Function() getVolume = volumeLib
        .lookup<ffi.NativeFunction<ffi.Uint32 Function()>>("volume_get")
        .asFunction();

    int volume = getVolume() + int.parse(params['inc-steps']!);

    setVolume(volume > 100 ? 100 : volume);

    return Future.value();
  }

  @override
  get title => 'Increase Volume';

  @override
  get tooltip => 'Increase the system volume';
}

class _IncAudioVolumeActionSettings extends StatefulWidget {
  final ButtonPanelCubit buttonPanelCubit;
  final ButtonData parentButtonData;
  final Map<String, String> params;
  final Function(Map<String, String> newParams) madeChanges;

  const _IncAudioVolumeActionSettings(this.buttonPanelCubit,
      this.parentButtonData, this.params, this.madeChanges,
      {Key? key})
      : super(key: key);

  @override
  __IncAudioVolumeActionSettingsState createState() =>
      __IncAudioVolumeActionSettingsState();
}

class __IncAudioVolumeActionSettingsState
    extends State<_IncAudioVolumeActionSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Column(
        children: [
          Text('Increment steps:'),
          Slider(
            min: 1,
            max: 100,
            divisions: 99,
            value: (int.parse(widget.params['inc-steps'] ?? '5').toDouble()),
            label: widget.params['inc-steps'] ?? '5',
            onChanged: (double value) {
              widget.params['inc-steps'] = '${value.round()}';
              widget.madeChanges(widget.params);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
