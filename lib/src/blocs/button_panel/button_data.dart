import 'dart:math';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_host/src/json_converters/color_serializer.dart';
import 'package:streamberry_host/src/json_converters/edge_insets_serializer.dart';

part 'button_data.g.dart';

@JsonSerializable()
class ButtonData {

  @ColorSerializer()
  late Color color;


  late int height;
  late int width;
  late int positionX;
  late int positionY;

  List<String> functions = [];
  late bool enabled;

  @JsonKey(defaultValue: null)
  ButtonPanelState? childState;

  get canBeOverwritten => (!enabled && functions.isEmpty);

  void delete() {
    enabled = false;
    functions.clear();
  }

  ButtonData(
    this.positionX,
    this.positionY, {
    this.color = Colors.white24,
    this.height = 1,
    this.width = 1,
    List<String> functions = const [],
    this.enabled = true,
    this.childState,
  })  : assert(height > 0),
        assert(width > 0) {
    this.functions.addAll(functions);
  }

  ButtonData.copy(ButtonData buttonData) {
    positionY = buttonData.positionY;
    positionX = buttonData.positionX;
    color = buttonData.color;
    height = buttonData.height;
    width = buttonData.width;
    functions.addAll(buttonData.functions);
    enabled = buttonData.enabled;
  }

  bool overlaps(ButtonData button) {
    Point l1 = Point(positionX, positionY);
    Point r1 = Point(positionX + width, positionY + height);
    Point l2 = Point(button.positionX, button.positionY);
    Point r2 = Point(
        button.positionX + button.width, button.positionY + button.height);
    if (l1.x == r1.x || l1.y == r2.y || l2.x == r2.x || l2.y == r2.y) {
      return false;
    }
    if (l1.x >= r2.x || l2.x >= r1.x) {
      return false;
    }
    if (l1.y >= r2.y || l2.y >= r1.y) {
      return false;
    }
    return true;
  }

  bool equals(ButtonData buttonData) {
    bool actionListsAreSame = true;
    if (functions.length != buttonData.functions.length) {
      actionListsAreSame = false;
    } else {
      if (functions.length > buttonData.functions.length) {
        for (String action in functions) {
          if (buttonData.functions
              .where((element) => element == action)
              .isEmpty) {
            actionListsAreSame = false;
          }
        }
      } else {
        for (String action in buttonData.functions) {
          if (functions.where((element) => element == action).isEmpty) {
            actionListsAreSame = false;
          }
        }
      }
    }

    return positionY == buttonData.positionY &&
        positionX == buttonData.positionX &&
        color == buttonData.color &&
        height == buttonData.height &&
        width == buttonData.width &&
        actionListsAreSame &&
        enabled == buttonData.enabled;
  }


  factory ButtonData.fromJson(Map<String, dynamic> json) => _$ButtonDataFromJson(json);

  Map<String, dynamic> toJson() => _$ButtonDataToJson(this);

}
