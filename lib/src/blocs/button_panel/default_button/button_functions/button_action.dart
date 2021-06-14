import 'package:flutter/material.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/on_click.dart';

import '../../button_panel_cubit.dart';

abstract class ButtonAction {
  ButtonAction(this.parentType);

  ButtonFunctions parentType;

  get title;

  get tooltip;

  get actionName;

  ButtonFunctions getParentType() => parentType;

  Future<void> runFunction(
      ButtonPanelCubit buttonPanelCubit, Map<String, String> params);

  bool isVisible(ButtonPanelCubit buttonPanelCubit);

  Widget buildSettings(
      ButtonPanelCubit buttonPanelCubit,
      ButtonData parentButtonData,
      Map<String, String> params,
      Function(Map<String, String> newParams) madeChanges);

  Map<String, String> getDefaultParams();

  OnClick toOnClick() {
    return OnClick(getParentType().function, actionName, params: getDefaultParams());
  }
}
