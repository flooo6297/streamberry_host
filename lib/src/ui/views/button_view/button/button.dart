import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_host/src/ui/custom_elements/resize_button.dart';
import 'package:streamberry_host/src/ui/views/button_view/button/defined_button.dart';
import 'package:streamberry_host/src/ui/views/button_view/button/undefined_button.dart';

class Button extends StatelessWidget {
  final ButtonData buttonData;
  final ButtonPanelState buttonPanelState;

  const Button(
    this.buttonData,
    this.buttonPanelState, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (buttonData.canBeOverwritten) {
      return UndefinedButton(buttonData, buttonPanelState, context.read<ButtonPanelCubit>().getState().nonDefinedButtonDesign);
    }
    return DefinedButton(buttonData, buttonPanelState);
  }
}
