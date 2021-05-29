import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/folder/actions/close_folder_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/folder/folder_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_host/src/ui/views/button_view.dart';

import '../../button_action.dart';

class OpenFolderAction extends ButtonAction {
  late final ButtonPanelCubit buttonPanelCubit;

  @override
  Future<void> runFunction(
      BuildContext context,
      List<String> params,
      ) async {
    buttonPanelCubit = ButtonPanelCubit.init(8, 4);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ButtonView(buttonPanelCubit: buttonPanelCubit)));

    return Future.value();
  }

  Future<void> runFolderFunction(
      BuildContext context,
      ButtonPanelState buttonPanelState,
      ) async {
    buttonPanelCubit = ButtonPanelCubit(buttonPanelState);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ButtonView(buttonPanelCubit: buttonPanelCubit)));

    return Future.value();
  }

  @override
  get title => 'Add Folder';

  @override
  get tooltip => '';

  @override
  bool isVisible(BuildContext context) => true;
}
