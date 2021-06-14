import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/keyboard/actions/hotkey_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/keyboard/actions/type_text_action.dart';

class KeyboardFunctions extends ButtonFunctions {

  late Map<String, ButtonAction> _actions;

  KeyboardFunctions() {
    _actions = <ButtonAction>[
      HotkeyAction(this),
      TypeTextAction(this),
    ].asMap().map((key, value) => MapEntry(value.actionName, value));
  }

  @override
  Map<String, ButtonAction> actions() => _actions;

  @override
  get function => 'keyboardFunctions';

  @override
  get title => 'Keyboard';

}
