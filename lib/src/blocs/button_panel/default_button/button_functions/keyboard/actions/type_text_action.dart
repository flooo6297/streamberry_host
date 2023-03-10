import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:win32/win32.dart';
import 'dart:ffi' as ffi;

import 'package:ffi/ffi.dart';
import 'package:unicode/unicode.dart' as unicode;

class TypeTextAction extends ButtonAction {
  TypeTextAction(ButtonFunctions parentType) : super(parentType);

  @override
  get actionName => 'typeTextAction';

  @override
  Widget buildSettings(
      ButtonPanelCubit buttonPanelCubit,
      ButtonData parentButtonData,
      Map<String, String> params,
      Function(
    Map<String, String> newParams,
  )
          madeChanges) {
    return _TypeTextActionSettings(buttonPanelCubit, parentButtonData, params, madeChanges);
  }

  @override
  Map<String, String> getDefaultParams() => {'text': 'text to type'};

  @override
  bool isVisible(ButtonPanelCubit buttonPanelCubit) => true;

  @override
  Future<void> runFunction(
      ButtonPanelCubit buttonPanelCubit, Map<String, String> params) async {
    String textToType = params['text'] ?? '';

    final kbd = calloc<INPUT>();
    var result;

    for (int i = 0; i < textToType.length; i++) {
      kbd.ref.ki.wVk = 0;
      kbd.ref.type = INPUT_KEYBOARD;
      kbd.ref.ki.wScan = unicode.toRune(textToType[i]);
      kbd.ref.ki.dwFlags = KEYEVENTF_UNICODE;
      result = SendInput(1, kbd, ffi.sizeOf<INPUT>());
    }

    free(kbd);

    return Future.value();
  }

  @override
  get title => 'Type Text';

  @override
  get tooltip => 'Shortcut to type a text';
}

class _TypeTextActionSettings extends StatefulWidget {
  final ButtonPanelCubit buttonPanelCubit;
  final ButtonData parentButtonData;
  final Map<String, String> params;
  final Function(Map<String, String> newParams) madeChanges;

  const _TypeTextActionSettings(this.buttonPanelCubit, this.parentButtonData,
      this.params, this.madeChanges,
      {Key? key})
      : super(key: key);

  @override
  __TypeTextActionSettingsState createState() =>
      __TypeTextActionSettingsState();
}

class __TypeTextActionSettingsState extends State<_TypeTextActionSettings> {

  late final TextEditingController _textEditingController;


  @override
  void initState() {
    _textEditingController = TextEditingController(text: widget.params['text']??'');
    _textEditingController.addListener(() {
      widget.madeChanges({'text': _textEditingController.text});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Text to type:'),
            SizedBox(height: 8.0,),
            TextField(
              controller: _textEditingController,
              maxLines: null,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Text'
              ),
            ),
          ],
        ),
      ),
    );
  }
}
