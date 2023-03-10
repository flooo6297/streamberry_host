import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class EdgeInsetsSerializer
    implements JsonConverter<EdgeInsets, Map<String, dynamic>?> {

  final EdgeInsets defaultValue = const EdgeInsets.all(8.0);

  const EdgeInsetsSerializer();

  @override
  EdgeInsets fromJson(Map<String, dynamic>? json) => json==null?defaultValue:EdgeInsets.only(
      left: double.parse(json['left']!),
      top: double.parse(json['top']!),
      right: double.parse(json['right']!),
      bottom: double.parse(json['bottom']!));

  @override
  Map<String, dynamic> toJson(EdgeInsets margin) => {
    'left': "${margin.left}",
    'top': "${margin.top}",
    'right': "${margin.right}",
    'bottom': "${margin.bottom}",
  };
}
