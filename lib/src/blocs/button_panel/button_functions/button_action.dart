import 'package:flutter/material.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/on_click.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/param_value.dart';
import 'package:uuid/uuid.dart';

import '../button_panel_cubit.dart';

abstract class ButtonAction {

  get title;
  get tooltip;

  get actionName;

  ButtonFunctions getParentType();

  String uuid = const Uuid().v1();

  void setParams(Map<String, String> params);
  Map<String, String> getParams();

  Future<void> runFunction(BuildContext context);

  bool isVisible(BuildContext context);

  Widget buildSettings(BuildContext context, ButtonData parentButtonData);

  OnClick toOnClick() {
    return OnClick(getParentType().function, actionName, params: getParams());
  }

}