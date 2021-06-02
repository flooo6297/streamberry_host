import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_data.dart';
import 'package:streamberry_host/src/json_converters/color_serializer.dart';
import 'package:streamberry_host/src/json_converters/edge_insets_serializer.dart';
import 'package:streamberry_host/src/json_converters/size_serializer.dart';

part 'button_panel_state.g.dart';

@JsonSerializable()
class ButtonPanelState {
  late List<ButtonData> panelList;


  @JsonKey(ignore: true)
  ButtonData? selectedButton;

  @JsonKey(ignore: true)
  ButtonPanelState? defaultPanelOptions;

  late ButtonData nonDefinedButtonDesign;

  @SizeSerializer()
  late Size gridTilingSize;

  @ColorSerializer()
  late Color backgroundColor;

  @EdgeInsetsSerializer()
  late EdgeInsets margin;

  late int xSize;
  late int ySize;

  ButtonPanelState(
      this.xSize, this.ySize, this.gridTilingSize, this.backgroundColor,
  this.margin) {
    panelList = [];

    nonDefinedButtonDesign = ButtonData(0, 0);

    for (int i = 0; i < xSize; i++) {
      for (int j = 0; j < ySize; j++) {
        panelList.add(ButtonData(i, j, enabled: false));
      }
    }
  }

  ButtonPanelState.asDefaultPanelSettings(this.xSize, this.ySize,
      this.gridTilingSize, this.backgroundColor, this.margin);

  ButtonPanelState.copy(ButtonPanelState stateToCopy) {
    gridTilingSize = stateToCopy.gridTilingSize;
    xSize = stateToCopy.xSize;
    ySize = stateToCopy.ySize;
    panelList = List<ButtonData>.of(stateToCopy.panelList);
    backgroundColor = stateToCopy.backgroundColor;
    selectedButton = stateToCopy.selectedButton;
    margin = stateToCopy.margin;
    nonDefinedButtonDesign = stateToCopy.nonDefinedButtonDesign;
    defaultPanelOptions = stateToCopy.defaultPanelOptions;
  }




  factory ButtonPanelState.fromJson(Map<String, dynamic> json) => _$ButtonPanelStateFromJson(json);

  Map<String, dynamic> toJson() => _$ButtonPanelStateToJson(this);
}
