import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class EdgeInsetsSerializer
    implements JsonConverter<EdgeInsets, Map<String, double>> {
  const EdgeInsetsSerializer();

  @override
  EdgeInsets fromJson(Map<String, double> json) => EdgeInsets.only(
      left: json['left']!,
      top: json['top']!,
      right: json['right']!,
      bottom: json['bottom']!);

  @override
  Map<String, double> toJson(EdgeInsets margin) => {
    'left': margin.left,
    'top': margin.top,
    'right': margin.right,
    'bottom': margin.bottom,
  };
}
