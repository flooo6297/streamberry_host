import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:win32/win32.dart';
import 'package:ffi/ffi.dart';
import 'dart:ffi' as ffi;
import 'dart:io' show Platform;

class SetAudioVolumeAction extends ButtonAction {
  SetAudioVolumeAction(ButtonFunctions parentType) : super(parentType);

  @override
  get actionName => 'setAudioVolumeAction';

  @override
  Widget buildSettings(
          ButtonPanelCubit buttonPanelCubit,
          ButtonData parentButtonData,
          Map<String, String> params,
          Function(Map<String, String> newParams) madeChanges) =>
      _SetAudioVolumeActionSettings(
        buttonPanelCubit,
        parentButtonData,
        params,
        madeChanges,
      );

  @override
  Map<String, String> getDefaultParams() => {'set-volume': '0.5'};

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

    setVolume((double.parse(params['set-volume']??'0.5')*100).round());

    return Future.value();
  }

  @override
  get title => 'Set Volume';

  @override
  get tooltip => 'Set the system volume';
}

class _SetAudioVolumeActionSettings extends StatefulWidget {
  final ButtonPanelCubit buttonPanelCubit;
  final ButtonData parentButtonData;
  final Map<String, String> params;
  final Function(Map<String, String> newParams) madeChanges;

  const _SetAudioVolumeActionSettings(this.buttonPanelCubit,
      this.parentButtonData, this.params, this.madeChanges,
      {Key? key})
      : super(key: key);

  @override
  __SetAudioVolumeActionSettingsState createState() =>
      __SetAudioVolumeActionSettingsState();
}

class __SetAudioVolumeActionSettingsState
    extends State<_SetAudioVolumeActionSettings> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Column(
        children: [
          Text('Volume to set:'),
          Slider(
            min: 0,
            max: 100,
            divisions: 100,
            value: (double.parse(widget.params['set-volume'] ?? '0.5')*100).roundToDouble(),
            label: '${(double.parse(widget.params['set-volume'] ?? '0.5'
            )*100).round()}',
            onChanged: (double value) {
              widget.params['set-volume'] = '${(value/100)}';
              widget.madeChanges(widget.params);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
