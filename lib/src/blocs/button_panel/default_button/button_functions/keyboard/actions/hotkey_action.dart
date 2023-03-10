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
    return _HotKeyActionSettings(
        buttonPanelCubit, parentButtonData, params, madeChanges);
  }

  @override
  Map<String, String> getDefaultParams() => {
        'keycodes': jsonEncode(
            [Keycodes.keycodeFromName['L-Win'], Keycodes.keycodeFromName['D']])
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
      kbd.ref.ki.wVk = keycode;
      result = SendInput(1, kbd, ffi.sizeOf<INPUT>());
    });
    Sleep(100);
    keycodes.forEach((keycode) {
      kbd.ref.type = INPUT_KEYBOARD;
      kbd.ref.ki.wVk = keycode;
      kbd.ref.ki.dwFlags = KEYEVENTF_KEYUP;
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

class _HotKeyActionSettings extends StatefulWidget {
  final ButtonPanelCubit buttonPanelCubit;
  final ButtonData parentButtonData;
  final Map<String, String> params;
  final Function(Map<String, String> newParams) madeChanges;

  const _HotKeyActionSettings(this.buttonPanelCubit, this.parentButtonData,
      this.params, this.madeChanges,
      {Key? key})
      : super(key: key);

  @override
  __HotKeyActionSettingsState createState() => __HotKeyActionSettingsState();
}

class __HotKeyActionSettingsState extends State<_HotKeyActionSettings> {
  @override
  Widget build(BuildContext context) {
    List<int> keycodesList =
        (jsonDecode(widget.params['keycodes']!) as List<dynamic>)
            .map((e) => e as int)
            .toList();

    Map<int, String> keycodes = keycodesList
        .asMap()
        .map((key, value) => MapEntry(value, Keycodes.nameFromKeycode[value]!));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 50,
          child: Center(
            child: Text('Hotkey-Action'),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Text(keycodes.entries.elementAt(index).value)),
                    IconButton(
                        onPressed: () {
                          keycodes.removeWhere((key, value) =>
                              key == keycodes.entries.elementAt(index).key);
                          List<int> newKeycodes = keycodes.keys.toList();

                          widget.params['keycodes'] = jsonEncode(newKeycodes);

                          widget.madeChanges(widget.params);
                          setState(() {});
                        },
                        icon: Icon(Icons.delete)),
                  ],
                ),
              ),
            );
          },
          itemCount: keycodes.length,
        ),
        PopupMenuButton<int>(
          onSelected: (keycode) {
            keycodes[keycode] = Keycodes.nameFromKeycode[keycode]!;
            List<int> newKeycodes = keycodes.keys.toList();

            widget.params['keycodes'] = jsonEncode(newKeycodes);

            widget.madeChanges(widget.params);
            setState(() {});

            //Navigator.of(context).pop();
          },
          itemBuilder: (context) {
            return Keycodes.nameFromKeycode.keys.map((keycode) {
              return PopupMenuItem<int>(
                value: keycode,
                child: Text('${Keycodes.nameFromKeycode[keycode]}'),
              );
            }).toList();
          },
          child: Container(
            height: 50,
            child: Center(
              child: Text('Add new Key to Action'),
            ),
          ),
        ),
      ],
    );
  }
}
