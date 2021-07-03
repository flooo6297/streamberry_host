import 'package:flutter/cupertino.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/audio/audio_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/folder/folder_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/keyboard/keyboard_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/obs/obs_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/on_click.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/default_button.dart';

import 'button_action.dart';

abstract class ButtonFunctions {
  //List<Function()> actions();

  Map<String, ButtonAction> actions();

  get title;

  get function;

  static Map<String, ButtonFunctions> functions = <ButtonFunctions>[
    FolderFunctions(),
    AudioFunctions(),
    ObsFunctions(),
    KeyboardFunctions(),
  ].asMap().map((key, value) => MapEntry(value.function as String, value));

  static Future<void> runActionsFromOnClicks(
      List<OnClick> onClicks, ButtonPanelCubit buttonPanelCubit) async {
    List<MapEntry<ButtonAction, OnClick>> allActions = getActionsFromOnClicks(onClicks);

    for (MapEntry<ButtonAction, OnClick> entry in allActions) {
      await entry.key.runFunction(buttonPanelCubit, entry.value.params);
    }

    return Future.value();
  }

  static List<MapEntry<ButtonAction, OnClick>> getActions(ButtonData buttonData) {

    if (buttonData.buttonType is DefaultButton) {
      return getActionsFromOnClicks((buttonData.buttonType as DefaultButton).onClicks);
    }
    return [];

  }

  static List<MapEntry<ButtonAction, OnClick>> getActionsFromOnClicks(List<OnClick> onClicks) {
    List<MapEntry<ButtonAction, OnClick>> toReturn = [];

    for (OnClick onClick in onClicks) {
      if (ButtonFunctions.functions.containsKey(onClick.function)) {
        if (ButtonFunctions.functions[onClick.function]!
            .actions()
            .containsKey(onClick.action)) {
          toReturn.add(MapEntry(ButtonFunctions.functions[onClick.function]!
              .actions()[onClick.action]!, onClick));
        }
      }
    }

    return toReturn;
  }
}
