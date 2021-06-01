import 'package:flutter/material.dart';
import 'package:streamberry_host/src/app.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_action.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/folder/folder_functions.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/param_value.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_host/src/ui/views/button_view/button_view.dart';

class CloseFolderAction extends ButtonAction {
  late ButtonPanelCubit buttonPanelCubit;

  @override
  bool isVisible(BuildContext context) => Navigator.canPop(context);

  @override
  Future<void> runFunction(
    BuildContext context,
  ) async {
    App.buttonPanelCubitOf(context).path.removeLast();
    App.buttonPanelCubitOf(context).refresh();
    return Future.value();
  }

  Future<void> runFolderFunction(
      BuildContext context,
      ButtonPanelState buttonPanelState,
      ) async {

    App.buttonPanelCubitOf(context).path.removeLast();
    App.buttonPanelCubitOf(context).refresh();

    return Future.value();
  }

  @override
  get title => 'Close the current folder';

  @override
  get tooltip => '';

  @override
  void setParams(Map<String, String> params) {
  }

  @override
  Widget buildSettings(BuildContext context, ButtonData parentButtonData) {
    return SizedBox(
      height: 50,
      child: Center(
        child: TextButton(onPressed: () {
          runFunction(context);
        },
          child: const Text('Close Folder'),),
      ),
    );
  }

  @override
  get actionName => 'closeAction';

  @override
  Map<String, String> getParams() => {};

  @override
  ButtonFunctions getParentType() => FolderFunctions();
}
