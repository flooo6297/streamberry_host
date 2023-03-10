import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class SliderButtonBackgroundColorSerializer implements JsonConverter<Color, int?> {
  final Color defaultColor = Colors.white24;

  const SliderButtonBackgroundColorSerializer();

  @override
  Color fromJson(int? json) => json == null ? defaultColor : Color(json);

  @override
  int toJson(Color color) => color.value;

}