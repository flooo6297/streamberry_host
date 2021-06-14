import 'package:flutter/material.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';

class ButtonSettings extends StatefulWidget {
  final ButtonPanelCubit buttonPanelCubit;

  final String selectedId;

  const ButtonSettings(this.buttonPanelCubit, {this.selectedId = '', Key? key})
      : super(key: key);

  @override
  State<ButtonSettings> createState() => _ButtonSettingsState();
}

class _ButtonSettingsState extends State<ButtonSettings> {
  @override
  Widget build(BuildContext context) {
    if (widget.buttonPanelCubit.getState().selectedButton != null) {
      ButtonData buttonData =
          widget.buttonPanelCubit.getState().selectedButton!;
      if (buttonData.defaultButton != null) {
        return buttonData.defaultButton!.buildSettings(
            widget.buttonPanelCubit, buttonData, widget.selectedId);
      }
    }
    return Container();
  }
}
