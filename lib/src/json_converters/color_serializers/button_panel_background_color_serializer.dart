import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class ButtonPanelBackgroundColorSerializer implements JsonConverter<Color, int?> {
  final Color defaultColor = Colors.black;

  const ButtonPanelBackgroundColorSerializer();

  @override
  Color fromJson(int? json) => json == null ? defaultColor : Color(json);

  @override
  int toJson(Color color) => color.value;

}