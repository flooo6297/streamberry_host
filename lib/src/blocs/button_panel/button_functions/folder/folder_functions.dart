
import 'package:flutter/material.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/folder/actions/close_folder_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/folder/actions/open_folder_action.dart';

class FolderFunctions extends ButtonFunctions {

  @override
  get title => 'Folders';

  @override
  Map<String, ButtonAction> actions() => {
    'openAction': OpenFolderAction(),
    'closeAction': CloseFolderAction(),
  };

  Future<void> parseFolderAction(BuildContext context, List<String> action, ButtonData buttonData) async {
    if (action[0] == 'openAction') {
      OpenFolderAction().runFolderFunction(context, buttonData.childState!);
    } else {
      CloseFolderAction().runFunction(context, action..removeAt(0));
    }
  }

}
