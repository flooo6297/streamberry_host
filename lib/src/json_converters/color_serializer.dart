import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class ColorSerializer implements JsonConverter<Color, int> {
  static const Color defaultColor = Colors.white;

  const ColorSerializer();

  @override
  // ignore: unnecessary_null_comparison
  Color fromJson(int json) => json == null ? defaultColor : Color(json);

  @override
  // ignore: unnecessary_null_comparison
  int toJson(Color color) => color == null ? defaultColor.value : color.value;

}