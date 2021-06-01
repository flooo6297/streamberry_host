import 'package:json_annotation/json_annotation.dart';

part 'on_click.g.dart';

@JsonSerializable()
class OnClick {
  String function;

  String action;

  Map<String, String> params;

  OnClick(this.function, this.action, {this.params = const {}});

  bool equals(OnClick onClick) {
    if (function != onClick.function) {
      return false;
    }
    if (action != onClick.action) {
      return false;
    }
    if (params.length != onClick.params.length) {
      return false;
    }
    bool paramsAreEqual = true;
    params.forEach((key, value) {
      if (onClick.params.containsKey(key)) {
        if (value != onClick.params[key]) {
          paramsAreEqual = false;
        }
      } else {
        paramsAreEqual = false;
      }

    });
    return paramsAreEqual;
  }

  factory OnClick.fromJson(Map<String, dynamic> json) => _$OnClickFromJson(json);

  Map<String, dynamic> toJson() => _$OnClickToJson(this);

}