import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class SliderButtonForegroundColorSerializer implements JsonConverter<Color, int?> {
  final Color defaultColor = Colors.greenAccent;

  const SliderButtonForegroundColorSerializer();

  @override
  Color fromJson(int? json) => json == null ? defaultColor : Color(json);

  @override
  // ignore: unnecessary_null_comparison
  int toJson(Color color) => color.value;

}