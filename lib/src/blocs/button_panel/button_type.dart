
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/default_button.dart';

abstract class ButtonType {

  bool get canBeOverwritten;

  String get type;

  void delete();

  Widget buildButton(ButtonPanelCubit buttonPanelCubit, ButtonData buttonData);

  Widget buildSettings(ButtonPanelCubit buttonPanelCubit, ButtonData buttonData, String id);

}