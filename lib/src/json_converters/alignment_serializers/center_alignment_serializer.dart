import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class CenterAlignmentSerializer implements JsonConverter<Alignment, String?> {
  final Alignment defaultValue = Alignment.center;

  const CenterAlignmentSerializer();

  @override
  Alignment fromJson(String? json) => json == null
      ? defaultValue
      : Alignment(
          double.parse(json.split(':')[0]), double.parse(json.split(':')[1]));

  @override
  String toJson(Alignment alignment) => '${alignment.x}:${alignment.y}';
}
