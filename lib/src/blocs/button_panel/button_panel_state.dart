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

  String name = 'Folder';

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

  late double borderRadius;

  late int xSize;
  late int ySize;

  ButtonPanelState(this.xSize, this.ySize, this.gridTilingSize,
      this.backgroundColor, this.margin, this.name, this.borderRadius) {
    panelList = [];

    nonDefinedButtonDesign = ButtonData(0, 0);

    for (int i = 0; i < xSize; i++) {
      for (int j = 0; j < ySize; j++) {
        panelList.add(ButtonData(i, j, enabled: false));
      }
    }
  }

  ButtonPanelState.asDefaultPanelSettings(
      this.xSize,
      this.ySize,
      this.gridTilingSize,
      this.backgroundColor,
      this.margin,
      this.name,
      this.borderRadius,
      this.nonDefinedButtonDesign) {
    panelList = [];
  }

  ButtonPanelState.copy(ButtonPanelState stateToCopy,
      {bool ignoreDefaultPanelOptions = false}) {
    gridTilingSize = stateToCopy.gridTilingSize;
    xSize = stateToCopy.xSize;
    ySize = stateToCopy.ySize;
    panelList = [];
    if (stateToCopy.panelList.isNotEmpty) {
      panelList.removeRange(0, panelList.length);
      panelList.addAll(List<ButtonData>.of(stateToCopy.panelList));
    } else {
      for (int i = 0; i < xSize; i++) {
        for (int j = 0; j < ySize; j++) {
          panelList.add(ButtonData(i, j, enabled: false));
        }
      }
    }
    backgroundColor = stateToCopy.backgroundColor;
    selectedButton = stateToCopy.selectedButton;
    margin = stateToCopy.margin;
    nonDefinedButtonDesign = stateToCopy.nonDefinedButtonDesign;
    if (!ignoreDefaultPanelOptions) {
      defaultPanelOptions = stateToCopy.defaultPanelOptions;
    } else {
      defaultPanelOptions = null;
    }
    name = stateToCopy.name;
    borderRadius = stateToCopy.borderRadius;
  }

  ButtonData? getButtonDataById(String id) {
    Iterable<ButtonData> buttons =
        panelList.where((element) => element.id == id);
    if (buttons.isEmpty) {
      return null;
    }
    return buttons.first;
  }

  factory ButtonPanelState.fromJson(Map<String, dynamic> json) =>
      _$ButtonPanelStateFromJson(json);

  Map<String, dynamic> toJson() => _$ButtonPanelStateToJson(this);
}
