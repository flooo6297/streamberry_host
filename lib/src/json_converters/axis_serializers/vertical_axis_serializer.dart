import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class VerticalAxisSerializer implements JsonConverter<Axis, String?> {

  final Axis defaultValue = Axis.vertical;

  const VerticalAxisSerializer();

  @override
  Axis fromJson(String? json) => json==null?defaultValue:(json=='vertical'?Axis.vertical:Axis.horizontal);

  @override
  String toJson(Axis axis) => '${axis == Axis.vertical?'vertical':'horizontal'}';

}