import 'package:flutter/material.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/folder/folder_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';

class CloseFolderAction extends ButtonAction {

  CloseFolderAction(FolderFunctions parentType) : super(parentType);

  @override
  bool isVisible(ButtonPanelCubit buttonPanelCubit) => buttonPanelCubit.path.length>0;

  @override
  Future<void> runFunction(
    ButtonPanelCubit buttonPanelCubit, Map<String, String> params,
  ) async {
    buttonPanelCubit.path.removeLast();
    buttonPanelCubit.refresh();
    return Future.value();
  }

  Future<void> runFolderFunction(
    ButtonPanelCubit buttonPanelCubit,
    ButtonPanelState buttonPanelState,
  ) async {
    buttonPanelCubit.path.removeLast();
    buttonPanelCubit.refresh();
    return Future.value();
  }

  @override
  get title => 'Close the current folder';

  @override
  get tooltip => '';

  @override
  Widget buildSettings(ButtonPanelCubit buttonPanelCubit,
      ButtonData parentButtonData, Map<String, String> params, Function(Map<String, String> newParams) madeChanges) {
    return SizedBox(
      height: 50,
      child: Center(
        child: TextButton(
          onPressed: () {
            runFunction(buttonPanelCubit, params);
          },
          child: const Text('Close Folder'),
        ),
      ),
    );
  }

  @override
  get actionName => 'closeAction';

  @override
  Map<String, String> getDefaultParams() => {};
}
