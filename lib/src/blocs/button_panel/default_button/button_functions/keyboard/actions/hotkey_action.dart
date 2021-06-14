import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/keyboard/keycodes.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:win32/win32.dart';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';

class HotkeyAction extends ButtonAction {
  HotkeyAction(ButtonFunctions parentType) : super(parentType);

  @override
  get actionName => 'hotkeyAction';

  @override
  Widget buildSettings(
      ButtonPanelCubit buttonPanelCubit,
      ButtonData parentButtonData,
      Map<String, String> params,
      Function(Map<String, String> newParams) madeChanges) {

    //TODO: implement Settings

    return Container(
      height: 50,
    );
  }

  @override
  Map<String, String> getDefaultParams() => {
        'keycodes': jsonEncode([Keycodes.keycodeFromName['L-Win'], Keycodes.keycodeFromName['D']])
      };

  @override
  bool isVisible(ButtonPanelCubit buttonPanelCubit) => true;

  @override
  Future<void> runFunction(
      ButtonPanelCubit buttonPanelCubit, Map<String, String> params) async {
    List<int> keycodes = (jsonDecode(params['keycodes']!) as List<dynamic>)
        .map((e) => e as int)
        .toList();

    final kbd = calloc<INPUT>();
    var result;
    keycodes.forEach((keycode) {
      kbd.ref.type = INPUT_KEYBOARD;
      kbd.ki.wVk = keycode;
      result = SendInput(1, kbd, ffi.sizeOf<INPUT>());
    });
    Sleep(100);
    keycodes.forEach((keycode) {
      kbd.ref.type = INPUT_KEYBOARD;
      kbd.ki.wVk = keycode;
      kbd.ki.dwFlags = KEYEVENTF_KEYUP;
      result = SendInput(1, kbd, ffi.sizeOf<INPUT>());
    });
    free(kbd);

    return Future.value();
  }

  @override
  get title => 'Hotkey';

  @override
  get tooltip => 'Create a Hotkey';
}
