import 'package:flutter/cupertino.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/audio/audio_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/folder/actions/open_folder_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/folder/folder_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/on_click.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';

import 'button_action.dart';

abstract class ButtonFunctions{
  //List<Function()> actions();

  Map<String, ButtonAction> actions(Map<String, String> params);

  get title;

  get function;

  static Map<String, ButtonFunctions> functions = {
    FolderFunctions().function: FolderFunctions(),
    AudioFunctions().function: AudioFunctions(),
  };

  static Future<void> runActions(ButtonData buttonData, ButtonPanelCubit buttonPanelCubit) async {
    List<ButtonAction> allActions = getActions(buttonData);
    for (var action in allActions) {
      action.runFunction(buttonPanelCubit);
    }
  }

  static Future<void> runActionsFromOnClicks(List<OnClick> onClicks, ButtonPanelCubit buttonPanelCubit) async {
    List<ButtonAction> allActions = getActionsFromOnClicks(onClicks);
    for (var action in allActions) {
      action.runFunction(buttonPanelCubit);
    }
  }

  static List<ButtonAction> getActions(ButtonData buttonData) {

    List<ButtonAction> toReturn = [];

    for (OnClick onClick in buttonData.onClicks) {
      if (ButtonFunctions.functions.containsKey(onClick.function)) {
        if (ButtonFunctions.functions[onClick.function]!.actions(onClick.params).containsKey(onClick.action)) {
          toReturn.add(ButtonFunctions.functions[onClick.function]!.actions(onClick.params)[onClick.action]!);
        }
      }
    }

    return toReturn;
  }

  static List<ButtonAction> getActionsFromOnClicks(List<OnClick> onClicks) {

    List<ButtonAction> toReturn = [];

    for (OnClick onClick in onClicks) {
      if (ButtonFunctions.functions.containsKey(onClick.function)) {
        if (ButtonFunctions.functions[onClick.function]!.actions(onClick.params).containsKey(onClick.action)) {
          toReturn.add(ButtonFunctions.functions[onClick.function]!.actions(onClick.params)[onClick.action]!);
        }
      }
    }

    return toReturn;
  }

}