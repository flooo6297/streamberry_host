import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/folder/actions/close_folder_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/folder/actions/open_folder_action.dart';

class FolderFunctions extends ButtonFunctions {

  FolderFunctions() {
    _actions = <ButtonAction>[
      OpenFolderAction(this),
      CloseFolderAction(this),
    ].asMap().map((key, value) => MapEntry(value.actionName, value));
  }

  @override
  get title => 'Folders';

  late Map<String, ButtonAction> _actions;

  @override
  Map<String, ButtonAction> actions() => _actions;

  @override
  get function => 'folderFunctions';
}
