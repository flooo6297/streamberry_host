import 'package:flutter/material.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_functions/button_action.dart';

class CloseFolderAction extends ButtonAction {
  @override
  bool isVisible(BuildContext context) => Navigator.canPop(context);

  @override
  Future<void> runFunction(
    BuildContext context,
    List<String> params,
  ) async {
    Navigator.pop(context);
    return Future.value();
  }

  @override
  get title => 'Close the current folder';

  @override
  get tooltip => '';
}
