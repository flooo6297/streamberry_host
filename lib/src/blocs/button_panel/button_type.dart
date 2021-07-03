
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/default_button.dart';
import 'package:streamberry_host/src/blocs/button_panel/slider_button/slider_button.dart';

abstract class ButtonType {

  bool get canBeOverwritten;

  String get type;

  String get name;

  IconData get listIcon;

  void delete();

  Widget buildButton(ButtonPanelCubit buttonPanelCubit, ButtonData buttonData);

  Widget buildSettings(ButtonPanelCubit buttonPanelCubit, ButtonData buttonData, String id);

  Map<String, dynamic> toJson();

  static Map<String, Function(Map<String, dynamic> json)> createNewTypeList = {
    'defaultButton': (Map<String, dynamic> json) => DefaultButton.fromJson(json),
    'sliderButton': (Map<String, dynamic> json) => SliderButton.fromJson(json),
  };

  static Map<String, Function()> types = {
  'defaultButton': () => DefaultButton(),
  'sliderButton': () => SliderButton(),
  };

  static ButtonType fromJson(Map<String, dynamic> json) {
    return createNewTypeList[json['type'] as String]!(json['data']! as Map<String, dynamic>);
  }

}