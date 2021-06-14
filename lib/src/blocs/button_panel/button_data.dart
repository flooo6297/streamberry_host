import 'dart:convert';
import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_type.dart';
import 'package:streamberry_host/src/blocs/button_panel/button_panel_state.dart';
import 'package:streamberry_host/src/blocs/button_panel/default_button/default_button.dart';
import 'package:uuid/uuid.dart';

part 'button_data.g.dart';

@JsonSerializable()
class ButtonData {
  late String id;
  late bool enabled;
  late double borderWidth;

  @JsonKey(defaultValue: null)
  ButtonPanelState? childState;

  late int height;
  late int width;
  late int positionX;
  late int positionY;

  @JsonKey(includeIfNull: false)
  DefaultButton? defaultButton;

  get canBeOverwritten => (!enabled && ((defaultButton==null)?true:defaultButton!.canBeOverwritten));

  void delete() {
    enabled = false;
    if (defaultButton != null) {
      defaultButton!.delete();
    }
  }

  ButtonData(
    this.positionX,
    this.positionY, {
    this.height = 1,
    this.width = 1,
    this.childState,
    this.enabled = true,
    this.borderWidth = 3.0,
    DefaultButton? defaultButton,
    String? id,
  })  : assert(height > 0),
        assert(width > 0) {
    this.id = id ?? const Uuid().v1();
    this.defaultButton = defaultButton??DefaultButton();
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

  bool operator ==(other) {
    return jsonEncode(this.toJson()) ==
        jsonEncode((other as ButtonData).toJson());
  }

  factory ButtonData.fromJson(Map<String, dynamic> json) =>
      _$ButtonDataFromJson(json);

  Map<String, dynamic> toJson() => _$ButtonDataToJson(this);

  ButtonData copy() {
    return ButtonData.fromJson(jsonDecode(jsonEncode(toJson())));
  }
}
