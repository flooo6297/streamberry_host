import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_cubit.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_type.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/button_functions/on_click.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/default_button_settings.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/default_button_widget.dart';
import 'package:streamberry_host/src/json_converters/alignment_serializer.dart';
import 'package:streamberry_host/src/json_converters/color_serializer.dart';

part 'default_button.g.dart';

@JsonSerializable()
class DefaultButton extends ButtonType {
  @ColorSerializer()
  late Color color;

  List<OnClick> onClicks = [];

  String image = '';

  String text = '';

  late double textSize;

  @AlignmentSerializer()
  late Alignment textAlignment;

  late bool snapToGrid;

  @JsonKey(defaultValue: 0xFFFFFFFF)
  late int textColorValue;

  @JsonKey(ignore: true)
  Color get textColor => Color(textColorValue);

  @JsonKey(ignore: true)
  set textColor(Color color) => textColorValue = color.value;

  DefaultButton({
    this.color = Colors.white24,
    List<OnClick> onClicks = const [],
    this.image = '',
    this.text = 'Button',
    this.textAlignment = Alignment.center,
    this.snapToGrid = true,
    this.textSize = 14.0,
    int textColorValue = 0xFFFFFFFF,
  }) {
    this.onClicks.addAll(onClicks);
    this.textColorValue = textColorValue;
  }

  @override
  bool get canBeOverwritten => onClicks.isEmpty;

  @override
  void delete() {
    onClicks.clear();
  }

  factory DefaultButton.fromJson(Map<String, dynamic> json) =>
      _$DefaultButtonFromJson(json);

  Map<String, dynamic> toJson() => _$DefaultButtonToJson(this);

  @override
  Widget buildButton(
          ButtonPanelCubit buttonPanelCubit, ButtonData buttonData) =>
      DefaultButtonWidget(buttonPanelCubit, buttonData);

  @override
  String get type => 'defaultButton';

  @override
  Widget buildSettings(ButtonPanelCubit buttonPanelCubit, ButtonData buttonData,
          String id) =>
      DefaultButtonSettings(
        buttonPanelCubit,
        buttonData,
        selectedId: id,
      );
}
