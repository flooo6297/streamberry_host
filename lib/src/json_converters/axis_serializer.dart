import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class AxisSerializer implements JsonConverter<Axis, String> {

  const AxisSerializer();

  @override
  Axis fromJson(String json) => json=='vertical'?Axis.vertical:Axis.horizontal;

  @override
  String toJson(Axis axis) => '${axis == Axis.vertical?'vertical':'horizontal'}';

}