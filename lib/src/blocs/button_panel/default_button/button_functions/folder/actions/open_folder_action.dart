import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';

import '../../button_action.dart';

class OpenFolderAction extends ButtonAction {
  late ButtonPanelCubit buttonPanelCubit;

  OpenFolderAction(ButtonFunctions parentType) : super(parentType);

  @override
  Future<void> runFunction(
      ButtonPanelCubit buttonPanelCubit, Map<String, String> params) async {
    return Future.value();
  }

  Future<void> runFolderFunction(
    ButtonPanelCubit buttonPanelCubit,
    ButtonData parentButtonData,
  ) async {
    buttonPanelCubit.path.add(buttonPanelCubit
        .getState()
        .panelList
        .firstWhere((element) => element == (parentButtonData))
        .id);
    buttonPanelCubit.refresh();

    return Future.value();
  }

  @override
  get title => 'Add Folder';

  @override
  get tooltip => 'Adds a folder, that can be opened';

  @override
  bool isVisible(ButtonPanelCubit buttonPanelCubit) => true;

  @override
  Widget buildSettings(
      ButtonPanelCubit buttonPanelCubit,
      ButtonData parentButtonData,
      Map<String, String> params,
      Function(Map<String, String> newParams) madeChanges) {
    return SizedBox(
      height: 50,
      child: Center(
        child: TextButton(
          onPressed: () {
            if (parentButtonData.childState != null) {
              runFolderFunction(buttonPanelCubit, parentButtonData);
            }
          },
          child: const Text(
            'Open Folder',
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
      ),
    );
  }

  @override
  get actionName => 'openAction';

  @override
  Map<String, String> getDefaultParams() => {};
}
