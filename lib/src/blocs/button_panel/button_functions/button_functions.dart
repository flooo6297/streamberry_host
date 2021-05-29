import 'package:flutter/cupertino.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/folder/folder_functions.dart';

import 'button_action.dart';

abstract class ButtonFunctions{
  //List<Function()> actions();

  Map<String, ButtonAction> actions();

  get title;

  static Map<String, ButtonFunctions> functions = {
    'folderFunctions': FolderFunctions(),
  };

  Future<void> parseAction(List<String> action, BuildContext context) async {
    if (actions().keys.contains(action[0])) {
      await actions()[action]!.runFunction(context, action..removeAt(0));
    }
    return Future.value();
  }

  static Future<void> parse(ButtonData buttonData, BuildContext context) async {

    for (String function in buttonData.functions) {
      List<String> path = function.split(':');
      if (path.length > 1) {
        if (path[0] == 'folderFunctions') {
          (functions[path[0]] as FolderFunctions).parseFolderAction(context, path..removeAt(0), buttonData);
        } else if (functions.keys.contains(path[0])) {
          await functions[path[0]]!.parseAction(path..removeAt(0), context);
        }
      }
    }

    return Future.value();

  }

}