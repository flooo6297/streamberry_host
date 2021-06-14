import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class AlignmentSerializer implements JsonConverter<Alignment, String> {

  const AlignmentSerializer();

  @override
  Alignment fromJson(String json) => Alignment(double.parse(json.split(':')[0]), double.parse(json.split(':')[1]));

  @override
  String toJson(Alignment alignment) => '${alignment.x}:${alignment.y}';

}