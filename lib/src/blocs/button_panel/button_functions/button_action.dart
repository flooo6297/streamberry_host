import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../button_panel_cubit.dart';

abstract class ButtonAction {

  get title;
  get tooltip;

  String uuid = const Uuid().v1();

  Future<void> runFunction(BuildContext context, List<String> params);

  bool isVisible(BuildContext context);
}