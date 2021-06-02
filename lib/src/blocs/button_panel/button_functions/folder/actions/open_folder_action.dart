import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:streamberry_host/src/app.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/folder/actions/close_folder_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/folder/folder_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/param_value.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_host/src/ui/views/button_view/button_view.dart';

import '../../button_action.dart';

class OpenFolderAction extends ButtonAction {
  late ButtonPanelCubit buttonPanelCubit;

  @override
  Future<void> runFunction(
    ButtonPanelCubit buttonPanelCubit,
  ) async {
    return Future.value();
  }

  Future<void> runFolderFunction(
    ButtonPanelCubit buttonPanelCubit,
    ButtonData parentButtonData,
  ) async {
    buttonPanelCubit.path.add(buttonPanelCubit
        .getState()
        .panelList
        .indexWhere((element) => element.equals(parentButtonData)));
    buttonPanelCubit.refresh();

    return Future.value();
  }

  @override
  get title => 'Add Folder';

  @override
  get tooltip => 'Adds a folder, that can be opened';

  @override
  bool isVisible(BuildContext context) => true;

  @override
  void setParams(Map<String, String> params) {  }

  @override
  Widget buildSettings(
      ButtonPanelCubit buttonPanelCubit,
      ButtonData parentButtonData,
      Function(ButtonAction newAction) madeChanges) {
    return SizedBox(
      height: 50,
      child: Center(
        child: TextButton(
          onPressed: () {
            if (parentButtonData.childState != null) {
              runFolderFunction(buttonPanelCubit, parentButtonData);
            }
          },
          child: const Text('Open Folder', softWrap: false, overflow: TextOverflow.fade,),
        ),
      ),
    );
  }

  @override
  get actionName => 'openAction';

  @override
  Map<String, String> getParams() => {};

  @override
  ButtonFunctions getParentType() => FolderFunctions();
}
