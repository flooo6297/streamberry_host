import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

class SizeSerializer implements JsonConverter<Size, String> {

  const SizeSerializer();

  @override
  Size fromJson(String json) => Size(double.parse(json.split(':')[0]), double.parse(json.split(':')[1]));

  @override
  String toJson(Size size) => '${size.width}:${size.height}';

}